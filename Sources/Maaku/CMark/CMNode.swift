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
    var next: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.next)
    }

    /// The previous node.
    var previous: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.prev)
    }

    /// The parent node.
    var parent: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.parent)
    }

    /// The first child.
    var firstChild: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.first_child)
    }

    /// The last child.
    var lastChild: CMNode? {
        return wrap(cmarkNode: cmarkNode.pointee.last_child)
    }

    /// The node type.
    var type: CMNodeType {
        let cmarkNodeType = cmark_node_get_type(cmarkNode)
        return CMNodeType(rawValue: cmarkNodeType.rawValue)
    }

    /// The human readable type.
    var humanReadableType: String? {
        guard let buffer = cmark_node_get_type_string(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The string value (literal).
    var stringValue: String? {
        return literal
    }

    /// The string content value.
    var stringContent: String? {
        guard let buffer = cmark_node_get_string_content(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The heading level.
    var headingLevel: Int32 {
        return cmark_node_get_heading_level(cmarkNode)
    }

    /// The fenced code info.
    var fencedCodeInfo: String? {
        guard let buffer = cmark_node_get_fence_info(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The custom on enter value.
    var customOnEnter: String? {
        guard let buffer = cmark_node_get_on_enter(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The custom on exit value.
    var customOnExit: String? {
        guard let buffer = cmark_node_get_on_exit(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The list type.
    var listType: CMListType {
        return CMListType(rawValue: cmark_node_get_list_type(cmarkNode).rawValue) ?? .none
    }

    /// The list delimiter type.
    var listDelimiterType: CMDelimiterType {
        return CMDelimiterType(rawValue: cmark_node_get_list_delim(cmarkNode).rawValue) ?? .none
    }

    /// The list starting number.
    var listStartingNumber: Int32 {
        return cmark_node_get_list_start(cmarkNode)
    }

    /// The list tight.
    var listTight: Bool {
        return cmark_node_get_list_tight(cmarkNode) != 0
    }

    /// The URL as a string.
    var destination: String? {
        guard let buffer = cmark_node_get_url(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The URL.
    var url: URL? {
        guard let destination = destination else {
            return nil
        }

        return URL(string: destination)
    }

    /// The title.
    var title: String? {
        guard let buffer = cmark_node_get_title(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The literal.
    var literal: String? {
        guard let buffer = cmark_node_get_literal(cmarkNode) else {
            return nil
        }

        return String(cString: buffer)
    }

    /// The start line.
    var startLine: Int32 {
        return cmark_node_get_start_line(cmarkNode)
    }

    /// The start column.
    var startColumn: Int32 {
        return cmark_node_get_start_column(cmarkNode)
    }

    /// The end line.
    var endLine: Int32 {
        return cmark_node_get_end_line(cmarkNode)
    }

    /// The end column.
    var endColumn: Int32 {
        return cmark_node_get_end_column(cmarkNode)
    }

    /// Returns an iterator for the node.
    var iterator: Iterator? {
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
    func renderHtml(_ options: CMDocumentOption, extensions: CMExtensionOption) throws -> String {
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
    func renderXml(_ options: CMDocumentOption) throws -> String {
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
    func renderMan(_ options: CMDocumentOption, width: Int32) throws -> String {
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
    func renderCommonMark(_ options: CMDocumentOption, width: Int32) throws -> String {
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
    func renderLatex(_ options: CMDocumentOption, width: Int32) throws -> String {
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
    func renderPlainText(_ options: CMDocumentOption, width: Int32) throws -> String {
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
