//
//  UnorderedListSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class UnorderedListSpec: QuickSpec {

    override func spec() {

        describe("UnorderedList") {
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

                it("parses the unordered list") {
                    expect(document[0]).to(beAKindOf(UnorderedList.self))
                    // swiftlint:disable force_cast
                    let list = document[0] as! UnorderedList
                    expect(list.items.count).to(equal(3))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
