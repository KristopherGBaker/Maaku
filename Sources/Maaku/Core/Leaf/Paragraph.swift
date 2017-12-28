//
//  Paragraph.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown paragraph.
public struct Paragraph: LeafBlock {

    /// The inline items.
    public let items: [Inline]

    /// Creates a Paragraph.
    ///
    /// - Returns:
    ///     The initialized Paragraph.
    public init() {
        items = []
    }

    /// Creates a Paragraph with the specified items.
    ///
    /// - Parameters:
    ///     - items: The inline items.
    /// - Returns:
    ///     The initialized Paragraph.
    public init(items: [Inline]) {
        self.items = items
    }
}

public extension Paragraph {

    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        for item in items {
            attributed.append(item.attributedText(style: style.font(type: .current, font: style.font(.paragraph))))
        }

        return attributed
    }

}
