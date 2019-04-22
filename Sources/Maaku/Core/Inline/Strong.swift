//
//  Strong.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown strong.
public struct Strong: Inline {

    /// The inline items.
    public let items: [Inline]

    /// Creates a Strong.
    ///
    /// - Returns:
    ///     The initialized Strong.
    public init() {
        items = []
    }

    /// Creates a Strong with the specified items.
    ///
    /// - Parameters:
    ///     - items: The inline items.
    /// - Returns:
    ///     The initialized Strong.
    public init(items: [Inline]) {
        self.items = items
    }

}

public extension Strong {

    func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        var strongStyle = style
        strongStyle.strong()

        for item in items {
            attributed.append(item.attributedText(style: strongStyle))
        }

        return attributed
    }

}
