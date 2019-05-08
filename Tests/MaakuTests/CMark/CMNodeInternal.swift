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

class CMNodeInternalSpec: QuickSpec {
    // swiftlint:disable cyclomatic_complexity function_body_length
    override func spec() {
        describe("memory test") {
            it("Checks that nodes can be referenced after the document has been released") {
                var strikethroughNodes: [CMNode] = []
                var others: [CMNode] = []
                weak var docRef: CMDocument?
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
                    docRef = document
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

                // The document was released when we left the previous block.
                expect(docRef).to(beNil())
                // docNode should not be nil, because we've got some nodes that still exist
                // in the various arrays that reference that cmarkNodes that this docNode holds.
                expect(docNode).toNot(beNil())

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
            it("checks that all nodes reference the same memory holder") {
                    let markdown = """
# Heading 1
## Heading 2
Simple paragraph with ~~strikethrough~~ _and_ _~~multi~~_ levels.

- list 1
  1. list inside a list
     + another list
     + will it ever stop?
       * Yep
       * it will
  1. with several elements
  1. that are numbered
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
                        let docNode = document.node
                        expect(docNode).toNot(beNil())
                        // We expect that the document node is the one who owns the memory
                        expect(docNode.internalMemoryOwner).to(beNil())
                        // Walk through nodes and grab all the "strikethrough" nodes.
                        try document.node.iterator?.enumerate { node, _ in
                            if node !== docNode {
                                // Other nodes should have the document node as the owner.
                                expect(node.internalMemoryOwner).toNot(beNil())
                                expect(node.internalMemoryOwner).to(beIdenticalTo(docNode))
                            }
                            return false
                        }
                        // Walk through the nodes in a different way -- using the CMNode object code rather
                        // than the underlying C iterator stuff.
                        for node in document.node.preorderSequence where node !== docNode {
                            // Other nodes should have the document node as the owner.
                            expect(node.internalMemoryOwner).toNot(beNil())
                            expect(node.internalMemoryOwner).to(beIdenticalTo(docNode))
                        }

                    } catch let error {
                        it("fails to return reasonable node types") {
                            fail("\(error.localizedDescription)")
                        }
                    }

                }
        }
    }
}
