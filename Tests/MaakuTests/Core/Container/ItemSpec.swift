//
//  ItemSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 5/2/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class ItemSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {

        describe("List containing regular ListItems") {
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

                it("parses the items") {
                    expect(document[0]).to(beAKindOf(UnorderedList.self))
                    // swiftlint:disable force_cast
                    let list = document[0] as! UnorderedList
                    expect(list.items.count).to(equal(3))

                    for item in list.items {
                        expect(item).to(beAKindOf(Item.self))
                        // These are no tasks here, so they are all list items
                        expect(item).to(beAKindOf(ListItem.self))
                    }
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
        describe("List containing TaskItems") {
            let text = """
- [x]  Swift
- [X]  Objective-C
- [x]  C
"""

            do {
                let document = try Document(text: text)

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the items") {
                    expect(document[0]).to(beAKindOf(UnorderedList.self))
                    // swiftlint:disable force_cast
                    let list = document[0] as! UnorderedList
                    expect(list.items.count).to(equal(3))

                    for item in list.items {
                        expect(item).to(beAKindOf(Item.self))
                        // These are all tasks
                        expect(item).to(beAKindOf(TasklistItem.self))
                    }
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
        describe("List containing both ListItems and TaskLists") {
            let text = """
-  Swift
- [ ]  Objective-C
-  C
"""

            do {
                let document = try Document(text: text)

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the items") {
                    expect(document[0]).to(beAKindOf(UnorderedList.self))
                    // swiftlint:disable force_cast
                    let list = document[0] as! UnorderedList
                    expect(list.items.count).to(equal(3))

                    for item in list.items {
                        expect(item).to(beAKindOf(Item.self))
                    }
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
   }
}
