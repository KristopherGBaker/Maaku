//
//  Text.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// Represents markdown text.
public struct Text: Inline {

    /// The text.
    public let text: String

    /// Creates a Text with the specified text.
    ///
    /// - Parameters:
    ///     - text: The text.
    /// - Returns:
    ///     The initialized Text.
    public init(text: String) {
        self.text = text
    }

}

public extension Text {

    func attributedText(style: Style) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: style.fonts.current,
            .foregroundColor: style.colors.current
        ]

        if style.hasStrikethrough {
            attributes[.strikethroughColor] = style.colors.current
            attributes[.strikethroughStyle] = NSNumber(value: NSUnderlineStyle.single.rawValue as Int)
        }

        return NSAttributedString(string: text, attributes: attributes)
    }

}
