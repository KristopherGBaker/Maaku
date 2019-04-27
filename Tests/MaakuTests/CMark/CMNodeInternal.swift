//
//  CMNodeInternal.swift
//  Maaku
//
//  Created by Tim Learmont on 4/26/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import libcmark_gfm
@testable import Maaku
import Nimble
import Quick
import XCTest

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
    var preorderSequence: CMNodePreorderSequence {
        return CMNodePreorderSequence(forNode: self)
    }
}

class CMNodeInternalSpec: QuickSpec {
    // swiftlint:disable cyclomatic_complexity function_body_length
    override func spec() {
        describe("memory test") {
            it("Checks that nodes can be referenced after the document has been released") {
                var strikethroughNodes: [CMNode] = []
                var others: [CMNode] = []
                weak var docNode: CMNode?
                let verifyNodes = {
                    // Verify that all the strikethrough nodes still have the right extension
                    // If there was a memory problem, then the pointer to the extension might have
                    // gotten messed up.
                    for node in strikethroughNodes {
                        if let ext = cmark_node_get_syntax_extension(node.cmarkNode) {
                            expect(String(cString: ext.pointee.name)).to(equal("strikethrough"))
                        } else {
                            fail("Strikethrough type should have extension")
                        }
                    }

                    // Verify that all the other nodes have some extension.
                    for node in others {
                        if let ext = cmark_node_get_syntax_extension(node.cmarkNode) {
                            expect(String(cString: ext.pointee.name)).toNot(equal(""))
                        } else {
                            fail("Node had extension before, but now it doesn't, so memory has been corrupted")
                        }
                    }
                }

                let markdown = """
# Heading 1
## Heading 2
Simple paragraph

- list 1
- list 2
- [ ] task item
- ~~list 3~~

Another Paragraph

1. number 1
1. number 2
1. number 3

|Table|
|-----|
|first|
|second|
|third|
"""
                do {
                    let document = try CMDocument(text: markdown, options: [.validateUtf8], extensions: .all)
                    docNode = document.node
                    expect(docNode).toNot(beNil())
                    // Walk through nodes and grab all the "strikethrough" nodes.
                    try document.node.iterator?.enumerate { node, _ in
                        if node.humanReadableType == "strikethrough" {
                            strikethroughNodes.append(node)
                            if let ext = cmark_node_get_syntax_extension(node.cmarkNode) {
                                expect(String(cString: ext.pointee.name)).to(equal("strikethrough"))
                            } else {
                                fail("Strikethrough type should have extension")
                            }
                        }
                        return false
                    }
                    // Walk through the nodes in a different way -- using the CMNode object code rather
                    // than the underlying C iterator stuff.
                    for node in document.node.preorderSequence {
                        if cmark_node_get_syntax_extension(node.cmarkNode) != nil {
                            others.append(node)
                        }
                    }

                    // Now, verify that we got the values that we expect.
                    // We'll redo the tests later outside this block,
                    // and we should get the same results!
                    verifyNodes()
                } catch let error {
                    it("fails to return reasonable node types") {
                        fail("\(error.localizedDescription)")
                    }
                }

                // docNode should be nil, because the document was released as part of leaving
                // the previous block, and nobody else has a reference to it.
                // Releasing the docNode should *not* release any of the other nodes
                // associated with the document if they had references to them.
                if docNode != nil {
                    // swiftlint:disable:next line_length
                    fail("Test failure: Expected docNode to be deallocated when we left the block. Verify that the test is written correctly - subsequent tests may not work.")
                }

                do {
                    // Do some stuff to use up memory.
                    // Basically, we want to ensure that any freed memory gets changed
                    // so that any existing C pointers aren't pointing to the same data they had before.
                    var someDocs: [CMDocument] = []
                    for index in 1...10000 {
                        let document = try? CMDocument(text: markdown, options: [.validateUtf8], extensions: .all)
                        if index % 1000 == 0 {
                            someDocs = []
                        }
                        someDocs.append(document!)
                    }
                }

                // Now that we've played with memory, verify that the nodes are still what we expect.
                verifyNodes()
            }
        }
    }
}
