//
//  CMParser.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

// swiftlint:disable file_length

import Foundation
import libcmark_gfm

/// cmark gfm extension names
enum CMExtensionName: String {

    /// Strikethrough
    case strikethrough

    /// Table
    case table

    /// Table Cell
    case tableCell = "table_cell"

    /// Table Header
    case tableHeader = "table_header"

    /// Table Row
    case tableRow = "table_row"
}

/// The interface a markdown parser uses to inform its delegate
/// about the content of the parsed document.
public protocol CMParserDelegate: class {

    /// Sent by the parser object to the delegate when it begins parsing a document.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartDocument(parser: CMParser)

    /// Sent by the parser object to the delegate when it has successfully completed parsing.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndDocument(parser: CMParser)

    /// Sent by the parser object to the delegate when it aborts parsing.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidAbort(parser: CMParser)

    /// Sent by the parser object to the delegate when it finds text.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - text: The text.
    func parser(parser: CMParser, foundText text: String)

    /// Sent by the parser object to the delegate when it finds a thematic break (horizontal rule).
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserFoundThematicBreak(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a heading.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - level: The heading level.
    func parser(parser: CMParser, didStartHeadingWithLevel level: Int32)

    /// Sent by the parser object to the delegate when it encounters the end of a heading.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - level: The heading level.
    func parser(parser: CMParser, didEndHeadingWithLevel level: Int32)

    /// Sent by the parser object to the delegate when it encounters the start of a paragraph.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartParagraph(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a paragraph.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndParagraph(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of an emphasis.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartEmphasis(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of an emphasis.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndEmphasis(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a strong.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartStrong(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a strong.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndStrong(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a link.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - destination: The link destination.
    ///     - title: The link title.
    func parser(parser: CMParser, didStartLinkWithDestination destination: String?, title: String?)

    /// Sent by the parser object to the delegate when it encounters the end of a link.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - destination: The link destination.
    ///     - title: The link title.
    func parser(parser: CMParser, didEndLinkWithDestination destination: String?, title: String?)

    /// Sent by the parser object to the delegate when it encounters the start of an image.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - destination: The image destination.
    ///     - title: The image title.
    func parser(parser: CMParser, didStartImageWithDestination destination: String?, title: String?)

    /// Sent by the parser object to the delegate when it encounters the end of an image.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - destination: The image destination.
    ///     - title: The image title.
    func parser(parser: CMParser, didEndImageWithDestination destination: String?, title: String?)

    /// Sent by the parser object to the delegate when it encounters an HTML block.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - html: The HTML.
    func parser(parser: CMParser, foundHtml html: String)

    /// Sent by the parser object to the delegate when it encounters inline HTML.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - html: The HTML.
    func parser(parser: CMParser, foundInlineHtml html: String)

    /// Sent by the parser object to the delegate when it encounters a code block.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - code: The code.
    ///     - info: The code info (language).
    func parser(parser: CMParser, foundCodeBlock code: String, info: String)

    /// Sent by the parser object to the delegate when it encounters inline code.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - code: The code.
    func parser(parser: CMParser, foundInlineCode code: String)

    /// Sent by the parser object to the delegate when it encounters a soft break.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserFoundSoftBreak(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters a line break.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserFoundLineBreak(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a blockquote.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartBlockQuote(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a blockquote.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndBlockQuote(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of an unordered list.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - tight: The list tightness.
    func parser(parser: CMParser, didStartUnorderedListWithTightness tight: Bool)

    /// Sent by the parser object to the delegate when it encounters the end of an unordered list.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - tight: The list tightness.
    func parser(parser: CMParser, didEndUnorderedListWithTightness tight: Bool)

    /// Sent by the parser object to the delegate when it encounters the start of an ordered list.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - num: The list starting number.
    ///     - tight: The list tightness.
    func parser(parser: CMParser, didStartOrderedListWithStartingNumber num: Int32, tight: Bool)

    /// Sent by the parser object to the delegate when it encounters the end of an ordered list.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - num: The list starting number.
    ///     - tight: The list tightness.
    func parser(parser: CMParser, didEndOrderedListWithStartingNumber num: Int32, tight: Bool)

    /// Sent by the parser object to the delegate when it encounters the start of a list item.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartListItem(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a list item.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndListItem(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a custom block.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - contents: The custom block contents.
    func parser(parser: CMParser, didStartCustomBlock contents: String)

    /// Sent by the parser object to the delegate when it encounters the end of a custom block.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - contents: The custom block contents.
    func parser(parser: CMParser, didEndCustomBlock contents: String)

    /// Sent by the parser object to the delegate when it encounters the start of a custom inline.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - contents: The custom block contents.
    func parser(parser: CMParser, didStartCustomInline contents: String)

    /// Sent by the parser object to the delegate when it encounters the end of a custom inline.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - contents: The custom block contents.
    func parser(parser: CMParser, didEndCustomInline contents: String)

    /// Sent by the parser object to the delegate when it encounters the start of a footnote definition.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - num: The footnote definition number.
    func parser(parser: CMParser, didStartFootnoteDefinition num: Int32)

    /// Sent by the parser object to the delegate when it encounters the end of a footnote definition.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - num: The footnote definition number.
    func parser(parser: CMParser, didEndFootnoteDefinition num: Int32)

    /// Sent by the parser object to the delegate when it encounters a footnote reference.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - reference: The footnote reference.
    func parser(parser: CMParser, foundFootnoteReference reference: String)

    /// Sent by the parser object to the delegate when it encounters the start of a table.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - columns: The number of table columns.
    ///     - alignemnts: The table alignments.
    func parser(parser: CMParser, didStartTableWithColumns columns: UInt16, alignments: [String])

    /// Sent by the parser object to the delegate when it encounters the end of a table.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    ///     - columns: The number of table columns.
    ///     - alignemnts: The table alignments.
    func parser(parser: CMParser, didEndTableWithColumns columns: UInt16, alignments: [String])

    /// Sent by the parser object to the delegate when it encounters the start of a table header.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartTableHeader(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a table header.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndTableHeader(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a table row.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartTableRow(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a table row.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndTableRow(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a table cell.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartTableCell(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a table cell.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndTableCell(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the start of a strikethrough.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidStartStrikethrough(parser: CMParser)

    /// Sent by the parser object to the delegate when it encounters the end of a strikethrough.
    ///
    /// - Parameters:
    ///     - parser: The parser.
    func parserDidEndStrikethrough(parser: CMParser)
}

/// Represents a parse error.
public enum CMParseError: Error {

