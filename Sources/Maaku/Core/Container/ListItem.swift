//
//  ListItem.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown list item.
public struct ListItem: ContainerBlock {

    /// The block items.
    public let items: [Block]

    /// Creates a ListItem.
    ///
    /// - Returns:
    ///     The initialized ListItem.
    public init() {
        items = []
    }

    /// Creates a ListItem with the specified items.
    ///
    /// - Parameters:
    ///     - items: The block items.
    /// - Returns:
    ///     The initialized ListItem.
    public init(items: [Block]) {
        self.items = items
    }

}

public extension ListItem {

    func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        for item in items {
            attributed.append(item.attributedText(style: style))
        }

        return attributed
    }

}
