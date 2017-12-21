//
//  TableCell.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown table cell.
public struct TableCell: Node {

    /// Node name for parsing.
    static let name = "table_cell"
    
    /// The inline items.
    public let items: [Inline]
    
    /// Creates a TableCell.
    ///
    /// - Returns:
    ///     The initialized TableCell.
    public init() {
        items = []
    }
    
    /// Creates a TableCell with the specified items.
    ///
    /// - Parameters:
    ///     - items: The inline items.
    /// - Returns:
    ///     The initialized TableCell.
    public init(items: [Inline]) {
        self.items = items
    }
    
}

public extension TableCell {
    
    public func attributedText(style: Style) -> NSAttributedString {
        return NSAttributedString()
    }
    
}
