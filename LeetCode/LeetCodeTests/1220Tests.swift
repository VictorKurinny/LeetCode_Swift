//
//  1220Tests.swift
//  LeetCodeTests
//
//  Created by Victor Kurinny on 27.02.2020.
//  Copyright © 2020 Victor Kurinny. All rights reserved.
//

// https://leetcode.com/problems/count-vowels-permutation/

import XCTest

struct Modulo {
    let value: Int

    static func +(left: Modulo, right: Modulo) -> Modulo {
        let mode = 1_000_000_007
        let sum = left.value + right.value
        if sum >= mode {
            return Modulo(value: sum - mode)
        } else {
            return Modulo(value: sum)
        }
    }
}

extension Modulo {
    static let one = Modulo(value: 1)
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
            let tempCounts = CountByLastSymbol(
                A: counts.E + counts.I + counts.U,
                E: counts.A + counts.I,
                I: counts.E + counts.O,
                O: counts.I,
                U: counts.I + counts.O)

            counts = tempCounts
        }

        return (counts.A + counts.E + counts.I + counts.O + counts.U).value
    }
}

class _1220Tests: XCTestCase {
    func test_example1() {
        let result = Solution().countVowelPermutation(1)

        XCTAssertEqual(5, result)
    }

    func test_example2() {
        let result = Solution().countVowelPermutation(2)

        XCTAssertEqual(10, result)
    }

    func test_example3() {
        let result = Solution().countVowelPermutation(5)

        XCTAssertEqual(68, result)
    }

    func test_answerIsCorrect_forMaxInput() {
        let result = Solution().countVowelPermutation(20_000)

        XCTAssertEqual(759959057, result)
    }
}
