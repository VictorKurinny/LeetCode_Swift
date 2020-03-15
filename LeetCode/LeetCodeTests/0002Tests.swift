//
//  0002Tests.swift
//  LeetCodeTests
//
//  Created by Victor Kurinny on 15.03.2020.
//  Copyright © 2020 Victor Kurinny. All rights reserved.
//

// https://leetcode.com/problems/add-two-numbers/

import XCTest

private enum _0002 {
    class ListNode {
        var val: Int
        var next: ListNode?

        init(_ val: Int) {
            self.val = val
            self.next = nil
        }
    }

    class Solution {
        func addTwoNumbers(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
            var resultHead: ListNode?
            var resultTail: ListNode!
            var list1Pointer = list1
            var list2Pointer = list2
            var carry = 0

            let appendNode = { (node: ListNode) -> Void in
                resultTail.next = node
                resultTail = node
            }

            let digitFromPointer = { (pointer: ListNode?) -> Int in
                guard let pointer = pointer else { return 0 }

                return pointer.val
            }

            while (list1Pointer != nil) || (list2Pointer != nil) {
                let sum = digitFromPointer(list1Pointer) + digitFromPointer(list2Pointer) + carry
                carry = sum / 10
                let newNode = ListNode(sum % 10)

                if resultHead == nil {
                    resultHead = newNode
                    resultTail = newNode
                } else {
                    appendNode(newNode)
                }

                list1Pointer = list1Pointer?.next
                list2Pointer = list2Pointer?.next
            }

            if carry > 0 {
                appendNode(ListNode(carry))
            }

            return resultHead
        }
    }
}

private class _0002Tests: XCTestCase {
    func test_onePlusOneEqualsTwo() {
        let one = list(from: [1])

        let result = _0002.Solution().addTwoNumbers(one, one)

        XCTAssertEqual([2], digits(from: result))
    }

    func test_ninePlusThreeEqualsTwelve() {
        let nine = list(from: [9])
        let three = list(from: [3])

        let result = _0002.Solution().addTwoNumbers(nine, three)

        XCTAssertEqual([1, 2], digits(from: result))
    }

    func test_twelvePlusTwelveEqualsTwentyFour() {
        let twelve = list(from: [1, 2])

        let result = _0002.Solution().addTwoNumbers(twelve, twelve)

        XCTAssertEqual([2, 4], digits(from: result))
    }

    func test_twelvePlusThreeEqualsFifteen() {
        let twelve = list(from: [1, 2])
        let three = list(from: [3])

        let result = _0002.Solution().addTwoNumbers(twelve, three)

        XCTAssertEqual([1, 5], digits(from: result))
    }

    func test_example1() {
        let list1 = list(from: [3, 4, 2])
        let list2 = list(from: [4, 6, 5])

        let result = _0002.Solution().addTwoNumbers(list1, list2)

        XCTAssertEqual([8, 0, 7], digits(from: result))
    }

    // MARK: - Helper methods

    func digits(from list: _0002.ListNode?) -> [Int] {
        var reversedResult = [Int]()
        var listHead = list

        while let currentNode = listHead {
            reversedResult.append(currentNode.val)
            listHead = currentNode.next
        }

        return reversedResult.reversed()
    }

    func list(from digits: [Int]) -> _0002.ListNode? {
        var listHead: _0002.ListNode?

        for digit in digits {
            let newNode = _0002.ListNode(digit)
            newNode.next = listHead
            listHead = newNode
        }

        return listHead
    }
}
