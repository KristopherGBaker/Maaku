//
//  Table.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown row / header.
public protocol TableLine: Node {

    var cells: [TableCell] { get }

    init()

    init(cells: [TableCell])

}

/// Represents a table alignment.
public enum TableAlignment: String {

    /// Center alignment.
    case center = "c"

    /// Left alignment.
    case left = "l"

    /// No alignment.
    case none = ""

    /// Right alignment.
    case right = "r"

    /// Creates a TableAlignment matching the raw value.
    ///
    /// - Parameters:
    ///     - rawValue: The raw alignment value.
    /// - Returns:
    ///     - The table alignment matching the raw value,
    ///       TableAlignment.none if there is no match.
    public init(rawValue: String) {
        switch rawValue {
        case TableAlignment.center.rawValue:
            self = .center
        case TableAlignment.left.rawValue:
            self = .left
        case TableAlignment.right.rawValue:
            self = .right
        default:
            self = .none
        }
    }
}

/// Represents a markdown table.
public struct Table: LeafBlock {

    /// The table header.
    public let header: TableHeader

    /// The table rows.
    public let rows: [TableRow]

    /// The number of columns.
    public let columns: Int

    /// The table alignments.
    public let alignments: [TableAlignment]

    /// Creates a Table.
    ///
    /// - Returns:
    ///     The initialized Table.
    public init() {
        self.init(header: TableHeader(), rows: [], columns: 0, alignments: [])
    }

    /// Creates a Paragraph with the specified values.
    ///
    /// - Parameters:
    ///     - columns: The number of columns in the table.
    ///     - alignments: The table alignments.
    /// - Returns:
    ///     The initialized Table.
    public init(columns: Int, alignments: [String]) {
        self.init(header: TableHeader(), rows: [], columns: columns, alignments: alignments)
    }

    /// Creates a Paragraph with the specified values.
    ///
    /// - Parameters:
    ///     - header: The table header.
    ///     - rows: The table rows.
    ///     - columns: The number of columns in the table.
    ///     - alignments: The table alignments.
    /// - Returns:
    ///     The initialized Table.
    public init(header: TableHeader, rows: [TableRow], columns: Int, alignments: [String]) {
        self.header = header
        self.rows = rows
        self.columns = columns
        self.alignments = alignments.map { TableAlignment(rawValue: $0) }
    }
}

public extension Table {

    func attributedText(style: Style) -> NSAttributedString {
        return NSAttributedString()
    }

}
