//
//  FootnoteDefinitionSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class FootnoteDefinitionSpec: QuickSpec {

    override func spec() {

        describe("FootnoteDefinition") {
            let text = """
Footnotes[^1] are added in-text like so ...

[^1]: Footnotes are the mind killer.
"""

            do {
                let document = try Document(text: text, options: [.footnotes])

                it("initializes the document") {
                    expect(document.count).to(equal(2))
                }

                it("parses the footnote definition") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    expect(document[1]).to(beAKindOf(FootnoteDefinition.self))
                    // swiftlint:disable force_cast
                    let footnote = document[1] as! FootnoteDefinition
                    expect(footnote.items.count).to(equal(1))
                    expect(footnote.number).to(equal(1))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
