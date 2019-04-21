//
//  Image.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Foundation

/// Represents a markdown inline image.
public struct Image: Inline {

    /// The inline description.
    public let description: [Inline]

    /// The destination (source).
    public let destination: String?

    /// The title.
    public let title: String?

    /// The destination as a URL.
    public var url: URL? {
        guard let destination = destination else {
            return nil
        }

        return URL(string: destination)
    }

    /// Creates a Image with the specified values.
    ///
    /// - Parameters:
    ///     - description: The inline description.
    ///     - destination: The image destination.
    ///     - title: The image title.
    /// - Returns:
    ///     The initialized Image.
    public init(description: [Inline], destination: String?, title: String?) {
        self.description = description
        self.destination = destination
        self.title = title
    }

    /// Creates a Image with the specified values.
    ///
    /// - Parameters:
    ///     - destination: The image destination.
    ///     - title: The image title.
    /// - Returns:
    ///     The initialized Image.
    public init(destination: String?, title: String?) {
        self.description = []
        self.destination = destination
        self.title = title
    }

    /// Creates an updated Image with the specified inline description.
    ///
    /// - Parameters:
    ///     - description: The inline description.
    /// - Returns:
    ///     The updated Image.
    func with(description: [Inline]) -> Image {
        return Image(description: description, destination: destination, title: title)
    }

}

public extension Image {

    func attributedText(style: Style) -> NSAttributedString {
        // TODO: images are not supported yet
        // consider doing something with async NSTextAttachment
        // https://www.cocoanetics.com/2016/09/asynchronous-nstextattachments-22/

        let attributed = NSMutableAttributedString()

        for item in description {
            attributed.append(item.attributedText(style: style))
        }

        if attributed.string.count == 0 {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: style.fonts.current,
                .foregroundColor: style.colors.current
            ]
            attributed.append(NSAttributedString(string: "[image]", attributes: attributes))

            if let url = self.url {
                let range = NSRange(location: 0, length: attributed.string.utf16.count)
                attributed.addAttribute(.link, value: url, range: range)
            }
        }

        return attributed
    }

}
