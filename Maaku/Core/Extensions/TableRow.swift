//
//  TableRow.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown table row.
public struct TableRow: TableLine {
    
    /// Node name for parsing.
    static let name = "table_row"

    /// The table cells.
    public let cells: [TableCell]
    
    /// Creates a TableHeader.
    ///
    /// - Returns:
    ///     The initialized TableHeader.
    public init() {
        cells = []
    }
    
    /// Creates a TableHeader with the specified cells.
    ///
    /// - Parameters:
    ///     - cells: The table cells.
    /// - Returns:
    ///     The initialized TableHeader.
    public init(cells: [TableCell]) {
        self.cells = cells
    }
    
}

public extension TableRow {
    
    public func attributedText(style: Style) -> NSAttributedString {
        return NSAttributedString()
    }
    
}
