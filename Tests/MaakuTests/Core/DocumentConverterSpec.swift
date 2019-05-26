//
//  DocumentConverterSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 5/25/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

// swiftlint:disable line_length
class DocumentConverterSpec: QuickSpec {
    enum ParseError: LocalizedError {
        case customError(message: String)
        var localizedDescription: String {
            switch self {
            case .customError(let message):
                return message
            }
        }
    }

    static func checkHeading(item: Block, identifier: String, expectedLevel: HeadingLevel, expectedText: String) throws {
        guard let heading = item as? Heading else {
            // It wasn't a heading. Report
            throw ParseError.customError(message: "\(identifier): wasn't a heading, it was \(item)")
        }
        if heading.level != expectedLevel {
            throw ParseError.customError(message: "\(identifier): expected heading level \(expectedLevel), but got \(heading.level)")
        }
        // We only expect 1 item for a heading
        if heading.items.count != 1 {
            throw ParseError.customError(message: "\(identifier): expected heading to only have 1 item, but it had \(heading.items)")
        }
        try DocumentConverterSpec.checkText(item: heading.items[0], identifier: identifier, expectedText: expectedText)
    }

    static func checkText(item: Inline, identifier: String, expectedText: String) throws {
        guard let text = item as? Text else {
            throw ParseError.customError(message: "\(identifier): expected Text, got \(item)")
        }
        if text.text != expectedText {
            throw ParseError.customError(message: "\(identifier): expected \(expectedText), but got \(text.text)")
        }
    }

    static func checkParagraph(item: Block, identifier: String, expectedText: [String?]) throws {
        guard let paragraph = item as? Paragraph else {
            throw ParseError.customError(message: "\(identifier): expected Paragraph, got \(item)")
        }
        if paragraph.items.count != expectedText.count {
            throw ParseError.customError(message: "\(identifier): expected \(expectedText.count) items, but got \(paragraph.items.count)")
        }
        // swiftlint:disable identifier_name
        for i in 0 ..< paragraph.items.count {
            if let expectedString = expectedText[i] {
                try DocumentConverterSpec.checkText(item: paragraph.items[i], identifier: "\(identifier) [item \(i)]", expectedText: expectedString)
            } else {
                // If the value in the expectedText array is nil, that means we expect a softbreak
                // If we didn't get one, that's a problem
                if !(paragraph.items[i] is SoftBreak) {
                    throw ParseError.customError(message: "\(identifier): expected item \(i) to be a soft break, but got \(paragraph.items[i])")
                }
            }
        }
    }

    static func checkResults(items: [Block]) throws {
        guard items.count == 4 else {
            throw ParseError.customError(message: "Wrong number of elements")
        }
        // swiftlint:disable line_length
        try DocumentConverterSpec.checkHeading(item: items[0], identifier: "first heading", expectedLevel: .h1, expectedText: "Heading 1")
        try DocumentConverterSpec.checkHeading(item: items[1], identifier: "second heading", expectedLevel: .h2, expectedText: "Heading 2")
        print("items[2] = \(items[2])")
        try DocumentConverterSpec.checkParagraph(item: items[2], identifier: "first paragraph", expectedText: ["Simple paragraph", nil, "with two lines"])
        try DocumentConverterSpec.checkParagraph(item: items[3], identifier: "second paragraph", expectedText: ["Another Paragraph"])
        // swiftlint:enable line_length

    }

    // swiftlint:disable function_body_length
    override func spec() {
        // Be sure to change checkResults if you change this!
        let markdown = """
# Heading 1
## Heading 2
Simple paragraph
with two lines

Another Paragraph
"""
        describe("Parsing document") {
            it("can work as normally expected to be called") {
                do {
                    let document = try Document(text: markdown)
                    try DocumentConverterSpec.checkResults(items: document.items)
                } catch ParseError.customError(let message) {
                    fail(message)
                } catch let error {
                    fail("\(error.localizedDescription)")
                }
            }
            it("works if a user calls convert on the document themselves to make a document") {
                do {
                    let cmDocument = try CMDocument(text: markdown)
                    let converter = DocumentConverter()
                    let convertedDoc = try converter.convert(document: cmDocument)
                    try DocumentConverterSpec.checkResults(items: convertedDoc.items)
                } catch ParseError.customError(let message) {
                    fail(message)
                } catch let error {
                    fail("\(error.localizedDescription)")
                }
            }
            it("works if a user converts the CMDocument node themselves, and never makes a Document") {
                do {
                    let cmDocument = try CMDocument(text: markdown)
                    let converter = DocumentConverter()
                    let items = try converter.convert(cmNode: cmDocument.node)
                    try DocumentConverterSpec.checkResults(items: items)
                } catch ParseError.customError(let message) {
                    fail(message)
                } catch let error {
                    fail("\(error.localizedDescription)")
                }
            }
            it("works if a user converts a subnode") {
                do {
                    let cmDocument = try CMDocument(text: markdown)
                    let converter = DocumentConverter()
                    let item1 = try converter.convert(cmNode: cmDocument.node.firstChild!)
                    let item2 = try converter.convert(cmNode: cmDocument.node.firstChild!.next!)
                    let item3 = try converter.convert(cmNode: cmDocument.node.firstChild!.next!.next!)
                    let item4 = try converter.convert(cmNode: cmDocument.node.firstChild!.next!.next!.next!)
                    try DocumentConverterSpec.checkResults(items: [item1[0], item2[0], item3[0], item4[0]])
                } catch ParseError.customError(let message) {
                    fail(message)
                } catch let error {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }
}
