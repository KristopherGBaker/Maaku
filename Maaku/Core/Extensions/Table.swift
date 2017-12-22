//
//  Table.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown row / header.
public protocol TableLine: Node {
    
    var cells: [TableCell] { get }
    
    init()
    
    init(cells: [TableCell])
    
}

/// Represents a markdown table.
public struct Table: LeafBlock {
    
    /// The table header.
    public let header: TableHeader
    
    /// The table rows.
    public let rows: [TableRow]
    
    /// Creates a Table.
    ///
    /// - Returns:
    ///     The initialized Table.
    public init() {
        self.header = TableHeader()
        rows = []
    }
    
    /// Creates a Table.
    ///
    /// - Parameters:
    ///     - header: The table header.
    /// - Returns:
    ///     The initialized Table.
    public init(header: TableHeader) {
        self.header = header
        rows = []
    }
    
    /// Creates a Paragraph with the specified items.
    ///
    /// - Parameters:
    ///     - header: The table header.
    ///     - rows: The table rows.
    /// - Returns:
    ///     The initialized Paragraph.
    public init(header: TableHeader, rows: [TableRow]) {
        self.header = header
        self.rows = rows
    }
}

public extension Table {
    
    public func attributedText(style: Style) -> NSAttributedString {
        return NSAttributedString()
    }
    
}
