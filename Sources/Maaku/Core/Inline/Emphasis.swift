//
//  Emphasis.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown emphasis.
public struct Emphasis: Inline {

    /// The inline items.
    public let items: [Inline]

    /// Creates a Emphasis.
    ///
    /// - Returns:
    ///     The initialized Emphasis.
    public init() {
        items = []
    }

    /// Creates a Emphasis with the specified items.
    ///
    /// - Parameters:
    ///     - items: The inline items.
    /// - Returns:
    ///     The initialized Emphasis.
    public init(items: [Inline]) {
        self.items = items
    }
}

public extension Emphasis {

    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        for item in items {
            attributed.append(item.attributedText(style: style.emphasis()))
        }

        return attributed
    }

}
