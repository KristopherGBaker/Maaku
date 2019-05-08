//
//  TasklistItem.swift
//  Maaku
//
//  Created by Tim Learmont on 4/25/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown tasklist item.
public struct TasklistItem: Item {
    /// The block items.
    public let items: [Block]

    /// Whether the task is completed or not
    public let completed: Bool

    /// Creates a Tasklist
    ///
    /// - Returns:
    ///     The initialized Tasklist.
    public init(isCompleted: Bool) {
        completed = isCompleted
        items = []
    }

    /// Creates a Tasklist with the specified items.
    ///
    /// - Parameters:
    ///     - isCompleted: whether or not the task is completed.
    ///     - items: The block items.
    /// - Returns:
    ///     The initialized TaskList.
    public init(isCompleted: Bool, items: [Block]) {
        completed = isCompleted
        self.items = items
    }
}

public extension TasklistItem {
    static let checkedString = "[x] "
    static let uncheckedString = "[ ] "

    func attributedText(style: Style) -> NSAttributedString {
        return attributedText(style: style, includeMarker: true)
    }

    func attributedText(style: Style, includeMarker: Bool) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        if includeMarker {
            // Adjust the attributes to the given style
            let attributes: [NSAttributedString.Key: Any] = [
                .font: style.fonts.current,
                .foregroundColor: style.colors.current
            ]

            if completed {
                attributed.append(NSAttributedString(string: TasklistItem.checkedString, attributes: attributes))
            } else {
                attributed.append(NSAttributedString(string: TasklistItem.uncheckedString, attributes: attributes))
            }
        }

        // Mark completed items with a strikethrough.
        var newStyle = style
        if completed {
            newStyle.hasStrikethrough = true
        }
        for item in items {
            attributed.append(item.attributedText(style: newStyle))
        }

        return attributed
    }

}
