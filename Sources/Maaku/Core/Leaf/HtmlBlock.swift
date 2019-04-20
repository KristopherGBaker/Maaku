//
//  HtmlBlock.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

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

    func attributedText(style: Style) -> NSAttributedString {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let data = html.data(using: .utf16, allowLossyConversion: false),
            let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: style.fonts.current,
                    .foregroundColor: style.colors.current
                ]
                return NSAttributedString(string: html, attributes: attributes)
        }

        return attributed
    }

}
