//
//  CodeBlock.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown code block.
public struct CodeBlock: LeafBlock {

    /// The code.
    public let code: String

    /// The info (language).
    public let info: String?

    /// Creates a CodeBlock with the specified code and info.
    ///
    /// - Parameters:
    ///     - code: The code.
    ///     - info: The info.
    /// - Returns:
    ///     The initialized CodeBlock.
    public init(code: String, info: String?) {
        self.code = code
        self.info = info
    }
}

public extension CodeBlock {

    func attributedText(style: Style) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.fonts.current,
            .foregroundColor: style.colors.current
        ]
        return NSAttributedString(string: code, attributes: attributes)
    }

}
