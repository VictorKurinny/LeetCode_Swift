//
//  _0065bTests.swift
//  LeetCodeTests
//
//  Created by Victor Kurinny on 19.03.2020.
//  Copyright © 2020 Victor Kurinny. All rights reserved.
//

// https://leetcode.com/problems/valid-number/
// Flexible solution

import XCTest

private let endOfLineSymbol: Character = "\n"
private let spaceSymbol: Character = " "
private let naturalNumberSymbol: Character = "n"

private class Node {
    let symbolToEnterNode: Character
    let nextNodes: [Node]

    init(symbolToEnterNode: Character, nextNodes: [Node] = []) {
        self.symbolToEnterNode = symbolToEnterNode
        self.nextNodes = nextNodes
    }
}

private protocol SymbolProcessing {
    func isValid(_ symbol: Character) -> Bool
    func process(_ symbol: Character) -> (processedSymbol: Character, allowMultiple: Bool)
}

private class NumberSymbolProcessor: SymbolProcessing {
    func isValid(_ symbol: Character) -> Bool {
        return symbol.isNumber || validSpecialSymbols.contains(symbol)
    }

    func process(_ symbol: Character) -> (processedSymbol: Character, allowMultiple: Bool) {
        if symbol.isNumber {
            return (processedSymbol: naturalNumberSymbol, allowMultiple: true)
        } else {
            return (processedSymbol: symbol, allowMultiple: symbol.isWhitespace)
        }
    }

    private lazy var validSpecialSymbols: Set<Character> = Set([" ", "e", ".", "+", "-"])
}

private class Composer {
    func composeNumberSymbolProcessor() -> SymbolProcessing {
        return NumberSymbolProcessor()
    }

    func composePosibleNumbersValidationNodes() -> [Node] {
        let end = [Node(symbolToEnterNode: endOfLineSymbol)]
        let possibleSpaceAtEnd = possibleSpace(nextNodes: end)
        let number = floatPointNumberWithExponent(nextNodes: possibleSpaceAtEnd)
        let possibleSpaceAtStart = possibleSpace(nextNodes: number)
        return [Node(symbolToEnterNode: spaceSymbol, nextNodes: possibleSpaceAtStart)]
    }

    private func naturalNumber(nextNodes: [Node] = []) -> [Node] {
        return [Node(symbolToEnterNode: naturalNumberSymbol, nextNodes: nextNodes)]
    }

    private func wholeNumber(nextNodes: [Node] = []) -> [Node] {
        let natural = naturalNumber(nextNodes: nextNodes)
        return possibleSign(nextNodes: natural)
    }

    private func floatPointNumber(nextNodes: [Node] = []) -> [Node] {
        let digits = naturalNumber(nextNodes: nextNodes)
        let pointAndDigits = [Node(symbolToEnterNode: ".", nextNodes: digits)]
        let point = [Node(symbolToEnterNode: ".", nextNodes: nextNodes)]
        let reqularFloatPointNumber = wholeNumber(nextNodes: pointAndDigits)
        let floatPointNumberWithoutLeadingDigits = possibleSign(nextNodes: pointAndDigits)
        let floatPointNumberWithoutTrailingDigits = wholeNumber(nextNodes: point)

        return reqularFloatPointNumber +
            floatPointNumberWithoutLeadingDigits +
            floatPointNumberWithoutTrailingDigits +
            wholeNumber(nextNodes: nextNodes)
    }

    private func floatPointNumberWithExponent(nextNodes: [Node] = []) -> [Node] {
        let floatPoint = floatPointNumber(nextNodes: nextNodes)
        let power = wholeNumber(nextNodes: nextNodes)
        let exponent = [Node(symbolToEnterNode: "e", nextNodes: power)]
        let floatPointWithExponent = floatPointNumber(nextNodes: exponent)
        return floatPoint + floatPointWithExponent
    }

    private func possibleSpace(nextNodes: [Node] = []) -> [Node] {
        let space = [Node(symbolToEnterNode: spaceSymbol, nextNodes: nextNodes)]
        return possible(space, nextNodes: nextNodes)
    }

    private func possibleSign(nextNodes: [Node] = []) -> [Node] {
        let sign = [
            Node(symbolToEnterNode: "+", nextNodes: nextNodes),
            Node(symbolToEnterNode: "-", nextNodes: nextNodes)
        ]
        return possible(sign, nextNodes: nextNodes)
    }

    private func possible(_ possibleNodes: [Node], nextNodes: [Node]) -> [Node] {
        return possibleNodes + nextNodes
    }
}

private class Solution {
    func isNumber(_ input: String) -> Bool {
        var currentNodes = validationNodes
        var lastSymbol: Character?

        let moveToNextNodesWithSymbol = { (symbol: Character) -> Void in
            currentNodes = currentNodes
                .map { $0.nextNodes }
                .joined()
                .filter { $0.symbolToEnterNode == symbol }
        }

        for symbol in input {
            if symbolProcessor.isValid(symbol) {
                let (processedSymbol, allowMultiple) = symbolProcessor.process(symbol)

                if !allowMultiple || (lastSymbol != processedSymbol) {
                    moveToNextNodesWithSymbol(processedSymbol)
                    lastSymbol = processedSymbol
                }
            } else {
                return false
            }

            if currentNodes.isEmpty {
                return false
            }
        }

        moveToNextNodesWithSymbol(endOfLineSymbol)

        return !currentNodes.isEmpty
    }

    private let symbolProcessor = Composer().composeNumberSymbolProcessor()
    private let validationNodes = Composer().composePosibleNumbersValidationNodes()
}

class _0065bTests: XCTestCase {
    func test_examples() {
        expect(true, for: "0")
        expect(true, for: " 0.1 ")
        expect(false, for: "abc")
        expect(false, for: "1 a")
        expect(true, for: "2e10")
        expect(true, for: " -90e3   ")
        expect(false, for: " 1e")
        expect(false, for: "e3")
        expect(true, for: " 6e-1")
        expect(false, for: " 99e2.5 ")
        expect(true, for: "53.5e93")
        expect(false, for: " --6 ")
        expect(false, for: "-+3")
        expect(false, for: "95a54e53")
    }

    func test_detectsLongNumber() {
        expect(true, for: "-123456789012.34567890e12345678901234567890")
    }

    func test_edgeCases() {
        expect(true, for: "-.1")
        expect(true, for: "-1.")
        expect(false, for: "6en")
    }

    // MARK: - Helper methods

    private func expect(_ expectedResult: Bool, for input: String, file: StaticString = #file, line: UInt = #line) {
        let result = Solution().isNumber(input)

        XCTAssertEqual(expectedResult, result, "Expected \(expectedResult), got \(result) instead for input \(input)", file: file, line: line)
    }
}
