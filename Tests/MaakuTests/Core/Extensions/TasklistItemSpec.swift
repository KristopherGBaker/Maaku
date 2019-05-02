//
//  TasklistItemSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 4/25/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class TasklistItemSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {

        describe("tasklist") {
            let text = """
- [ ] uncompleted item
- [x] completed item
- a list item that isn't a task mixed in
- [X] another completed item
"""

            do {
                let document = try Document(text: text)

                it("checks the document for basic structure") {
                    expect(document.count).to(equal(1))
                    expect(document[0]).to(beAKindOf(UnorderedList.self))
                }
                // swiftlint:disable:next force_cast
                let list = document[0] as! List

                it("checks that the list contains the right number of elements") {
                    expect(list.items.count).to(equal(4))
                }

                it("checks the document for tasklist items") {
                    for itemNumber in 0..<list.items.count {
                        // All items in the list should be Items
                        expect(list.items[itemNumber]).to(beAKindOf(Item.self))
                        // swiftlint:disable:next force_cast
                        let item = list.items[itemNumber] as! Item
                        // All the items except for the 3rd should be TasklistItems.
                        if itemNumber != 2 {
                            expect(item).to(beAKindOf(TasklistItem.self))
                            expect(item).toNot(beAKindOf(ListItem.self))
                            // swiftlint:disable:next force_cast
                            let task = item as! TasklistItem
                            if itemNumber == 0 {
                                // We expect this to be uncompleted
                                expect(task.completed).to(equal(false))
                            } else {
                                // We expect these to be completed.
                                expect(task.completed).to(equal(true))
                            }
                        } else {
                            expect(item).toNot(beAKindOf(TasklistItem.self))
                            expect(item).to(beAKindOf(ListItem.self))
                        }
                    }
                }

                fit("checks the attributedText for tasks") {
                    let style = DefaultStyle()

                    expect(list.items.count).to(equal(4))

                    var attributedText: [NSAttributedString] = []
                    var taskListItemAttributedText: [NSAttributedString] = []
                    for listItem in list.items {
                        // All items in the list should be Items
                        expect(listItem).to(beAKindOf(Item.self))
                        attributedText.append(listItem.attributedText(style: style))
                        if let tasklistItem = listItem as? TasklistItem {
                            // swiftlint:disable:next line_length
                            taskListItemAttributedText.append(tasklistItem.attributedText(style: style, includeMarker: false))
                        }
                    }

                    expect(attributedText[0].string).to(equal("[ ] uncompleted item"))
                    expect(attributedText[1].string).to(equal("[x] completed item"))
                    expect(attributedText[2].string).to(equal("a list item that isn't a task mixed in"))
                    // When converting from task to string, we always choose lower case x for showing complete.
                    expect(attributedText[3].string).to(equal("[x] another completed item"))

                    // Check the tasklist attributed text that doesn't include the marker.
                    expect(taskListItemAttributedText[0].string).to(equal("uncompleted item"))
                    expect(taskListItemAttributedText[1].string).to(equal("completed item"))
                    expect(taskListItemAttributedText[2].string).to(equal("another completed item"))

                    // Check that the completed tasks have a strikethrough and the uncompleted ones don't.
                    // swiftlint:disable line_length
                    expect(taskListItemAttributedText[0].attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strikethroughStyle]).to(beNil())
                    expect(taskListItemAttributedText[1].attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strikethroughStyle]).toNot(beNil())
                    expect(taskListItemAttributedText[2].attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.strikethroughStyle]).toNot(beNil())
                    // swiftlint:enable line_length
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
       }
        describe("Tasks can come with any List marker") {
            do {
                let text =
"""
- [ ] This is a task
+ [ ] This is a task, that starts with a different initial marker
* [ ] This is also a task.
1. [x] Tasks can be in ordered lists
1. [ ] as this shows.
"""
                let document = try Document(text: text)

                it("Checks that each list contains only tasks") {
                    for case let list as List in document.items {
                        for item in list.items {
                            expect(item).to(beAKindOf(TasklistItem.self))
                        }
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
