//
//  CMParserSpec.swift
//  Maaku
//
//  Created by Tim Learmont on 5/23/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

public enum SpecialParserDelegateError: Error {
    /// An error we can throw from this parser delegate
    case specialParserError
}

class CMParserSpec: QuickSpec {
    override func spec() {
        let markdown = """
# Heading 1
## Heading 2
Simple paragraph

Another Paragraph
"""
        describe("Parsing document with special converter") {
            it("can parse with no errors") {
                do {
                    let cmDocument = try CMDocument(text: markdown)
                    let parserDelegate = SpecialParserDelegate()
                    let parser = CMParser(delegate: parserDelegate)
                    try parser.parse(document: cmDocument)
                } catch let error {
                    fail("\(error.localizedDescription)")
                }
            }
            it("will raise an error if parser is called rentrantly") {
                do {
                    let cmDocument = try CMDocument(text: markdown)
                    let parserDelegate = SpecialParserDelegate(makeReentrantCallOnDocument: cmDocument)
                    let parser = CMParser(delegate: parserDelegate)
                    expect { try parser.parse(document: cmDocument) }.to(throwError(CMParseError.canNotParse))
                } catch let error {
                    fail("\(error.localizedDescription)")
                }
            }
            it("will return an exception thrown by the delegate") {
                do {
                    let cmDocument = try CMDocument(text: markdown)
                    let parserDelegate = SpecialParserDelegate(testThrowingException: true)
                    let parser = CMParser(delegate: parserDelegate)
                    // swiftlint:disable:next line_length
                    expect { try parser.parse(document: cmDocument) }.to(throwError(SpecialParserDelegateError.specialParserError))
                } catch let error {
                    fail("\(error.localizedDescription)")
                }
            }
       }
    }
    class SpecialParserDelegate: CMParserDelegate {
        var makeReentrantCallOnDocument: CMDocument?
        var throwException: Bool
        init(makeReentrantCallOnDocument document: CMDocument? = nil, testThrowingException: Bool = false) {
            makeReentrantCallOnDocument = document
            throwException = testThrowingException
        }

        func parserDidStartDocument(parser: CMParser) throws {
        }

        func parserDidEndDocument(parser: CMParser) throws {
            if let document = makeReentrantCallOnDocument {
                try parser.parse(document: document)
            }
            if throwException {
                throw SpecialParserDelegateError.specialParserError
            }
        }

        func parserDidAbort(parser: CMParser) throws {
        }

        func parser(parser: CMParser, foundText text: String) throws {
        }

        func parserFoundThematicBreak(parser: CMParser) throws {
        }

        func parser(parser: CMParser, didStartHeadingWithLevel level: Int32) throws {
        }

        func parser(parser: CMParser, didEndHeadingWithLevel level: Int32) throws {
        }

        func parserDidStartParagraph(parser: CMParser) throws {
        }

        func parserDidEndParagraph(parser: CMParser) throws {
        }

        func parserDidStartEmphasis(parser: CMParser) throws {
        }

        func parserDidEndEmphasis(parser: CMParser) throws {
        }

        func parserDidStartStrong(parser: CMParser) throws {
        }

        func parserDidEndStrong(parser: CMParser) throws {
        }

        func parser(parser: CMParser, didStartLinkWithDestination destination: String?, title: String?) throws {
        }

        func parser(parser: CMParser, didEndLinkWithDestination destination: String?, title: String?) throws {
        }

        func parser(parser: CMParser, didStartImageWithDestination destination: String?, title: String?) throws {
        }

        func parser(parser: CMParser, didEndImageWithDestination destination: String?, title: String?) throws {
        }

        func parser(parser: CMParser, foundHtml html: String) throws {
        }

        func parser(parser: CMParser, foundInlineHtml html: String) throws {
        }

        func parser(parser: CMParser, foundCodeBlock code: String, info: String) throws {
        }

        func parser(parser: CMParser, foundInlineCode code: String) throws {
        }

        func parserFoundSoftBreak(parser: CMParser) throws {
        }

        func parserFoundLineBreak(parser: CMParser) throws {
        }

        func parserDidStartBlockQuote(parser: CMParser) throws {
        }

        func parserDidEndBlockQuote(parser: CMParser) throws {
        }

        func parser(parser: CMParser, didStartUnorderedListWithTightness tight: Bool) throws {
        }

        func parser(parser: CMParser, didEndUnorderedListWithTightness tight: Bool) throws {
        }

        func parser(parser: CMParser, didStartOrderedListWithStartingNumber num: Int32, tight: Bool) throws {
        }

        func parser(parser: CMParser, didEndOrderedListWithStartingNumber num: Int32, tight: Bool) throws {
        }

        func parserDidStartListItem(parser: CMParser) throws {
        }

        func parserDidEndListItem(parser: CMParser) throws {
        }

        func parser(parser: CMParser, didStartCustomBlock contents: String) throws {
        }

        func parser(parser: CMParser, didEndCustomBlock contents: String) throws {
        }

        func parser(parser: CMParser, didStartCustomInline contents: String) throws {
        }

        func parser(parser: CMParser, didEndCustomInline contents: String) throws {
        }

        func parser(parser: CMParser, didStartFootnoteDefinition num: Int32) throws {
        }

        func parser(parser: CMParser, didEndFootnoteDefinition num: Int32) throws {
        }

        func parser(parser: CMParser, foundFootnoteReference reference: String) throws {
        }

        func parser(parser: CMParser, didStartTableWithColumns columns: UInt16, alignments: [String]) throws {
        }

        func parser(parser: CMParser, didEndTableWithColumns columns: UInt16, alignments: [String]) throws {
        }

        func parserDidStartTableHeader(parser: CMParser) throws {
        }

        func parserDidEndTableHeader(parser: CMParser) throws {
        }

        func parserDidStartTableRow(parser: CMParser) throws {
        }

        func parserDidEndTableRow(parser: CMParser) throws {
        }

        func parserDidStartTableCell(parser: CMParser) throws {
        }

        func parserDidEndTableCell(parser: CMParser) throws {
        }

        func parserDidStartStrikethrough(parser: CMParser) throws {
        }

        func parserDidEndStrikethrough(parser: CMParser) throws {
        }

        func parserDidStartTasklistItem(parser: CMParser, completed: Bool) throws {
        }

        func parserDidEndTasklistItem(parser: CMParser, completed: Bool) throws {
        }
    }

}
