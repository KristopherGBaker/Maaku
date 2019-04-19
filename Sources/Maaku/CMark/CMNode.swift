//
//  CMNode.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation
import libcmark_gfm

/// Represents a cmark node.
public class CMNode {

    /// The underlying cmark node pointer.
    public let cmarkNode: UnsafeMutablePointer<cmark_node>

    /// Indicates if the node should be freed when done.
    private let freeWhenDone: Bool

    /// Creates a CMNode with the specified cmark node pointer.
    ///
    /// - Parameters:
    ///     - cmarkNode: The underlying cmark node pointer.
    ///     - freeWhenDone: Indicates if the node should be freed when done.
    /// - Returns:
    ///     The CMMnode initialized with the specified cmark node pointer.
    public init(cmarkNode: UnsafeMutablePointer<cmark_node>, freeWhenDone: Bool) {
        self.cmarkNode = cmarkNode
        self.freeWhenDone = freeWhenDone
    }

    /// Frees the cmark node pointer if necessary.
    deinit {
        if freeWhenDone {
            cmark_node_free(cmarkNode)
        }
    }
}

/// Node extension properties.
public extension CMNode {

    /// Wraps the cmark node pointer in a CMNode.
    ///
    /// - Parameters:
    ///     cmarkNode: The cmark node pointer.
    /// - Returns:
    ///     The CMMNode wrapping the pointer.
    private func wrap(cmarkNode: UnsafeMutablePointer<cmark_node>?) -> CMNode? {
        guard let node = cmarkNode else {
            return nil
        }

        return CMNode(cmarkNode: node, freeWhenDone: false)
    }

