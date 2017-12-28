//
//  FootnoteReferenceSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class FootnoteReferenceSpec: QuickSpec {

    override func spec() {

        describe("FootnoteReference") {
            let text = """
Footnotes[^1] are added in-text like so ...

[^1]: Footnotes are the mind killer.
"""

            do {
                let document = try Document(text: text, options: [.footnotes])

                it("initializes the document") {
                    expect(document.count).to(equal(2))
                }

                it("parses the footnote reference") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    // swiftlint:disable force_cast
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(3))
                    expect(paragraph.items[1]).to(beAKindOf(FootnoteReference.self))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
