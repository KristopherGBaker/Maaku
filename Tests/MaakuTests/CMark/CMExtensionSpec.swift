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

extension CMExtensionOption: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}

class CMExtensionSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
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

We only include task items in this doc, no regular list items!
We will later check to see that there aren't any items of type list.
- [ ] task item
  - [x] completed task item
  - [X] another completed task item
"""
            it("doesn't have nodes with extensions if no extensions enabled") {
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .none)
                    var typeNamesFound: Set<String> = []
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }

                        if let typeName = node.humanReadableType {
                            typeNamesFound.insert(typeName)
                        } else {
                            fail("Couldn't determine human readable type for node")
                        }

                        expect(node.extension).to(beNil())

                        return false
                    }

                    // We expect that none of the extension types are found.
                    // There shouldn't be a link, because 'autolink' extension wasn't enabled.
                    expect(typeNamesFound).toNot(contain("link"))
                    // There shouldn't be strikethroughs, since that extension wasn't enabled.
                    expect(typeNamesFound).toNot(contain("strikethrough"))
                    // There shouldn't be table objects, since that extension wasn't enabled.
                    expect(typeNamesFound).toNot(contain("table_cell"))
                    expect(typeNamesFound).toNot(contain("table_row"))
                    expect(typeNamesFound).toNot(contain("table_header"))
                    expect(typeNamesFound).toNot(contain("table"))
                    // There shouldn't be any `tasklist` nodes, but instead `item` nodes
                    expect(typeNamesFound).toNot(contain("tasklist"))
                    expect(typeNamesFound).to(contain("item"))
               } catch let error {
                    it("fails to process document") {
                        fail("\(error.localizedDescription)")
                    }
                }
            }
            it("has nodes with extensions") {
                do {
                    let document = try CMDocument(text: markdown, options: [], extensions: .all)
                    var extensionsFound: Set<CMExtensionOption> = []
                    var typeNamesFound: Set<String> = []
                    try document.node.iterator?.enumerate { node, event in
                        guard event == .enter else {
                            return false
                        }
                        if let typeName = node.humanReadableType {
                            typeNamesFound.insert(typeName)
                        }

                        if let extensionType = node.extension {
                            // There is an extension associated with this node.
                            expect(extensionType.extensionName).toNot(beNil())
                            extensionsFound.insert(extensionType)
                        }

                        return false
                    }
                    // We expect that we've found some nodes of each extension type.

                    // The autolink extension doesn't add new node types, it just
                    // converts more things to links.
                    expect(extensionsFound).toNot(contain(CMExtensionOption.autolinks))
                    // We expect to find a link (converted via autolink)
                    expect(typeNamesFound).to(contain("link"))

                    // We expect that strikethrough objects were found.
                    expect(extensionsFound).to(contain(CMExtensionOption.strikethrough))
                    // We expect node objects of type "strikethrough"
                    expect(typeNamesFound).to(contain("strikethrough"))

                    // We expect that table extension objects were found
                    expect(extensionsFound).to(contain(CMExtensionOption.tables))
                    // We expect node objects of all these types:
                    expect(typeNamesFound).to(contain("table_cell", "table_row", "table_header", "table"))

                    // tagfilters doesn't add new types, it just changes some values
                    expect(extensionsFound).toNot(contain(CMExtensionOption.tagfilters))
                    // TODO: test tagfilters.
                    // I'm not sure how to test node object stuff.

                    // We expect that tasklist extension objects were found.
                    expect(extensionsFound).to(contain(CMExtensionOption.tasklist))
                    // We expect objects of type 'tasklist' were found.
                    // There shouldn't be any `tasklist` nodes, but instead `item` nodes
                    expect(typeNamesFound).to(contain("tasklist"))
                    expect(typeNamesFound).toNot(contain("item"))
                } catch let error {
                    it("fails to process document") {
                        fail("\(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