    /// The next node.
    public var next: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.next)
    }

    /// The previous node.
    public var previous: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.prev)
    }

    /// The parent node.
    public var parent: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.parent)
    }

    /// The first child.
    public var firstChild: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.first_child)
    }

    /// The last child.
    public var lastChild: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.last_child)
    }

    /// The node type.
    public var type: CMNodeType {
        let cmarkNodeType = cmark_node_get_type(cmarkNode)
        return CMNodeType(rawValue: cmarkNodeType.rawValue)
    }

    /// The human readable type.
    public var humanReadableType: String? {
        guard let buffer = cmark_node_get_type_string(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The string value (literal).
    public var stringValue: String? {
        return literal
    }

    /// The string content value.
    public var stringContent: String? {
        guard let buffer = cmark_node_get_string_content(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The heading level.
    public var headingLevel: Int32 {
        return cmark_node_get_heading_level(cmarkNode)
    }

    /// The fenced code info.
    public var fencedCodeInfo: String? {
        guard let buffer = cmark_node_get_fence_info(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The custom on enter value.
    public var customOnEnter: String? {
        guard let buffer = cmark_node_get_on_enter(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The custom on exit value.
    public var customOnExit: String? {
        guard let buffer = cmark_node_get_on_exit(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The list type.
    public var listType: CMListType {
        return CMListType(rawValue: cmark_node_get_list_type(cmarkNode).rawValue) ?? .none
    }

    /// The list delimiter type.
    public var listDelimiterType: CMDelimiterType {
        return CMDelimiterType(rawValue: cmark_node_get_list_delim(cmarkNode).rawValue) ?? .none
    }

    /// The list starting number.
    public var listStartingNumber: Int32 {
        return cmark_node_get_list_start(cmarkNode)
    }

    /// The list tight.
    public var listTight: Bool {
        return cmark_node_get_list_tight(cmarkNode) != 0
    }

    /// The URL as a string.
    public var destination: String? {
        guard let buffer = cmark_node_get_url(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The URL.
    public var url: URL? {
        guard let destination = destination else {
            return nil
        }

        return URL(string: destination)
    }

    /// The title.
    public var title: String? {
        guard let buffer = cmark_node_get_title(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The literal.
    public var literal: String? {
        guard let buffer = cmark_node_get_literal(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The start line.
    public var startLine: Int32 {
        return cmark_node_get_start_line(cmarkNode)
    }

    /// The start column.
    public var startColumn: Int32 {
        return cmark_node_get_start_column(cmarkNode)
    }

    /// The end line.
    public var endLine: Int32 {
        return cmark_node_get_end_line(cmarkNode)
    }

    /// The end column.
    public var endColumn: Int32 {
        return cmark_node_get_end_column(cmarkNode)
    }

    /// Returns an iterator for the node.
    public var iterator: Iterator? {
        return Iterator(node: self)
    }

}

/// Node rendering methods
public extension CMNode {

    /// Renders the node as HTML.
    ///
    /// - Parameters:
    ///     - options: The document options.
    ///     - extensions: The extension options.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the HTML.
    /// - Returns:
    ///     The HTML as a string.
    public func renderHtml(_ options: CMDocumentOption, extensions: CMExtensionOption) throws -> String {
        var htmlExtensions: UnsafeMutablePointer<cmark_llist>?

        if extensions.contains(.tagfilters), let tagfilter = cmark_find_syntax_extension("tagfilter") {
            htmlExtensions = cmark_llist_append(cmark_get_default_mem_allocator(), nil, tagfilter)
        }

        guard let buffer = cmark_render_html(cmarkNode, options.rawValue, htmlExtensions) else {
            throw CMDocumentError.renderError
        }

        defer {
            free(buffer)
        }

        guard let html = String(validatingUTF8: buffer) else {
            throw CMDocumentError.renderError
        }

        return html
    }

    /// Renders the node as XML.
    ///
    /// - Parameters:
    ///     - options: The document options.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the XML.
    /// - Returns:
    ///     The XML as a string.
    public func renderXml(_ options: CMDocumentOption) throws -> String {
        guard let buffer = cmark_render_xml(cmarkNode, options.rawValue) else {
            throw CMDocumentError.renderError
        }

        defer {
            free(buffer)
        }

        guard let xml = String(validatingUTF8: buffer) else {
            throw CMDocumentError.renderError
        }

        return xml
    }

    /// Renders the node as groff man page.
    ///
    /// - Parameters:
    ///     - options: The document options.
    ///     - width: The man page width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the man page.
    /// - Returns:
    ///     The man page as a string.
    public func renderMan(_ options: CMDocumentOption, width: Int32) throws -> String {
        guard let buffer = cmark_render_man(cmarkNode, options.rawValue, width) else {
            throw CMDocumentError.renderError
        }

        defer {
            free(buffer)
        }

        guard let man = String(validatingUTF8: buffer) else {
            throw CMDocumentError.renderError
        }

        return man
    }

    /// Renders the node as common mark.
    ///
    /// - Parameters:
    ///     - options: The document options.
    ///     - width: The common mark width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the common mark.
    /// - Returns:
    ///     The common mark as a string.
    public func renderCommonMark(_ options: CMDocumentOption, width: Int32) throws -> String {
        guard let buffer = cmark_render_commonmark(cmarkNode, options.rawValue, width) else {
            throw CMDocumentError.renderError
        }

        defer {
            free(buffer)
        }

        guard let commonMark = String(validatingUTF8: buffer) else {
            throw CMDocumentError.renderError
        }

        return commonMark
    }

    /// Renders the node as Latex.
    ///
    /// - Parameters:
    ///     - options: The document options.
    ///     - width: The Latex width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the Latex.
    /// - Returns:
    ///     The Latex as a string.
    public func renderLatex(_ options: CMDocumentOption, width: Int32) throws -> String {
        guard let buffer = cmark_render_latex(cmarkNode, options.rawValue, width) else {
            throw CMDocumentError.renderError
        }

        defer {
            free(buffer)
        }

        guard let latex = String(validatingUTF8: buffer) else {
            throw CMDocumentError.renderError
        }

        return latex
    }

    /// Renders the node as plain text.
    ///
    /// - Parameters:
    ///     - options: The document options.
    ///     - width: The plain text width.
    /// - Throws:
    ///     `CMDocumentError.renderError` if there is an error rendering the plain text.
    /// - Returns:
    ///     The plain text as a string.
    public func renderPlainText(_ options: CMDocumentOption, width: Int32) throws -> String {
        guard let buffer = cmark_render_plaintext(cmarkNode, options.rawValue, width) else {
            throw CMDocumentError.renderError
        }

        defer {
            free(buffer)
        }

        guard let text = String(validatingUTF8: buffer) else {
            throw CMDocumentError.renderError
        }

        return text
    }

}
