//
//  Text.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

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
    
    public func attributedText(style: Style) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: style.currentFont, .foregroundColor: style.currentForegroundColor])
    }
    
}
