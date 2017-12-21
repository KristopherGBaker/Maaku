//
//  DocumentConverter.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a way of converting a CMDocument to a Document
public class DocumentConverter {

    /// The CMDocument.
    private let document: CMDocument
    
    /// The converted block nodes.
    fileprivate var nodes: [Node] = []
    
    /// Creates a converter initialized with the specified CMDocument.
    ///
    /// - Parameters:
    ///     - document: The CMDocument.
    /// - Returns:
    ///     The initialized converter.
    public init(document: CMDocument) {
        self.document = document
    }
    
    /// Converts the CMDocument to a Document.
    ///
    /// - Throws:
    ///     `CMParseError.invalidEventType` if an invalid event type is encountered.
    /// - Returns:
    ///     The converted document.
    public func convert() throws -> Document {
        let parser = CMParser(document: document, delegate: self)
        try parser.parse()
        
        var items = [Block]()
        
        for node in nodes {
            if let blockNode = node as? Block {
                items.append(blockNode)
            }
        }
        
        return Document(items: items)
    }
    
}

/// Extends DocumentConverter as a CMParserDelegate.
extension DocumentConverter: CMParserDelegate {
    
    public func parserDidStartDocument(parser: CMParser) {
        
    }
    
    public func parserDidEndDocument(parser: CMParser) {
        
    }
    
    public func parserDidAbort(parser: CMParser) {
        
    }
    
    public func parser(parser: CMParser, foundText text: String) {
        nodes.append(Text(text: text))
    }
    
    public func parserFoundThematicBreak(parser: CMParser) {
        nodes.append(HorizontalRule())
    }
    
    public func parser(parser: CMParser, didStartHeadingWithLevel level: Int32) {
        nodes.append(Heading(level: HeadingLevel(rawValue: Int(level)) ?? .unknown))
    }
    
