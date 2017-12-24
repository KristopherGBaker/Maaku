//
//  Document.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Defines methods for converting a markdown element to an attributed string.
public protocol MarkdownAttributedString {
    
    /// Returns an attributed string using the specified style.
    ///
    /// - Parameters:
    ///     - style: The style.
    /// - Returns:
    ///     An attributed string.
    func attributedText(style: Style) -> NSAttributedString
    
}

/// Represnts a markdown node, which can be either a markdown block or inline element.
public protocol Node: MarkdownAttributedString {
    
}

/// Represents a markdown document, which is a sequence of markdown block elements.
public struct Document: MarkdownAttributedString {
    
    /// The items (block elements).
    public let items: [Block]
    
    /// Gets the markdown block at the specified index.
    ///
    /// - Parameters:
    ///     - index: The index.
    /// - Returns:
    ///     The markdown block at the specified index.
    public subscript(index: Int) -> Block {
        return items[index]
    }
    
    /// The number of items in the document.
    public var count: Int {
        return items.count
    }
    
    /// Creates a document initialized with the specified items.
    ///
    /// - Parameters:
    ///     - items: The markdown block items.
    /// - Returns:
    ///     The document containing the block items.
    public init(items: [Block]) {
        self.items = items
    }
    
    /// Creates a document initialized with the specified data using the default options.
    ///
    /// - Parameters:
    ///     - data: The document data.
    /// - Throws:
    ///     `CMDocumentError.parsingError` if there is an error parsing the data.
    /// - Returns:
    ///     The initialized and parsed document.
    public init(data: Data) throws {
        try self.init(data: data, options: .default)
    }
    
    /// Creates a document initialized with the specified text using the default options.
    ///
    /// - Parameters:
    ///     - text: The document text.
    /// - Throws:
    ///     `CMDocumentError.parsingError` if there is an error parsing the text.
    /// - Returns:
    ///     The initialized and parsed document.
    public init(text: String) throws {
        try self.init(text: text, options: .default)
    }
    
    /// Creates a document initialized with the specified text.
    ///
    /// - Parameters:
    ///     - data: The document data.
    ///     - options: The document options.
    /// - Throws:
    ///     `CMDocumentError.parsingError` if there is an error parsing the data.
    /// - Returns:
    ///     The initialized and parsed document.
    public init(data: Data, options: CMDocumentOption) throws {
        guard let text = String(data: data, encoding: .utf8) else {
            throw CMDocumentError.parsingError
        }
        try self.init(text: text, options: options)
    }
    
    /// Creates a document initialized with the specified text.
    ///
    /// - Parameters:
    ///     - text: The document text.
    ///     - options: The document options.
    /// - Throws:
    ///     `CMDocumentError.parsingError` if there is an error parsing the text.
    /// - Returns:
    ///     The initialized and parsed document.
    public init(text: String, options: CMDocumentOption) throws {
        try self.init(text: text, options: options, extensions: .all)
    }
    
    /// Creates a document initialized with the specified text.
    ///
    /// - Parameters:
    ///     - text: The document text.
    ///     - options: The document options.
    ///     - extensions: gfm extensions to enable.
    /// - Throws:
    ///     `CMDocumentError.parsingError` if there is an error parsing the text.
    /// - Returns:
    ///     The initialized and parsed document.
    public init(text: String, options: CMDocumentOption, extensions: CMExtensionOption) throws {
        let doc = try CMDocument(text: text, options: options, extensions: extensions)
        let converter = DocumentConverter(document: doc)
        items = (try converter.convert()).items
    }
}

public extension Document {
    
    /// Returns an attributed string using the specified style.
    ///
    /// - Parameters:
    ///     - style: The style.
    /// - Returns:
    ///     An attributed string representing the document.
    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()
        
        for item in items {
            attributed.append(item.attributedText(style: style))
        }
        
        return attributed
    }
    
}
