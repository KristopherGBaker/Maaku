//
//  CMNodeSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 4/19/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

// swiftlint:disable file_length

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

// swiftlint:disable type_body_length

/// Tests that the appropriate structure is found.
class CMNodeSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("Modifying nodes") {
            it("throws an error if the node isn't of the right type") {
                do {
                    do {
                        let doc = try CMDocument(text: "# Heading level 1")
                        // swiftlint:disable line_length
                        expect(try doc.node.setStringValue("dummy string")).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setFencedCodeInfo("dummy string")).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setCustomOnEnter("dummy string")).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setCustomOnExit("dummy string")).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setListType(.ordered)).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setListDelimiterType(.period)).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setListStartingNumber(3)).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setListTight(false)).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setDestination("dummy string")).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setURL(URL(string: "http://google.com")!)).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setTitle("dummy string")).to(throwError(CMNode.ASTError.canNotSetValue))
                        expect(try doc.node.setLiteral("dummy string")).to(throwError(CMNode.ASTError.canNotSetValue))
                        // swiftlint:enable line_length
                    }
                } catch {
                    fail("Got an error: \(error.localizedDescription)")
                }
            }
            it("can set values") {
                do {
                    // StringValue
                    do {
                        let doc = try CMDocument(text: "some text")
                        let textNode = doc.node.firstChild!.firstChild!
                        expect(textNode.stringValue).to(equal("some text"))
                        expect(try textNode.setStringValue("new text")).toNot(throwError())
                        expect(textNode.stringValue).to(equal("new text"))
                    }
                    // HeadingLevel
                    do {
                        let doc = try CMDocument(text: "# Heading level 1")
                        let headerNode = doc.node.firstChild!
                        expect(headerNode.headingLevel).to(equal(1))
                        try headerNode.setHeadingLevel(3)
                        expect(headerNode.headingLevel).to(equal(3))
                    }
                    // FencedCodeInfo
                    do {
                        let text =
"""
```
my code
block
```
"""
                        let expectedResults =
"""
~~~ !`!
my code
block
~~~

"""
                        let doc = try CMDocument(text: text)
                        let fencedCodeNode = doc.node.firstChild!
                        expect(fencedCodeNode.fencedCodeInfo).to(equal(""))
                        try fencedCodeNode.setFencedCodeInfo("!`!")
                        expect(fencedCodeNode.fencedCodeInfo).to(equal("!`!"))
                        let results = try doc.renderCommonMark(width: 100)
                        expect(results).to(equal(expectedResults))
                    }
                    // TODO: Custom
                    // ListType, ListStartingNumber, ListDelimiterType, ListTight
                    do {
                        let text =
"""
some text

- item 1
- item 2
- item 3
"""
                        let expectedResults =
                        """
some text

4)  item 1

5)  item 2

6)  item 3

"""
                        let doc = try CMDocument(text: text)
                        let listNode = doc.node.lastChild!
                        expect(listNode.listType).to(equal(.unordered))
                        try listNode.setListType(.ordered)
                        expect(listNode.listType).to(equal(.ordered))
                        try listNode.setListStartingNumber(4)
                        try listNode.setListDelimiterType(.paren)
                        expect(listNode.listTight).to(equal(true))
                        try listNode.setListTight(false)
                        expect(listNode.listTight).to(equal(false))
                        let results = try doc.renderCommonMark(width: 100)
                        expect(results).to(equal(expectedResults))
                    }
                    // Destination/URL/Title
                    do {
                        let doc = try CMDocument(text: "[my info](http://google.com)")
                        let linkNode = doc.node.firstChild!.firstChild!
                        expect(linkNode.title).to(equal(""))
                        try linkNode.setTitle("A new title")
                        expect(linkNode.title).to(equal("A new title"))
                        try linkNode.setURL(URL(string: "http://apple.com")!)
                        expect(linkNode.destination).to(equal("http://apple.com"))
                        let result = try doc.renderCommonMark(width: 100)
                        expect(result).to(equal("[my info](http://apple.com \"A new title\")\n"))
                    }
                    // Literal
                    do {
                        let doc = try CMDocument(text: "my text")
                        let textNode = doc.node.firstChild!.firstChild!
                        expect(textNode.literal).to(equal("my text"))
                        try textNode.setLiteral("your text")
                        let result = try doc.renderCommonMark(width: 100)
                        expect(result).to(equal("your text\n"))
                    }
                } catch {
                    fail("Got an error: \(error.localizedDescription)")
                }
            }
        }
        describe("Modifying a document tree") {
            it("can add nodes") {
                let baseText =
"""
# heading

- list item 1
- list item 2
"""
                let expectedText =
"""
# heading

  - list item 1
  - list item 2
  - Newly added item

"""
                do {
                    let doc = try CMDocument(text: baseText)
                    let list = doc.node.firstChild!.next!
                    expect(list.type).to(equal(.list))
                    let newNode = CMNode(type: .item, parent: list)
                    expect(newNode).toNot(beNil())
                    if let item = newNode {
                        // Add some text to the item.
                        if let para = CMNode(type: .paragraph, parent: item) {
                            let text = CMNode(type: .text, parent: para)
                            expect(text).toNot(beNil())
                            try text?.setLiteral("Newly added item")
                        }
                    }

                    let results = try doc.renderCommonMark(width: 100)
                    expect(results).to(equal(expectedText))
                } catch {
                    fail("Got an error: \(error.localizedDescription)")
                }

            }
            let baseText =
            """
# heading

- list item 1
- list item 2
"""
            let otherDocText =
            """
place holder text
that spans a few lines

- Newly added item

text after the list.
"""
            it("won't take nodes from another document by default") {
                do {
                    let doc = try CMDocument(text: baseText)
                    let list = doc.node.firstChild!.next!
                    expect(list.type).to(equal(.list))
                    let doc2 = try CMDocument(text: otherDocText)
                    let newNode = doc2.node.firstChild!.next!
                    // swiftlint:disable line_length
                    expect(try newNode.insertIntoTree(asFirstChildOf: list.firstChild!)).to(throwError(CMNode.ASTError.documentMismatch))
                    expect(try newNode.insertIntoTree(asLastChildOf: list.firstChild!)).to(throwError(CMNode.ASTError.documentMismatch))
                    expect(try newNode.insertIntoTree(beforeNode: list.firstChild!)).to(throwError(CMNode.ASTError.documentMismatch))
                    expect(try newNode.insertIntoTree(afterNode: list.firstChild!)).to(throwError(CMNode.ASTError.documentMismatch))
                    // swiftlint:enable line_length
                } catch {
                    fail("Got an error: \(error.localizedDescription)")
                }
            }
            it("can take nodes from another document if you're careful") {
                let expectedText =
"""
# heading

  - list item 1
      - Newly added item
  - list item 2

"""
                let otherExpectedText =
"""
place holder text that spans a few lines

text after the list.

"""
                do {
                    let doc = try CMDocument(text: baseText)
                    let list = doc.node.firstChild!.next!
                    expect(list.type).to(equal(.list))
                    let doc2 = try CMDocument(text: otherDocText)
                    let nodeToAdd = doc2.node.firstChild!.next!.cmarkNode
                    let newNode = CMNode(cmarkNode: nodeToAdd, memoryOwner: list)
                    try newNode.insertIntoTree(asLastChildOf: list.firstChild!)

                    let results = try doc.renderCommonMark(width: 100)
                    expect(results).to(equal(expectedText))

                    // Show that the nodes were removed from the other document:
                    let results2 = try doc2.renderCommonMark(width: 100)
                    expect(results2).to(equal(otherExpectedText))
                } catch {
                    fail("Got an error: \(error.localizedDescription)")
                }
            }
            it("doesn't allow multiple document nodes") {
                // Note that we only check the top level node of each subtree. The user
                // can create a bad tree if they try hard enough. We don't bother
                // checking all possible ways to hurt yourself.
                do {
                    let doc1 = try CMDocument(text: baseText)
                    let doc2 = try CMDocument(text: otherDocText)
                    do {
                        // Try inserting before or after the document node -- which would make two top level nodes.
                        let nodeToAdd = doc2.node.firstChild!.next!.cmarkNode
                        let newNode = CMNode(cmarkNode: nodeToAdd, memoryOwner: doc1.node)
                        // swiftlint:disable line_length
                        expect(try newNode.insertIntoTree(beforeNode: doc1.node)).to(throwError(CMNode.ASTError.canNotInsert))
                        expect(try newNode.insertIntoTree(afterNode: doc1.node)).to(throwError(CMNode.ASTError.canNotInsert))
                        // swiftlint:enable line_length
                    }
                    do {
                        // Try inserting a document node into another tree
                        let newNode = CMNode(cmarkNode: doc2.node.cmarkNode, memoryOwner: doc1.node)
                        // swiftlint:disable line_length
                        expect(try newNode.insertIntoTree(asFirstChildOf: doc1.node)).to(throwError(CMNode.ASTError.canNotInsert))
                        expect(try newNode.insertIntoTree(asLastChildOf: doc1.node)).to(throwError(CMNode.ASTError.canNotInsert))
                        // swiftlint:enable line_length
                    }
                } catch {
                    fail("Got an error: \(error.localizedDescription)")
                }
            }
        }
    }
}
