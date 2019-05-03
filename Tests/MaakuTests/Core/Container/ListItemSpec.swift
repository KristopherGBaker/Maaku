//
//  ListItemSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class ListItemSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {

        describe("ListItem") {
            let text = """
+  Swift
+  Objective-C
+  C
"""

            do {
                let document = try Document(text: text)

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the list items") {
                    expect(document[0]).to(beAKindOf(UnorderedList.self))
                    // swiftlint:disable:next force_cast
                    let list = document[0] as! UnorderedList
                    expect(list.items.count).to(equal(3))

                    for item in list.items {
                        expect(item).to(beAKindOf(ListItem.self))
                    }
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
        describe("ListItem.attributedText") {
            let text =
"""
- list 1
  a paragraph inside list one, followed by:
  - embedded list
  - another embedded item
    1. ordered list inside
    1. another ordered item
  - third embedded item
- second item in top list
"""
/* XML for above for comparison of the structure:
<document xmlns="http://commonmark.org/xml/1.0">
    <list type="bullet" tight="true">
        <item>
            <paragraph>
                <text xml:space="preserve">list 1</text>
                <softbreak />
                <text xml:space="preserve">a paragraph inside list one, followed by:</text>
            </paragraph>
            <list type="bullet" tight="true">
                <item>
                    <paragraph>
                        <text xml:space="preserve">embedded list</text>
                    </paragraph>
                </item>
                <item>
                    <paragraph>
                        <text xml:space="preserve">another embedded item</text>
                    </paragraph>
                    <list type="ordered" start="1" delim="period" tight="true">
                        <item>
                            <paragraph>
                                <text xml:space="preserve">ordered list inside</text>
                            </paragraph>
                        </item>
                        <item>
                            <paragraph>
                                <text xml:space="preserve">another ordered item</text>
                            </paragraph>
                        </item>
                    </list>
                </item>
                <item>
                    <paragraph>
                        <text xml:space="preserve">third embedded item</text>
                    </paragraph>
                </item>
            </list>
        </item>
        <item>
            <paragraph>
                <text xml:space="preserve">second item in top list</text>
            </paragraph>
        </item>
    </list>
</document>

 */
            // We expect that the attributed text for the first item includes all the sub-lists that are included
            // under the item, not just the first line ("list 1") or even just the first line and the following
            // paragraph, but *all* the stuff inside this list item.
            // swiftlint:disable:next line_length
            let expectedFirstString = "list 1 a paragraph inside list one, followed by:• embedded list• another embedded item1. ordered list inside2. another ordered item• third embedded item"

            do {
                let document = try Document(text: text)
                let style = DefaultStyle()

                it("checks the attributedText values") {
                    // swiftlint:disable:next force_cast
                    let list = document[0] as! UnorderedList
                    let firstItemText = list.items[0].attributedText(style: style)
                    expect(firstItemText.string).to(equal(expectedFirstString))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }

        }
    }

}
