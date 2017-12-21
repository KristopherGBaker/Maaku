//
//  InlineCode.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents markdown inline code.
public struct InlineCode: Inline {
    
    /// The code.
    public let code: String
    
    /// Creates an InlineCode with the specified code.
    ///
    /// - Parameters:
    ///     - code: The code.
    /// - Returns:
    ///     The initialized InlineCode.
    public init(code: String) {
        self.code = code
    }
}

public extension InlineCode {
    
    public func attributedText(style: Style) -> NSAttributedString {
        return NSAttributedString(string: code, attributes: [.font: style.currentFont, .foregroundColor: style.currentForegroundColor])
    }
    
}
