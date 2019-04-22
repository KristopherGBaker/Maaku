//
//  UnorderedList.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown unordered list.
public struct UnorderedList: List {

    /// The block items.
    public let items: [Block]

    /// Creates an UnorderedList.
    ///
    /// - Returns:
    ///     The initialized UnorderedList.
    public init() {
        items = []
    }

    /// Creates an UnorderedList with the specified items.
    ///
    /// - Parameters:
    ///     - items: The block items.
    /// - Returns:
    ///     The initialized UnorderedList.
    public init(items: [Block]) {
        self.items = items
    }

}

public extension UnorderedList {

    func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        for item in items {
            let bullet = NSAttributedString(
                string: "• ",
                attributes: [.font: style.fonts.current, .foregroundColor: style.colors.current]
            )
            attributed.append(bullet)
            attributed.append(item.attributedText(style: style))
        }

        return attributed
    }

}
