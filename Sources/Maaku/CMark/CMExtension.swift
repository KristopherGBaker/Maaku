//
//  CMExtension.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a cmark extension option.
public struct CMExtensionOption: OptionSet {
    
    /// The raw value.
    public let rawValue: Int32
    
    /// Creates an extension option with the specified value.
    ///
    /// - Parameters:
    ///     - rawValue: The raw value.
    /// - Returns:
    ///     The extension option with the specified raw value.
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    /// No extensions
    public static let none = CMExtensionOption(rawValue: 0)
    
    /// All extensions
    public static let all: CMExtensionOption = [.tables, .autolinks, .strikethrough, .tagfilters]
    
    /// Tables
    public static let tables = CMExtensionOption(rawValue: 1)
    
    /// Auto links
    public static let autolinks = CMExtensionOption(rawValue: 2)
    
    /// Strikethrough
    public static let strikethrough = CMExtensionOption(rawValue: 4)
    
    /// Tag filters
    public static let tagfilters = CMExtensionOption(rawValue: 8)
    
}
