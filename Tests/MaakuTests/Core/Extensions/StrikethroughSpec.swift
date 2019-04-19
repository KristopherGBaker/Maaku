//
//  StrikethroughSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class StrikethroughSpec: QuickSpec {

    override func spec() {

        describe("Strikethrough") {
            let text = "~~strikethrough~~\n"

            do {
                let document = try Document(text: text)

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the paragraph") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                }

                // swiftlint:disable force_cast
                let paragraph = document[0] as! Paragraph

                it("parses the strikethrough") {
                    expect(paragraph.items[0]).to(beAKindOf(Strikethrough.self))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
