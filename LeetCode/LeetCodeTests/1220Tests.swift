//
//  1220Tests.swift
//  LeetCodeTests
//
//  Created by Victor Kurinny on 27.02.2020.
//  Copyright © 2020 Victor Kurinny. All rights reserved.
//

// https://leetcode.com/problems/count-vowels-permutation/

import XCTest

private enum _1220 {
    struct Modulo {
        let value: Int
        static let one = Modulo(1)

        init(_ value: Int) {
            self.value = value % 1_000_000_007
        }

        static func +(left: Modulo, right: Modulo) -> Modulo {
            return Modulo(left.value + right.value)
        }
    }

    struct CountByLastSymbol {
        var A: Modulo
        var E: Modulo
        var I: Modulo
        var O: Modulo
        var U: Modulo
    }

    class Solution {
        func countVowelPermutation(_ n: Int) -> Int {
            var counts = CountByLastSymbol(A: .one, E: .one, I: .one, O: .one, U: .one)

            for _ in 0..<(n-1) {
                counts = CountByLastSymbol(
                    A: counts.E + counts.I + counts.U,
                    E: counts.A + counts.I,
                    I: counts.E + counts.O,
                    O: counts.I,
                    U: counts.I + counts.O)
            }

            return (counts.A + counts.E + counts.I + counts.O + counts.U).value
        }
    }
}

private class _1220Tests: XCTestCase {
    func test_example1() {
        expect(5, for: 1)
    }

    func test_example2() {
        expect(10, for: 2)
    }

    func test_example3() {
        expect(68, for: 5)
    }

    func test_answerIsCorrect_forMaxInput() {
        expect(759959057, for: 20_000)
    }

    // MARK: - Helper methods

    func expect(_ expectedResult: Int, for input: Int, file: StaticString = #file, line: UInt = #line) {
        let result = _1220.Solution().countVowelPermutation(input)

        XCTAssertEqual(expectedResult, result, file: file, line: line)
    }
}
