//
//  CMNodeSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 4/19/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import libcmark_gfm
import Maaku
import Nimble
import Quick
import XCTest

extension CMNode: Equatable {
    public static func == (lhs: CMNode, rhs: CMNode) -> Bool {
        let left = lhs.cmarkNode
        let right = rhs.cmarkNode
        // If they have the same underlying node, then they are the same
        if left == right {
            return true
        }
        // Otherwise, check the important values
        // Check the type using the underlying cmarkNode so we don't waste memory creating a CMNodeType
        if (cmark_node_get_type(left) != cmark_node_get_type(right))
            || ( cmark_node_get_syntax_extension(left) != cmark_node_get_syntax_extension(right)) {
            return false
        }

        if (lhs.startLine != rhs.startLine) || (lhs.startColumn != rhs.startColumn)
            || (lhs.endLine != rhs.endLine) || (lhs.endColumn != rhs.endColumn) {
            return false
        }

        if (lhs.headingLevel != rhs.headingLevel) || (lhs.stringValue != rhs.stringValue) {
            return false
        }
        // Check all children:
        var lhsChild = lhs.firstChild
        var rhsChild = rhs.firstChild
        while (lhsChild != nil) && (rhsChild != nil) {
            // This is recursion!
            if lhsChild != rhsChild {
                return false
            }
            lhsChild = lhsChild?.next
            rhsChild = rhsChild?.next
        }
        // Both have to be nil here in order to match
        if (lhsChild != nil) || (rhsChild != nil) {
            return false
        }

        // If we finally make it here, the two match on all the important items.
        return true
    }
}

extension CMNode {
    /// Walk through this node's hierarchy and return the first node that is returned by the matcher function
    /// - Parameter matcher:
    ///        a closure that takes a node, and returns true if the node meets appropriate critera, or false if not
    /// - Returns: the first node for which the matcher function returns true
    func nodeMatching(matcher: (CMNode) -> Bool) -> CMNode? {
        if matcher(self) {
            return self
        }
        // Go through the children trying to match.
        var child = firstChild
        while child != nil {
            if let foundNode = child?.nodeMatching(matcher: matcher) {
                return foundNode
            }
            child = child?.next
        }
        return nil
    }
    class CMNodePreorderIterator: IteratorProtocol {
        // swiftlint:disable:next nesting
        typealias Element = CMNode
        var currentNode: CMNode?
        var nextChildToProcess: CMNode?
        var childIterator: CMNodePreorderIterator?

        init(_ node: CMNode) {
            currentNode = node
        }
        func next() -> CMNode? {
            // If we haven't processed the current node, process that
            if currentNode != nil {
                // We haven't processed the current node, process that.
                let result = currentNode
                nextChildToProcess = currentNode?.firstChild
                childIterator = nil
                currentNode = nil
                return result
            }

            if childIterator != nil {
                if let result = childIterator!.next() {
                    return result
                } else {
                    // Done with this child iterator.
                    childIterator = nil
                }
            }
            // The previous child iterator is nil, process the next child if there is one
            if nextChildToProcess != nil {
                childIterator = CMNodePreorderIterator(nextChildToProcess!)
                nextChildToProcess = nextChildToProcess!.next
                // We know that this won't return nil, because it has to proces the node we passed in.
                return childIterator!.next()
            }

            // Nobody else to process, so done
            return nil
        }
    }
    struct CMNodePreorderSequence: Sequence {
        let firstNode: CMNode
        init(forNode node: CMNode) {
            firstNode = node
        }
        func makeIterator() -> CMNode.CMNodePreorderIterator {
            return CMNodePreorderIterator(firstNode)
        }

        //swiftlint:disable nesting
        typealias Element = CMNode
        typealias Iterator = CMNodePreorderIterator
        // swiftlint:enable nesting

    }

    /// Provide a Sequence way to walk through the nodes.
    ///
    /// This traverses nodes in a different manner than using iterator method.
    /// It is useful for testing because it may create or manipulate the CMNodes in
    /// a different manner, which might help to bring up underlying bugs.
    var preorderSequence: CMNodePreorderSequence {
        return CMNodePreorderSequence(forNode: self)
    }
}

/// Tests that the appropriate structure is found.
class CMNodeSpec: QuickSpec {
    override func spec() {
    }

}
