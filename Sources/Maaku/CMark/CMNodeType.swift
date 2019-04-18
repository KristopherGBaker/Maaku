//
//  CMNodeType.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation
import libcmark_gfm

/// Represents a cmark node type.
public struct CMNodeType: Equatable {

    /// The raw value.
    let rawValue: UInt32

    /// The none node type.
    public static let none = CMNodeType(rawValue: CMARK_NODE_NONE.rawValue)

    /// The document node type.
    public static let document = CMNodeType(rawValue: CMARK_NODE_DOCUMENT.rawValue)

    /// The blockquote node type.
    public static let blockQuote = CMNodeType(rawValue: CMARK_NODE_BLOCK_QUOTE.rawValue)

    /// The list node type.
    public static let list = CMNodeType(rawValue: CMARK_NODE_LIST.rawValue)

    /// The list item node type.
    public static let item = CMNodeType(rawValue: CMARK_NODE_ITEM.rawValue)

    /// The code block node type.
    public static let codeBlock = CMNodeType(rawValue: CMARK_NODE_CODE_BLOCK.rawValue)

    /// The HTML block node type.
    public static let htmlBlock = CMNodeType(rawValue: CMARK_NODE_HTML_BLOCK.rawValue)

    /// The custom block node type.
    public static let customBlock = CMNodeType(rawValue: CMARK_NODE_CUSTOM_BLOCK.rawValue)

    /// The paragraph node type.
    public static let paragraph = CMNodeType(rawValue: CMARK_NODE_PARAGRAPH.rawValue)

    /// The heading node type.
    public static let heading = CMNodeType(rawValue: CMARK_NODE_HEADING.rawValue)

    /// The thematic break (horizontal rule) node type.
    public static let thematicBreak = CMNodeType(rawValue: CMARK_NODE_THEMATIC_BREAK.rawValue)

    /// The footnote definition node type.
    public static let footnoteDefinition = CMNodeType(rawValue: CMARK_NODE_FOOTNOTE_DEFINITION.rawValue)

    /// The text node type.
    public static let text = CMNodeType(rawValue: CMARK_NODE_TEXT.rawValue)

    /// The soft break node type.
    public static let softBreak = CMNodeType(rawValue: CMARK_NODE_SOFTBREAK.rawValue)

    /// The line break node type.
    public static let lineBreak = CMNodeType(rawValue: CMARK_NODE_LINEBREAK.rawValue)

    /// The inline code node type.
    public static let code = CMNodeType(rawValue: CMARK_NODE_CODE.rawValue)

    /// The inline HTML node type.
    public static let htmlInline = CMNodeType(rawValue: CMARK_NODE_HTML_INLINE.rawValue)

    /// The inline custom node type.
    public static let customInline = CMNodeType(rawValue: CMARK_NODE_CUSTOM_INLINE.rawValue)

    /// The inline emphasis node type.
    public static let emphasis = CMNodeType(rawValue: CMARK_NODE_EMPH.rawValue)

    /// The inline strong node type.
    public static let strong = CMNodeType(rawValue: CMARK_NODE_STRONG.rawValue)

    /// The inline link node type.
    public static let link = CMNodeType(rawValue: CMARK_NODE_LINK.rawValue)

    /// The inline image node type.
    public static let image = CMNodeType(rawValue: CMARK_NODE_IMAGE.rawValue)

    /// The inline footnote reference node type.
    public static let footnoteReference = CMNodeType(rawValue: CMARK_NODE_FOOTNOTE_REFERENCE.rawValue)

    /// Equatable implementation.
    public static func == (lhs: CMNodeType, rhs: CMNodeType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
