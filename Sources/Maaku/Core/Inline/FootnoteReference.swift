//
//  FootnoteReference.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown footnote reference.
public struct FootnoteReference: Inline {

    /// The reference.
    public let reference: String

    /// Creates a FootnoteReference with the specified reference.
    ///
    /// - Parameters:
    ///     - reference: The reference.
    /// - Returns:
    ///     The initialized FootnoteReference.
    public init(reference: String) {
        self.reference = reference
    }
}

public extension FootnoteReference {

    public func attributedText(style: Style) -> NSAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [
            .font: style.currentFont,
            .foregroundColor: style.currentForegroundColor
        ]
        let attributed = NSMutableAttributedString(string: reference, attributes: attributes)

        if let url = URL(string: "footnote://\(reference)") {
            let range = NSRange(location: 0, length: attributed.string.utf16.count)
            attributed.addAttribute(.link, value: url, range: range)
        }

        return attributed
    }

}
