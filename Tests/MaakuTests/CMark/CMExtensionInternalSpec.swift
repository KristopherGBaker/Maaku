//
//  CMExtensionInternalSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 4/23/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

// Include testable Maaku & libcmark_gfm, since we're testing things that aren't visible to user.
import libcmark_gfm
@testable import Maaku
import Nimble
import Quick
import XCTest

/// Test internal portions of the CMExtensionOption stuff
class CMExtensionInternalSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
        describe("CMExtensionOption basics") {
            it("has all extensions registered") {
                expect(CMExtensionOption.autolinks.syntaxExtension).toNot(beNil())
                expect(CMExtensionOption.strikethrough.syntaxExtension).toNot(beNil())
                expect(CMExtensionOption.tables.syntaxExtension).toNot(beNil())
                expect(CMExtensionOption.tagfilters.syntaxExtension).toNot(beNil())
            }
        }
        describe("Complex document") {
            let markdown = """
www.github.com

This should be converted to non-HTML: <title>

|Name|Pay|
|----|---|
|K   |100|
|H   | 50|
|T   | 25|

~~text with strike~~

- item
- [ ] task item
"""
            it("doesn't have nodes with extensions if no extensions enabled") {
                let noExtensionKey = ""
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .none)
                    var nodesByExtension: [String: [CMNode]] = [:]
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }

                        var name: String
                        if cmark_node_get_syntax_extension(node.cmarkNode) != nil {
                            // There is an extension associated with this node.
                            // swiftlint:disable:next line_length
                            expect(node.extension?.syntaxExtension).to(equal(cmark_node_get_syntax_extension(node.cmarkNode)))
                            expect(node.extension?.extensionName).toNot(beNil())
                            name = node.extension!.extensionName!
                        } else {
                            name = noExtensionKey
                            expect(node.extension).to(beNil())
                        }
                        // Add the node to the dictionary
                        var foundNodes = nodesByExtension[name] ?? []
                        foundNodes.append(node)
                        nodesByExtension[name] = foundNodes
                        return false
                    }
                    // We expect that there are no extension nodes, so all nodes should be
                    // with the noExtensionKey, thus there should only be one key
                    // in the dictionary.
                    expect(nodesByExtension.keys.count).to(equal(1))
                    expect(nodesByExtension[noExtensionKey]).toNot(beNil())
                } catch let error {
                    it("fails to process document") {
                        fail("\(error.localizedDescription)")
                    }
                }
            }
            it("has nodes with extensions") {
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .all)
                    var nodesByExtension: [String: [CMNode]] = [:]
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }

                        var name = ""
                        if cmark_node_get_syntax_extension(node.cmarkNode) != nil {
                            // There is an extension associated with this node.
                            // swiftlint:disable:next line_length
                            expect(node.extension?.syntaxExtension).to(equal(cmark_node_get_syntax_extension(node.cmarkNode)))
                            expect(node.extension?.extensionName).toNot(beNil())
                            name = node.extension!.extensionName!
                            print("Node at \(node.startLine):\(node.startColumn) \(node.humanReadableType ?? "")")
                        } else {
                            expect(node.extension).to(beNil())
                        }
                        // Add the node to the dictionary
                        var foundNodes = nodesByExtension[name] ?? []
                        foundNodes.append(node)
                        nodesByExtension[name] = foundNodes
                        return false
                    }
                    // We expect that we've found some nodes of each extension type.
                    // swiftlink:disable line_length
                    
                    // The autolink extension doesn't add new node types, it just
                    // converts more things to links.
                    expect(nodesByExtension[CMExtensionOption.autolinks.extensionName!]).to(beNil())
                    
                    // We expect that strikethrough objects were found.
                    expect(nodesByExtension[CMExtensionOption.strikethrough.extensionName!]).toNot(beNil())

                    // We expect that table extension objects were found
                    expect(nodesByExtension[CMExtensionOption.tables.extensionName!]).toNot(beNil())
                    
                    // tagfilters doesn't add new types, it just changes some values
                    expect(nodesByExtension[CMExtensionOption.tagfilters.extensionName!]).to(beNil())
                    // TODO: test tagfilters.
                    // I'm not sure how to test node object stuff.

                    // swiftlink:enable line_length
                } catch let error {
                    it("fails to process document") {
                        fail("\(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
