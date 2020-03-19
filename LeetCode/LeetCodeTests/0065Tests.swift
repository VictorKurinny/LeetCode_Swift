//
//  _0065Tests.swift
//  LeetCodeTests
//
//  Created by Victor Kurinny on 19.03.2020.
//  Copyright © 2020 Victor Kurinny. All rights reserved.
//

// https://leetcode.com/problems/valid-number/

import XCTest

private enum _0065 {
    class Solution {
        func isNumber(_ input: String) -> Bool {
            var isWhiteSpacesSkippedAtStart = false
            var isProcessingWhiteSpacesAtFinish = false
            var processedInput = [Character]()
            var lastSymbol: Character = " "
            var specialSymbolsLimit: [Character: Int] = [
                "e": 1,
                "+": 2,
                "-": 2,
                ".": 1
            ]

            for currentSymbol in input {
                let isWhiteSpace = currentSymbol.isWhitespace

                if !isWhiteSpacesSkippedAtStart {
                    if isWhiteSpace {
                        continue
                    } else {
                        isWhiteSpacesSkippedAtStart = true
                    }
                }

                if isWhiteSpace {
                    isProcessingWhiteSpacesAtFinish = true
                    continue
                } else if isProcessingWhiteSpacesAtFinish {
                    return false
                } else {
                    if currentSymbol.isNumber {
                        if lastSymbol != "1" {
                            processedInput.append("1")
                            lastSymbol = "1"
                        }
                    } else {
                        let limit = specialSymbolsLimit[currentSymbol] ?? 0
                        if limit <= 0 {
                            return false
                        } else {
                            specialSymbolsLimit[currentSymbol] = limit - 1
                            processedInput.append(currentSymbol)
                            lastSymbol = currentSymbol
                        }
                    }
                }
            }

            return Double(String(processedInput)) != nil
        }
    }
}

class _0065Tests: XCTestCase {
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

    // MARK: - Helper methods

    private func expect(_ expectedResult: Bool, for input: String, file: StaticString = #file, line: UInt = #line) {
        let result = _0065.Solution().isNumber(input)

        XCTAssertEqual(expectedResult, result, "Expected \(expectedResult), got \(result) instead", file: file, line: line)
    }
}