    /// The invalid event type error.
    case invalidEventType
}

/// Represnts a parser.
/// This is not a true parser, but rather a way of traversing a cmark document
/// in a similar way as NSXMLParser.
public class CMParser {

    /// The current footnote index.
    private var footnoteIndex: Int32 = 0

    /// The document.
    private let document: CMDocument

    /// Indicates if the parser is currently parsing.
    private var parsing: Bool = false

    /// The delegate.
    public weak var delegate: CMParserDelegate?

    /// Creates a parser for the specified document.
    ///
    /// - Parameters:
    ///     - document: The document.
    /// - Returns:
    ///     The parser for the document.
    public convenience init(document: CMDocument) {
        self.init(document: document, delegate: nil)
    }

    /// Creates a parser for the specified document.
    ///
    /// - Parameters:
    ///     - document: The document.
    ///     - delegate: The delegate.
    /// - Returns:
    ///     The parser for the document.
    public init(document: CMDocument, delegate: CMParserDelegate?) {
        self.document = document
        self.delegate = delegate
    }

    /// Parses the document, calling delegate methods as needed.
    ///
    /// - Throws:
    ///     `CMParseError.invalidEventType` if an invalid event type is encountered.
    public func parse() throws {
        guard !parsing, let iterator = document.node.iterator else {
            return
        }

        parsing = true

        try iterator.enumerate { [unowned self] (node, eventType) -> Bool in
            try self.handleNode(node, eventType: eventType)
            return !self.parsing
        }

        parsing = false
        footnoteIndex = 0
    }

