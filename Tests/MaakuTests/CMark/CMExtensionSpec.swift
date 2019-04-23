//
//  CMExtensionSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 4/23/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class CMExtensionSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
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
        describe("CMExtensionOption") {
            let markdown = """
www.github.com

This should be converted to non-HTML via extensions: <title>

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
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .none)
                    var nodesByExtension: [Int32: [CMNode]] = [:]
                    var typesFound: Set<String> = []
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }

                        if let typeName = node.humanReadableType {
                            typesFound.insert(typeName)
                        }

                        var key = CMExtensionOption.none.rawValue
                        if let extensionType = node.extension {
                            key = extensionType.rawValue
                        }
                        // Add the node to the dictionary
                        var foundNodes = nodesByExtension[key] ?? []
                        foundNodes.append(node)
                        nodesByExtension[key] = foundNodes
                        return false
                    }
                    // We expect that there are no extension nodes, so all nodes should be
                    // with the noExtensionKey, thus there should only be one key
                    // in the dictionary.
                    expect(nodesByExtension.keys.count).to(equal(1))
                    expect(nodesByExtension[CMExtensionOption.none.rawValue]).toNot(beNil())
                    // We expect that none of the extension types are found.
                    // There shouldn't be a link, because 'autolink' extension wasn't enabled.
                    expect(typesFound).toNot(contain("link"))
                    // There shouldn't be strikethroughs, since that extension wasn't enabled.
                    expect(typesFound).toNot(contain("strikethrough"))
                    // There shouldn't be table objects, since that extension wasn't enabled.
                    expect(typesFound).toNot(contain("table_cell"))
                    expect(typesFound).toNot(contain("table_row"))
                    expect(typesFound).toNot(contain("table_header"))
                    expect(typesFound).toNot(contain("table"))
               } catch let error {
                    it("fails to process document") {
                        fail("\(error.localizedDescription)")
                    }
                }
            }
            it("has nodes with extensions") {
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .all)
                    var nodesByExtension: [Int32: [CMNode]] = [:]
                    var typesFound: Set<String> = []
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }
                        if let typeName = node.humanReadableType {
                            typesFound.insert(typeName)
                        }

                        var key = CMExtensionOption.none.rawValue
                        if let extensionType = node.extension {
                            // There is an extension associated with this node.
                            expect(extensionType.extensionName).toNot(beNil())
                            key = extensionType.rawValue
                        }
                        // Add the node to the dictionary
                        var foundNodes = nodesByExtension[key] ?? []
                        foundNodes.append(node)
                        nodesByExtension[key] = foundNodes
                        return false
                    }
                    // We expect that we've found some nodes of each extension type.
                    // swiftlink:disable line_length

                    // The autolink extension doesn't add new node types, it just
                    // converts more things to links.
                    expect(nodesByExtension[CMExtensionOption.autolinks.rawValue]).to(beNil())
                    // We expect to find a link (converted via autolink)
                    expect(typesFound).to(contain("link"))

                    // We expect that strikethrough objects were found.
                    expect(nodesByExtension[CMExtensionOption.strikethrough.rawValue]).toNot(beNil())
                    // We expect node objects of type "strikethrough"
                    expect(typesFound).to(contain("strikethrough"))

                    // We expect that table extension objects were found
                    expect(nodesByExtension[CMExtensionOption.tables.rawValue]).toNot(beNil())
                    // We expect node objects of all these types:
                    expect(typesFound).to(contain("table_cell", "table_row", "table_header", "table"))

                    // tagfilters doesn't add new types, it just changes some values
                    expect(nodesByExtension[CMExtensionOption.tagfilters.rawValue]).to(beNil())
                    // TODO: test tagfilters.
                    // I'm not sure how to test node object stuff.

                    // Sinde the tasklist extension is included (yet) we expect that
                    // the tasklist type wasn't found.
                    expect(typesFound).toNot(contain("tasklist"))
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
