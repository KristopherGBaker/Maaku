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
    
    public func attributedText(style: Style) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text, attributes: [.font: style.currentFont, .foregroundColor: style.currentForegroundColor])
        
        if style.hasStrikethrough {
            attributedText.addAttributes([.strikethroughColor: style.currentForegroundColor, .strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)], range: NSMakeRange(0, attributedText.string.utf16.count))
        }
        
        return attributedText
    }
    
}
