//
//  FootnoteDefinition.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown footnote definition.
public struct FootnoteDefinition: ContainerBlock {

    /// The block items.
    public let items: [Block]

    /// The footnote number.
    public let number: Int

    /// Creates a FootnoteDefinition with the specified number.
    ///
    /// - Parameters:
    ///     - number: The footnote number.
    /// - Returns:
    ///     The initialized FootnoteDefinition.
    public init(number: Int) {
        items = []
        self.number = number
    }

    /// Creates a FootnoteDefinition with the specified number and items.
    ///
    /// - Parameters:
    ///     - number: The footnote number.
    ///     - items: The block items.
    /// - Returns:
    ///     The initialized FootnoteDefinition.
    public init(number: Int, items: [Block]) {
        self.number = number
        self.items = items
    }

}

public extension FootnoteDefinition {

    func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString(
            string: "\(number). ",
            attributes: [.font: style.fonts.current, .foregroundColor: style.colors.current]
        )

        for item in items {
            attributed.append(item.attributedText(style: style))
        }

        return attributed
    }

}
