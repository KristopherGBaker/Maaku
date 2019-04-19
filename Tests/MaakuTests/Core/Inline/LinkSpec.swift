//
//  LinkSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class LinkSpec: QuickSpec {

    override func spec() {

        describe("Link") {
            let text = "[github](https://www.github.com/)\n"

            do {
                let document = try Document(text: text)

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the link") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    // swiftlint:disable force_cast
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(1))
                    expect(paragraph.items[0]).to(beAKindOf(Link.self))
                    // swiftlint:disable force_cast
                    let link = paragraph.items[0] as! Link
                    expect(link.destination).to(equal("https://www.github.com/"))
                    expect(link.text[0]).to(beAKindOf(Text.self))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }

        describe("Link with nested parenthesis") {
            let markdown = "[ci](source::https://www.github.com/|alt:: nested (parenthesis))"

            do {
                // autolinks must not be enabled to support nested parenthesis
                let document = try Document(text: markdown, options: .default, extensions: [.strikethrough, .tables])

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the link") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    // swiftlint:disable force_cast
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(1))
                    expect(paragraph.items[0]).to(beAKindOf(Text.self))
                    // swiftlint:disable force_cast
                    let text = paragraph.items[0] as! Text

                    let link = Link(text: text)

                    expect(link).toNot(beNil())
                    expect(link?.destination)
                        .to(equal("source::https://www.github.com/|alt:: nested (parenthesis)"))
                    expect(link?.text[0]).to(beAKindOf(Text.self))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