    /// Aborts parsing
    public func abortParsing() {
        guard parsing else {
            return
        }

        delegate?.parserDidAbort(parser: self)
        parsing = false
    }

    /// Handles the current node.
    ///
    /// - Parameters:
    ///     - node: The current node.
    ///     - eventType: The event type.
    /// - Throws:
    ///     `CMParseError.invalidEventType` if the event type is not enter or exit.
    // swiftlint:disable cyclomatic_complexity function_body_length
    private func handleNode(_ node: CMNode, eventType: CMEventType) throws {
        guard eventType == .enter || eventType == .exit else {
            throw CMParseError.invalidEventType
        }

        switch node.type {
        case .document:
            if eventType == .enter {
                delegate?.parserDidStartDocument(parser: self)
            } else {
                delegate?.parserDidEndDocument(parser: self)
            }
        case .text:
            delegate?.parser(parser: self, foundText: node.stringValue ?? "")
        case .thematicBreak:
            delegate?.parserFoundThematicBreak(parser: self)
        case .heading:
            if eventType == .enter {
                delegate?.parser(parser: self, didStartHeadingWithLevel: node.headingLevel)
            } else {
                delegate?.parser(parser: self, didEndHeadingWithLevel: node.headingLevel)
            }
        case .paragraph:
            if eventType == .enter {
                delegate?.parserDidStartParagraph(parser: self)
            } else {
                delegate?.parserDidEndParagraph(parser: self)
            }
        case .emphasis:
            if eventType == .enter {
                delegate?.parserDidStartEmphasis(parser: self)
            } else {
                delegate?.parserDidEndEmphasis(parser: self)
            }
        case .strong:
            if eventType == .enter {
                delegate?.parserDidStartStrong(parser: self)
            } else {
                delegate?.parserDidEndStrong(parser: self)
            }
        case .link:
            if eventType == .enter {
                delegate?.parser(parser: self, didStartLinkWithDestination: node.destination, title: node.title)
            } else {
                delegate?.parser(parser: self, didEndLinkWithDestination: node.destination, title: node.title)
            }
        case .image:
            if eventType == .enter {
                delegate?.parser(parser: self, didStartImageWithDestination: node.destination, title: node.title)
            } else {
                delegate?.parser(parser: self, didEndImageWithDestination: node.destination, title: node.title)
            }
        case .htmlBlock:
            delegate?.parser(parser: self, foundHtml: node.stringValue ?? "")
        case .htmlInline:
            delegate?.parser(parser: self, foundInlineHtml: node.stringValue ?? "")
        case .codeBlock:
            delegate?.parser(parser: self, foundCodeBlock: node.stringValue ?? "", info: node.fencedCodeInfo ?? "")
        case .code:
            delegate?.parser(parser: self, foundInlineCode: node.stringValue ?? "")
        case .softBreak:
            delegate?.parserFoundSoftBreak(parser: self)
        case .lineBreak:
            delegate?.parserFoundLineBreak(parser: self)
        case .blockQuote:
            if eventType == .enter {
                delegate?.parserDidStartBlockQuote(parser: self)
            } else {
                delegate?.parserDidEndBlockQuote(parser: self)
            }
        case .list:
            switch node.listType {
            case .ordered:
                if eventType == .enter {
                    delegate?.parser(parser: self,
                                     didStartOrderedListWithStartingNumber: node.listStartingNumber,
                                     tight: node.listTight)
                } else {
                    delegate?.parser(parser: self,
                                     didEndOrderedListWithStartingNumber: node.listStartingNumber,
                                     tight: node.listTight)
                }
            case .unordered:
                if eventType == .enter {
                    delegate?.parser(parser: self, didStartUnorderedListWithTightness: node.listTight)
                } else {
                    delegate?.parser(parser: self, didEndUnorderedListWithTightness: node.listTight)
                }
            case .none:
                break
            }
        case .item:
            if eventType == .enter {
                delegate?.parserDidStartListItem(parser: self)
            } else {
                delegate?.parserDidEndListItem(parser: self)
            }
        case .customBlock:
            if eventType == .enter {
                delegate?.parser(parser: self, didStartCustomBlock: node.customOnEnter ?? "")
            } else {
                delegate?.parser(parser: self, didEndCustomBlock: node.customOnExit ?? "")
            }
        case .footnoteDefinition:
            if eventType == .enter {
                footnoteIndex += 1
                delegate?.parser(parser: self, didStartFootnoteDefinition: footnoteIndex)
            } else {
                delegate?.parser(parser: self, didEndFootnoteDefinition: footnoteIndex)
            }
        case .customInline:
            if eventType == .enter {
                delegate?.parser(parser: self, didStartCustomInline: node.customOnEnter ?? "")
            } else {
                delegate?.parser(parser: self, didEndCustomInline: node.customOnExit ?? "")
            }
        case .footnoteReference:
            if eventType == .enter {
                delegate?.parser(parser: self, foundFootnoteReference: node.stringValue ?? "")
            }
        default:
            handleExtensions(node, eventType: eventType)
        }
    }

