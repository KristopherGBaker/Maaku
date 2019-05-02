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

extension CMNodeType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}

/// Test internal portions of the CMExtensionOption stuff
/// Tests that don't rely on internal access or calling libcmark_gfm directly
/// are in CMExtensionSpec.
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
        describe("CMExtensionOption basics") {
            it("should have extension names match extension objects") {
                // We expect that each of the basic values maps correctly between extension name
                // and extension type.
                // swiftlint:disable line_length
                expect(CMExtensionOption.autolinks).to(equal(CMExtensionOption.option(forExtensionName: CMExtensionOption.autolinks.extensionName ?? "")))
                expect(CMExtensionOption.strikethrough).to(equal(CMExtensionOption.option(forExtensionName: CMExtensionOption.strikethrough.extensionName ?? "")))
                expect(CMExtensionOption.tables).to(equal(CMExtensionOption.option(forExtensionName: CMExtensionOption.tables.extensionName ?? "")))
                expect(CMExtensionOption.tagfilters).to(equal(CMExtensionOption.option(forExtensionName: CMExtensionOption.tagfilters.extensionName ?? "")))
                // swiftlint:enable line_length
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

We don't include any regular list here, just task lists.
That way we can check to see if we've found the appropriate items.
- [ ] task item
  - [x] completed task item
"""
            it("doesn't have nodes with extensions if no extensions enabled (using internals to check)") {
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .none)
                    var typesFound: Set<CMNodeType> = []
                    var typeNamesFound: Set<String> = []
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }

                        // We expect that no node has an extension, since no extensions were enabled.
                        expect(cmark_node_get_syntax_extension(node.cmarkNode)).to(beNil())

                        typesFound.insert(node.type)

                        if let typeName = node.humanReadableType {
                            typeNamesFound.insert(typeName)
                        } else {
                            fail("Couldn't determine human readable type for node")
                        }

                        return false
                    }

                    // We expect that none of the extension types were found.
                    // There shouldn't be strikethroughs, since that extension wasn't enabled.
                    expect(typeNamesFound).toNot(contain(CMExtensionName.strikethrough.rawValue))
                    // There shouldn't be table objects, since that extension wasn't enabled.
                    expect(typeNamesFound).toNot(contain(CMExtensionName.table.rawValue))
                    expect(typeNamesFound).toNot(contain(CMExtensionName.tableCell.rawValue))
                    expect(typeNamesFound).toNot(contain(CMExtensionName.tableHeader.rawValue))
                    expect(typeNamesFound).toNot(contain(CMExtensionName.tableRow.rawValue))
                    // There shouldn't be a tasklist item, since that extension wasn't enabled.
                    // Those should show up as items.
                    expect(typeNamesFound).toNot(contain(CMExtensionName.tasklist.rawValue))
                    expect(typeNamesFound).to(contain("item"))
                    expect(typesFound).to(contain(CMNodeType.item))
                } catch let error {
                    it("fails to process document") {
                        fail("\(error.localizedDescription)")
                    }
                }
            }
            it("has nodes with extensions (using internals to check)") {
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .all)
                    var extensionsFound: Set<String> = []
                    var typesFound: Set<CMNodeType> = []
                    var typeNamesFound: Set<String> = []
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }

                        if cmark_node_get_syntax_extension(node.cmarkNode) != nil {
                            // There is an extension associated with this node.
                            // swiftlint:disable:next line_length
                            expect(node.extension?.syntaxExtension).to(equal(cmark_node_get_syntax_extension(node.cmarkNode)))
                            expect(node.extension?.extensionName).toNot(beNil())
                            extensionsFound.insert(node.extension!.extensionName!)
                        }

                        typesFound.insert(node.type)

                        if let typeName = node.humanReadableType {
                            typeNamesFound.insert(typeName)
                        } else {
                            fail("Couldn't determine human readable type for node")
                        }

                        return false
                    }
                    // We expect that we've found some nodes of each extension type.

                    // The autolink extension doesn't add new node types, it just
                    // converts more things to links.
                    expect(extensionsFound).toNot(contain(CMExtensionOption.autolinks.extensionName!))

                    // We expect that strikethrough objects were found.
                    expect(extensionsFound).to(contain(CMExtensionOption.strikethrough.extensionName!))
                    expect(typeNamesFound).to(contain(CMExtensionName.strikethrough.rawValue))

                    // We expect that table extension objects were found
                    expect(extensionsFound).to(contain(CMExtensionOption.tables.extensionName!))
                    expect(typeNamesFound).to(contain(CMExtensionName.table.rawValue))
                    expect(typeNamesFound).to(contain(CMExtensionName.tableCell.rawValue))
                    expect(typeNamesFound).to(contain(CMExtensionName.tableHeader.rawValue))
                    expect(typeNamesFound).to(contain(CMExtensionName.tableRow.rawValue))

                    // tagfilters doesn't add new types, it just changes some values
                    expect(extensionsFound).toNot(contain(CMExtensionOption.tagfilters.extensionName!))
                    // TODO: test tagfilters.
                    // I'm not sure how to test tagfilters

                    // The tasklist extension doesn't add a new node type, but changes the humanReadableType
                    // We expect that we will find nodes with the tasklist extension, and nodes
                    // that have a human readable type of `tasklist`
                    expect(extensionsFound).to(contain(CMExtensionOption.tasklist.extensionName!))
                    expect(typeNamesFound).to(contain(CMExtensionName.tasklist.rawValue))
                    expect(typesFound).to(contain(CMNodeType.item))
               } catch let error {
                    it("fails to process document") {
                        fail("\(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
