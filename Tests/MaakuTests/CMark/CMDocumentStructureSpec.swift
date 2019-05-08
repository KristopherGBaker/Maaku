//
//  CMDocumentStructureSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 4/18/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import libcmark_gfm
import Maaku
import Nimble
import Quick
import XCTest

/// Tests that the appropriate structure is found.
class CMDocumentStructureSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        describe("document structure") {
            context("empty document") {
                it("has a document node with no children") {
                    do {
                        let document = try CMDocument(text: "")
                        let docNode = document.node

                        // The main node should be a document node with no parent.
                        expect(docNode.type).to(equal(CMNodeType.document))
                        expect(docNode.parent).to(beNil())

                        // This simple example has no data, so we expect no children
                        expect(docNode.firstChild).to(beNil())
                        expect(docNode.lastChild).to(beNil())
                    } catch let error {
                        it("fails to initialize empty document") {
                            fail("\(error.localizedDescription)")
                        }
                    }
                }
            }
            context("single object document") {
                it("has a document node with a single child") {
                    do {
                        let document = try CMDocument(text: "hello")
                        let docNode = document.node

                        // The main node should be a document node with no parent.
                        expect(docNode.type).to(equal(CMNodeType.document))
                        expect(docNode.parent).to(beNil())

                        // This simple example should only have 1 child
                        expect(docNode.firstChild).toNot(beNil())
                        expect(docNode.lastChild).toNot(beNil())
                        expect(docNode.firstChild) == docNode.lastChild
                    } catch let error {
                        it("fails to initialize empty document") {
                            fail("\(error.localizedDescription)")
                        }
                    }
                }
           }
            context("complex document") {
                it("has a document node with several children") {
                    do {
                        let markdown = """
# Heading 1
## Heading 2
Simple paragraph

- list 1
- list 2
- list 3

Another Paragraph

1. number 1
1. number 2
1. number 3
"""
                        let document = try CMDocument(text: markdown)
                        let docNode = document.node

                        // The main node should be a document node with no parent.
                        expect(docNode.type).to(equal(CMNodeType.document))
                        expect(docNode.parent).to(beNil())

                        // This example should have several children
                        expect(docNode.firstChild).toNot(beNil())
                        expect(docNode.lastChild).toNot(beNil())
                        expect(docNode.firstChild) != docNode.lastChild

                        // We expect that processing the document again should give equivalent results.
                        let doc2 = try CMDocument(text: markdown)
                        expect(docNode) == doc2.node
                    } catch let error {
                        it("fails to return reasonable node types") {
                            fail("\(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

}
