//
//  CMDocument.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation
import libcmark_gfm

/// Represents a cmark document error.
public enum CMDocumentError: Error {
    
    /// The parsing error type.
    case parsingError
    
    /// The render error type.
    case renderError
}

/// Represents a cmark document.
public class CMDocument {
    
    /// The root node of the document.
    public let node: CMNode
    
    /// The document options.
    private let options: CMDocumentOption
    
    /// Creates a document initialized with the specified data using the default options.
    ///
    /// - Parameters:
    ///     - data: The document data.
    /// - Throws:
    ///     `CMDocumentError.parsingError` if there is an error parsing the data.
    /// - Returns:
    ///     The initialized and parsed document.
    public convenience init(data: Data) throws {
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
    public convenience init(text: String) throws {
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
    public convenience init(data: Data, options: CMDocumentOption) throws {
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
        self.options = options
        core_extensions_ensure_registered()
        
        guard let cmarkNode = cmark_parse_document(text, text.utf8.count, options.rawValue) else {
            throw CMDocumentError.parsingError
        }
        
        node = CMNode(cmarkNode: cmarkNode, freeWhenDone: true)
    }
    
}

/// Document rendering methods.
public extension CMDocument {
    
    /// Renders the document as HTML.
    ///
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the HTML.
    /// - Returns:
    ///     The HTML as a string.
    public func renderHtml() throws -> String {
        return try node.renderHtml(options)
    }
    
    /// Renders the document as XML.
    ///
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the XML.
    /// - Returns:
    ///     The XML as a string.
    public func renderXml() throws -> String {
        return try node.renderXml(options)
    }
    
    /// Renders the document as groff man page.
    ///
    /// - Parameters:
    ///     - width: The man page width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the man page.
    /// - Returns:
    ///     The man page as a string.
    public func renderMan(width: Int32) throws -> String {
        return try node.renderMan(options, width: width)
    }
    
    /// Renders the document as common mark.
    ///
    /// - Parameters:
    ///     - width: The common mark width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the common mark.
    /// - Returns:
    ///     The common mark as a string.
    public func renderCommonMark(width: Int32) throws -> String {
        return try node.renderCommonMark(options, width: width)
    }
    
    /// Renders the document as Latex.
    ///
    /// - Parameters:
    ///     - width: The Latex width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the Latex.
    /// - Returns:
    ///     The Latex as a string.
    public func renderLatex(width: Int32) throws -> String {
        return try node.renderLatex(options, width: width)
    }
    
    /// Renders the document as plain text.
    ///
    /// - Parameters:
    ///     - width: The plain text width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the plain text.
    /// - Returns:
    ///     The plain text as a string.
    public func renderPlainText(width: Int32) throws -> String {
        return try node.renderPlainText(options, width: width)
    }
    
}
