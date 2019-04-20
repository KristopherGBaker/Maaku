//
//  Plugin.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

public typealias PluginName = String

/// Represents a markdown plugin.
public protocol Plugin: LeafBlock {

    /// The plugin name.
    static var pluginName: PluginName { get }

}

/// Defines Plugin extension methods.
public extension Plugin {

    func attributedText(style: Style) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.fonts.current,
            .foregroundColor: style.colors.current
        ]
        return NSAttributedString(string: "", attributes: attributes)
    }

}

/// Represents a markdown plugin parser.
public protocol PluginParser {

    /// The unique name for the parser.
    var name: String { get }

    /// Parses the given text and returns a markdown plugin.
    ///
    /// - Parameters:
    ///     - text: The text to parse.
    ///
    /// - Returns:
    ///     - The plugin if parsing succeeded, nil otherwise.
    func parse(text: String) -> Plugin?

}

/// Encapsulates management of markdown plugins.
public struct PluginManager {

    /// The registered parsers.
    private static var parsers = [String: PluginParser]()

    /// Registers the specified parsers.
    ///
    /// - Parameters:
    ///     - parsers: The markdown plugin parsers.
    public static func registerParsers(_ parsers: [PluginParser]) {
        for parser in parsers {
            self.parsers[parser.name] = parser
        }
    }

    /// Parses the block link and returns the matching markdown plugin.
    ///
    /// - Parameters:
    ///     - name: The link name.
    ///     - contents: The link contents.
    ///
    /// - Returns:
    ///     The plugin matching the inputs if one could be created, nil otherwise.
    static func parseBlockLink(name: String, contents: String) -> Plugin? {
        guard let parser = parsers[name], let plugin = parser.parse(text: contents) else {
            return nil
        }

        return plugin
    }
}

/// Extension methods for PluginParser.
public extension PluginParser {

    /// Splits the specified text into a dictionary of plugin parameters.
    ///
    /// - Parameters:
    ///     - text: The text to split.
    ///
    /// - Returns:
    ///     The dictionary of plugin parameters.
    func splitPluginParams(_ text: String) -> [String: String] {
        let components = text.trimmingCharacters(in: .whitespaces).components(separatedBy: "|")
        var params = [String: String]()

        for component in components {
            let segments = component.components(separatedBy: "::")

            if segments.count == 2 {
                let key = segments[0].trimmingCharacters(in: .whitespaces)
                let value = segments[1].trimmingCharacters(in: .whitespaces)

                params[key] = value
            }
        }

        return params
    }

    /// Parses an URL from the given text using the specified parameter name.
    ///
    /// - Parameters:
    ///     - text: The text.
    ///     - parameterName: The parameter name, defaults to "source".
    ///
    /// - Returns:
    ///     The URL if it could be parsed, nil otherwise.
    func parseURL(_ text: String, parameterName: String = "source") -> URL? {
        let parameters = splitPluginParams(text)

        guard parameters.count > 0 else {
            return URL(string: text)
        }

        if let href = parameters[parameterName] {
            return URL(string: href)
        }

        return nil
    }
}
