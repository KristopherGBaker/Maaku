//
//  CMExtension.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation
import libcmark_gfm

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

    /// Get the extension name associated with this option
    ///
    /// - Returns:
    ///    The name of the extension associated with this option (if there is only one),
    ///    or nil if there is either no extension associated with this option, or if there
    ///    are multiple extensions associated with this OptionSet.
    public var extensionName: String? {
        switch self {
        case .tables: return "table"
        case .autolinks: return "autolink"
        case .strikethrough: return "strikethrough"
        case .tagfilters: return "tagfilter"
        default: return nil
        }
    }

    /// Get an option that corresponds to the given extension name
    ///
    /// - Parameters:
    ///    - forExtensionName: the extension name for which we want to find the associated option
    ///
    /// - Returns:
    ///    The option associated with the extension name if any, or nil if the extension isn't supported.
    public static func option(forExtensionName name: String) -> CMExtensionOption? {
        switch name {
        case "table": return tables
        case "autolink": return autolinks
        case "strikethrough": return strikethrough
        case "tagfilter": return tagfilters
        default: return none
        }
    }

    /// Return the underlying syntax extension object associated with the given extension
    ///
    /// - Returns:
    ///    The underlying (internal) syntax extension object associated with the given extension or
    ///    nil if none is found.
    ///
    /// XXX Note that this is currently not exposed to the users of the library, as it really deals
    /// with internal structures and probably isn't of much use to them. The users of the library can always
    /// get this info themselves if they really want it.
    var syntaxExtension: UnsafeMutablePointer<cmark_syntax_extension>? {
        guard let name = extensionName else {
            // If we couldn't get the extension name, then we can't get the extension
            return nil
        }

        if name.isEmpty {
            // If the name is empty, then it isn't an extension name.
            return nil
        } else {
            return cmark_find_syntax_extension(name)
       }
    }
}