    public func parser(parser: CMParser, didEndHeadingWithLevel level: Int32) {
        var inlineItems: [Inline] = []
        
        while let item = nodes.last as? Inline {
            inlineItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let heading = nodes.last as? Heading {
            nodes.removeLast()
            nodes.append(heading.with(items: inlineItems))
        }
    }
    
    public func parserDidStartParagraph(parser: CMParser) {
        let paragraph = Paragraph()
        nodes.append(paragraph)
    }
    
    public func parserDidEndParagraph(parser: CMParser) {
        var inlineItems: [Inline] = []
        
        while let item = nodes.last as? Inline {
            inlineItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        var plugin: Plugin?
        
        if inlineItems.count == 1 {
            // check for plugins, which can either be a link node, or a text node
            var markdownLink: Link? = inlineItems.first as? Link
            
            if markdownLink == nil, let text = inlineItems.first as? Text  {
                markdownLink = Link(text: text)
            }
            
            if let link = markdownLink , let name = link.text.first as? Text, let contents = link.destination {
                plugin = PluginManager.parseBlockLink(name: name.text, contents: contents)
            }
        }
        
        if let _ = nodes.last as? Paragraph {
            nodes.removeLast()
            
            if let plug = plugin {
                nodes.append(plug)
            }
            else {
                nodes.append(Paragraph(items: inlineItems))
            }
        }
    }
    
    public func parserDidStartEmphasis(parser: CMParser) {
        nodes.append(Emphasis())
    }
    
    public func parserDidEndEmphasis(parser: CMParser) {
        var inlineItems: [Inline] = []
        
        while let item = nodes.last as? Inline, !(item is Emphasis) {
            inlineItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let _ = nodes.last as? Emphasis {
            nodes.removeLast()
            nodes.append(Emphasis(items: inlineItems))
        }
    }
    
    public func parserDidStartStrong(parser: CMParser) {
        nodes.append(Strong())
    }
    
    public func parserDidEndStrong(parser: CMParser) {
        var inlineItems: [Inline] = []
        
        while let item = nodes.last as? Inline, !(item is Strong) {
            inlineItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let _ = nodes.last as? Strong {
            nodes.removeLast()
            nodes.append(Strong(items: inlineItems))
        }
    }
    
    public func parser(parser: CMParser, didStartLinkWithDestination destination: String?, title: String?) {
        let link = Link(destination: destination, title: title)
        nodes.append(link)
    }
    
    public func parser(parser: CMParser, didEndLinkWithDestination destination: String?, title: String?) {
        var inlineItems: [Inline] = []
        
        while let item = nodes.last as? Inline, !(item is Link) {
            inlineItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let link = nodes.last as? Link {
            nodes.removeLast()
            nodes.append(link.with(text: inlineItems))
        }
    }
    
    public func parser(parser: CMParser, didStartImageWithDestination destination: String?, title: String?) {
        nodes.append(Image(destination: destination, title: title))
    }
    
    public func parser(parser: CMParser, didEndImageWithDestination destination: String?, title: String?) {
        var inlineItems: [Inline] = []
        
        while let item = nodes.last as? Inline, !(item is Image) {
            inlineItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let image = nodes.last as? Image {
            nodes.removeLast()
            nodes.append(image.with(description: inlineItems))
        }
    }
    
    public func parser(parser: CMParser, foundHtml html: String) {
        nodes.append(HtmlBlock(html: html))
    }
    
    public func parser(parser: CMParser, foundInlineHtml html: String) {
        // TODO: update DocumentConverter to properly deal with inline HTML
        nodes.append(InlineHtml(html: html))
    }
    
    public func parser(parser: CMParser, foundCodeBlock code: String, info: String) {
        nodes.append(CodeBlock(code: code, info: info))
    }
    
    public func parser(parser: CMParser, foundInlineCode code: String) {
        nodes.append(InlineCode(code: code))
    }
    
    public func parserFoundSoftBreak(parser: CMParser) {
        nodes.append(SoftBreak())
    }
    
    public func parserFoundLineBreak(parser: CMParser) {
        nodes.append(LineBreak())
    }
    
    public func parserDidStartBlockQuote(parser: CMParser) {
        nodes.append(BlockQuote())
    }
    
    public func parserDidEndBlockQuote(parser: CMParser) {
        var blockItems: [Block] = []
        
        while let item = nodes.last as? Block, !(item is BlockQuote) {
            blockItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let _ = nodes.last as? BlockQuote {
            nodes.removeLast()
            nodes.append(BlockQuote(items: blockItems))
        }
    }
    
    public func parser(parser: CMParser, didStartUnorderedListWithTightness tight: Bool) {
        nodes.append(UnorderedList())
    }
    
    public func parser(parser: CMParser, didEndUnorderedListWithTightness tight: Bool) {
        var blockItems: [Block] = []
        
        while let item = nodes.last as? Block, !(item is UnorderedList) {
            blockItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let _ = nodes.last as? UnorderedList {
            nodes.removeLast()
            nodes.append(UnorderedList(items: blockItems))
        }
    }
    
    public func parser(parser: CMParser, didStartOrderedListWithStartingNumber num: Int32, tight: Bool) {
        nodes.append(OrderedList())
    }
    
    public func parser(parser: CMParser, didEndOrderedListWithStartingNumber num: Int32, tight: Bool) {
        var blockItems: [Block] = []
        
        while let item = nodes.last as? Block, !(item is OrderedList) {
            blockItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let _ = nodes.last as? OrderedList {
            nodes.removeLast()
            nodes.append(OrderedList(items: blockItems))
        }
    }
    
    public func parserDidStartListItem(parser: CMParser) {
        nodes.append(ListItem())
    }
    
    public func parserDidEndListItem(parser: CMParser) {
        var blockItems: [Block] = []
        
        while let item = nodes.last as? Block, !(item is ListItem) {
            blockItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let _ = nodes.last as? ListItem {
            nodes.removeLast()
            nodes.append(ListItem(items: blockItems))
        }
    }
    
    public func parser(parser: CMParser, didStartCustomBlock content: String) {
        
    }
    
    public func parser(parser: CMParser, didEndCustomBlock content: String) {
        
    }
    
    public func parser(parser: CMParser, didStartCustomInline content: String) {
        
    }
    
    public func parser(parser: CMParser, didEndCustomInline content: String) {
        
    }
    
    public func parser(parser: CMParser, didStartFootnoteDefinition num: Int32) {
        nodes.append(FootnoteDefinition(number: Int(num)))
    }
    
    public func parser(parser: CMParser, didEndFootnoteDefinition num: Int32) {
        var blockItems: [Block] = []
        
        while let item = nodes.last as? Block, !(item is FootnoteDefinition) {
            blockItems.insert(item, at: 0)
            nodes.removeLast()
        }
        
        if let _ = nodes.last as? FootnoteDefinition {
            nodes.removeLast()
            nodes.append(FootnoteDefinition(number: Int(num), items: blockItems))
        }
    }
    
    public func parser(parser: CMParser, foundFootnoteReference reference: String) {
        nodes.append(FootnoteReference(reference: reference))
    }
    
}