    /// Handles extensions for the current node.
    ///
    /// - Parameters:
    ///     - node: The current node.
    ///     - eventType: The event type.
    private func handleExtensions(_ node: CMNode, eventType: CMEventType) {
        guard let nodeName = node.humanReadableType else {
            return
        }

        _ = handleTable(node, nodeName: nodeName, eventType: eventType) ||
            handleStrikethrough(nodeName, eventType: eventType)
    }

    /// Handles strikethrough extensions for the current node.
    ///
    /// - Parameters:
    ///     - nodeName: The human readable node name.
    ///     - eventType: The event type.
    /// - Returns:
    ///     true if the node was handled as a strikethrough, false otherwise.
    @discardableResult
    private func handleStrikethrough(_ nodeName: String, eventType: CMEventType) -> Bool {
        guard nodeName == CMExtensionName.strikethrough.rawValue else {
            return false
        }

        if eventType == .enter {
            delegate?.parserDidStartStrikethrough(parser: self)
        } else {
            delegate?.parserDidEndStrikethrough(parser: self)
        }

        return true
    }

    /// Handles table extensions for the current node.
    ///
    /// - Parameters:
    ///     - node: The current node.
    ///     - nodeName: The human readable node name.
    ///     - eventType: The event type.
    /// - Returns:
    ///     true if the node was handled as a table, table header, table row, or table cell, false otherwise.
    @discardableResult
    private func handleTable(_ node: CMNode, nodeName: String, eventType: CMEventType) -> Bool {
        switch nodeName {
        case CMExtensionName.table.rawValue:
            handleTableEvent(node, eventType: eventType)
        case CMExtensionName.tableHeader.rawValue:
            if eventType == .enter {
                delegate?.parserDidStartTableHeader(parser: self)
            } else {
                delegate?.parserDidEndTableHeader(parser: self)
            }
        case CMExtensionName.tableRow.rawValue:
            if eventType == .enter {
                delegate?.parserDidStartTableRow(parser: self)
            } else {
                delegate?.parserDidEndTableRow(parser: self)
            }
        case CMExtensionName.tableCell.rawValue:
            if eventType == .enter {
                delegate?.parserDidStartTableCell(parser: self)
            } else {
                delegate?.parserDidEndTableCell(parser: self)
            }
        default:
            return false
        }

        return true
    }

    /// Handles table events for the current node.
    ///
    /// - Parameters:
    ///     - node: The current node.
    ///     - eventType: The event type.
    private func handleTableEvent(_ node: CMNode, eventType: CMEventType) {
        let columns = cmark_gfm_extensions_get_table_columns(node.cmarkNode)
        var alignments = cmark_gfm_extensions_get_table_alignments(node.cmarkNode)

        var align: [String] = []

        for idx in 0..<columns {
            if let val =  alignments?.pointee, let str = String(bytes: [val], encoding: .utf8) {
                align.append(str)
            }

            if idx < (columns - 1) {
                alignments = alignments?.successor()
            }
        }

        if eventType == .enter {
            delegate?.parser(parser: self, didStartTableWithColumns: columns, alignments: align)
        } else {
            delegate?.parser(parser: self, didEndTableWithColumns: columns, alignments: align)
        }
    }

}
