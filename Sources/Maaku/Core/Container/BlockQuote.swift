//
//  BlockQuote.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown block quote.
public struct BlockQuote: ContainerBlock {

    /// The blockquote items.
    public let items: [Block]

    /// Creates a BlockQuote.
    ///
    /// - Returns:
    ///     The initialized BlockQuote.
    public init() {
        items = []
    }

    /// Creates a BlockQuote with the specified items.
    ///
    /// - Parameters:
    ///     - items: The block items.
    /// - Returns:
    ///     The initialized BlockQuote.
    public init(items: [Block]) {
        self.items = items
    }

}

public extension BlockQuote {

    func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        for item in items {
            attributed.append(item.attributedText(style: style))
        }

        return attributed
    }

}
