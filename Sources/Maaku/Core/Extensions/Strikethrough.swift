//
//  Strikethrough.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown strikethrough.
public struct Strikethrough: Inline {

    /// The inline items.
    public let items: [Inline]

    /// Creates a Strikethrough.
    ///
    /// - Returns:
    ///     The initialized Strikethrough.
    public init() {
        items = []
    }

    /// Creates a Strikethrough with the specified items.
    ///
    /// - Parameters:
    ///     - items: The inline items.
    /// - Returns:
    ///     The initialized Strikethrough.
    public init(items: [Inline]) {
        self.items = items
    }
}

public extension Strikethrough {

    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        var strikethroughStyle = style
        strikethroughStyle.hasStrikethrough = true

        for item in items {
            attributed.append(item.attributedText(style: strikethroughStyle))
        }

        return attributed
    }

}
