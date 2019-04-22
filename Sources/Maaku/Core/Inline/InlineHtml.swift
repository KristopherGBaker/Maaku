//
//  InlineHtml.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents markdown inline HTML.
public struct InlineHtml: Inline {

    /// The HTML.
    public let html: String

    /// Creates an InlineHtml with the specified HTML.
    ///
    /// - Parameters:
    ///     - html: The HTML.
    /// - Returns:
    ///     The initialized InlineHtml.
    public init(html: String) {
        self.html = html
    }
}

public extension InlineHtml {

    func attributedText(style: Style) -> NSAttributedString {
        // TODO: update DocumentConverter to properly deal with inline HTML,
        // for now, just render the inline HTML as a string.        
//        guard let data = html.data(using: .utf16, allowLossyConversion: false),
//            let attributedString = try?  NSAttributedString(data: data, options: [.documentType:
//        NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
//        documentAttributes: nil) else {
//            return NSAttributedString(string: html, attributes:
//        [.font: style.currentFont, .foregroundColor: style.currentForegroundColor])
//        }
//        return attributedString

        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.fonts.current,
            .foregroundColor: style.colors.current
        ]
        return NSAttributedString(string: html, attributes: attributes)
    }

}
