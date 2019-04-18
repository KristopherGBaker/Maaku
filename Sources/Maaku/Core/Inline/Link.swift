//
//  Link.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown link.
public struct Link: Inline {

    /// Used for matching links that don't strictly conform to common mark syntax.
    private static let regex = try? NSRegularExpression(pattern: "^\\[\\w+\\]\\(.+\\)$", options: [])

    /// The inline text.
    public let text: [Inline]

    /// The link destination.
    public let destination: String?

    /// The link title.
    public let title: String?

    /// Returns the destination as a URL.
    public var url: URL? {
        guard let destination = destination else {
            return nil
        }

        return URL(string: destination)
    }

    /// Creates a Link with the specified values.
    ///
    /// - Parameters:
    ///     - text: The inline text.
    ///     - destination: The link destination.
    ///     - title: The link title.
    /// - Returns:
    ///     The initialized Link.
    public init(text: [Inline], destination: String?, title: String?) {
        self.text = text
        self.destination = destination
        self.title = title
    }

    /// Creates a Link with the specified values.
    ///
    /// - Parameters:
    ///     - destination: The link destination.
    ///     - title: The link title.
    /// - Returns:
    ///     The initialized Link.
    public init(destination: String?, title: String?) {
        self.init(text: [], destination: destination, title: title)
    }

    /// Creates a Link with the specified Text.
    ///
    /// - Parameters:
    ///     - text: The Text.
    /// - Returns:
    ///     The initialized Link if a matching link was found, nil otherwise.
    public init?(text: Text) {
        guard let regex = Link.regex else {
            return nil
        }

        title = nil

        let range = NSRange(location: 0, length: text.text.utf16.count)
        let matches = regex.matches(in: text.text, options: [], range: range)

        if matches.count > 0 {
            let parts = text.text.components(separatedBy: "](")

            if parts.count == 2 {
                var linkName = parts[0]
                linkName.removeFirst()
                var dest = parts[1]
                dest.removeLast()

                self.text = [Text(text: linkName)]
                destination = dest
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    /// Creates an updated Link with the specified inline text.
    ///
    /// - Parameters:
    ///     - text: The inline text.
    /// - Returns:
    ///     The updated Link.
    func with(text: [Inline]) -> Link {
        return Link(text: text, destination: destination, title: title)
    }

}

public extension Link {

    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()

        for item in text {
            attributed.append(item.attributedText(style: style))
        }

        if let url = self.url {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: style.fonts.current,
                .foregroundColor: style.colors.link,
                .link: url,
                .underlineColor: style.colors.linkUnderline
            ]
            attributed.addAttributes(attributes, range: NSRange(location: 0, length: attributed.string.utf16.count))
        }

        return attributed
    }

}
