//
//  HtmlBlock.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown HTML block.
public struct HtmlBlock: LeafBlock {
    
    /// The HTML.
    public let html: String
    
    /// Creates a HtmlBlock with the specified HTML.
    ///
    /// - Parameters:
    ///     - html: The HTML.
    /// - Returns:
    ///     The initialized HtmlBlock.
    public init(html: String) {
        self.html = html
    }
}

public extension HtmlBlock {
    
    public func attributedText(style: Style) -> NSAttributedString {
        guard let data = html.data(using: .utf16, allowLossyConversion: false),
            let attributedString = try?  NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
                return NSAttributedString(string: html, attributes: [.font: style.currentFont, .foregroundColor: style.currentForegroundColor])
        }
        
        return attributedString
    }
    
}
