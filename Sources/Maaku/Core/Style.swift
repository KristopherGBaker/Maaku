//
//  Style.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

#if os(OSX)
    import AppKit
    public typealias Font  = NSFont
    public typealias Color = NSColor
#else
    import UIKit
    public typealias Font  = UIFont
    public typealias Color = UIColor
#endif

/// Represents the styles (fonts, colors) to apply to attributed strings created from markdown.
public struct Style: Equatable {

    public enum FontType {

        /// Current font
        case current

        /// H1 font
        // swiftlint:disable identifier_name
        case h1

        /// H2 font
        // swiftlint:disable identifier_name
        case h2

        /// H3 font
        // swiftlint:disable identifier_name
        case h3

        /// H4 font
        // swiftlint:disable identifier_name
        case h4

        /// H5 font
        // swiftlint:disable identifier_name
        case h5

        /// H6 font
        // swiftlint:disable identifier_name
        case h6

        /// Paragraph font
        case paragraph
    }

    public enum ColorType {

        /// Current foreground color
        case current

        /// H1 foreground color
        // swiftlint:disable identifier_name
        case h1

        /// H2 foreground color
        // swiftlint:disable identifier_name
        case h2

        /// H3 foreground color
        // swiftlint:disable identifier_name
        case h3

        /// H4 foreground color
        // swiftlint:disable identifier_name
        case h4

        /// H5 foreground color
        // swiftlint:disable identifier_name
        case h5

        /// H6 foreground color
        // swiftlint:disable identifier_name
        case h6

        /// Inline code foreground color
        case inlineCodeForeground

        /// Inline code background color
        case inlineCodeBackground

        /// Link foreground color
        case link

        /// Paragraph foreground color
        case paragraph
    }

    /// The fonts.
    private let fonts: [FontType: Font]

    /// The colors.
    private let colors: [ColorType: Color]

    /// Has strikethrough enabled.
    public let hasStrikethrough: Bool

    /// Initializes a Style with the default values.
    ///
    /// - Returns:
    ///     The initialized Style.
    public init() {
        var fonts = [FontType: Font]()
        #if os(OSX)
            fonts[.h1] = Font.systemFont(ofSize: 28, weight: .semibold)
            fonts[.h2] = Font.systemFont(ofSize: 22, weight: .semibold)
            fonts[.h3] = Font.systemFont(ofSize: 20, weight: .semibold)
            fonts[.h4] = Font.systemFont(ofSize: 17, weight: .semibold)
            fonts[.h5] = Font.systemFont(ofSize: 15, weight: .semibold)
            fonts[.h6] = Font.systemFont(ofSize: 13, weight: .semibold)
            fonts[.paragraph] = Font.systemFont(ofSize: 17, weight: .regular)
            fonts[.current] = Font.systemFont(ofSize: 17, weight: .regular)
        #else
            fonts[.h1] = Font.preferredFont(forTextStyle: .title1).maaku_bold()
            fonts[.h2] = Font.preferredFont(forTextStyle: .title2).maaku_bold()
            fonts[.h3] = Font.preferredFont(forTextStyle: .title3).maaku_bold()
            fonts[.h4] = Font.preferredFont(forTextStyle: .headline).maaku_bold()
            fonts[.h5] = Font.preferredFont(forTextStyle: .subheadline).maaku_bold()
            fonts[.h6] = Font.preferredFont(forTextStyle: .footnote).maaku_bold()
            fonts[.paragraph] = Font.preferredFont(forTextStyle: .body)
            fonts[.current] = Font.preferredFont(forTextStyle: .body)
        #endif
        self.fonts = fonts

        var colors = [ColorType: Color]()
        colors[.h1] = .black
        colors[.h2] = .black
        colors[.h3] = .black
        colors[.h4] = .black
        colors[.h5] = .black
        colors[.h6] = .black
        colors[.paragraph] = .black
        colors[.link] = .blue
        colors[.current] = .black
        colors[.inlineCodeBackground] = Color(white: 0.95, alpha: 1.0)
        colors[.inlineCodeForeground] = Color(red: 0.91, green: 0.11, blue: 0.25, alpha: 1.00)
        self.colors = colors

        hasStrikethrough = false
    }

    /// Initializes a Style with the specified values.
    ///
    /// - Parameters:
    ///     - fonts: The fonts.
    ///     - colors: The colors.
    ///     - hasStrikethrough: Has strikethrough enabled.
    /// - Returns:
    ///     The initialized Style.
    public init(fonts: [FontType: Font],
                colors: [ColorType: Color],
                hasStrikethrough: Bool) {
        self.fonts = fonts
        self.colors = colors
        self.hasStrikethrough = hasStrikethrough
    }

    /// Returns the font for the specified type.
    ///
    /// - Parameters:
    ///     - type: The font type.
    /// - Returns:
    ///     The font for the specified type.
    public func font(_ type: FontType) -> Font {
        guard let font = fonts[type] else {
            assertionFailure("font not found for type: \(type)")
            return Font.systemFont(ofSize: 17, weight: .regular)
        }

        return font
    }

    /// Returns the color for the specified type.
    ///
    /// - Parameters:
    ///     - type: The color type.
    /// - Returns:
    ///     The color for the specified type.
    public func color(_ type: ColorType) -> Color {
        guard let color = colors[type] else {
            assertionFailure("color not found for type: \(type)")
            return Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }

        return color
    }

}

/// Defines Style extension methods.
public extension Style {

    public static func == (lhs: Style, rhs: Style) -> Bool {
        return
            lhs.colors == rhs.colors &&
            lhs.fonts == rhs.fonts &&
            lhs.hasStrikethrough == rhs.hasStrikethrough
    }

    /// Returns an updated Style using the preferred fonts.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func preferredFonts() -> Style {
        var preferredFonts = fonts

        #if os(OSX)
            preferredFonts[.h1] = Font.systemFont(ofSize: 28, weight: .semibold)
            preferredFonts[.h2] = Font.systemFont(ofSize: 22, weight: .semibold)
            preferredFonts[.h3] = Font.systemFont(ofSize: 20, weight: .semibold)
            preferredFonts[.h4] = Font.systemFont(ofSize: 17, weight: .semibold)
            preferredFonts[.h5] = Font.systemFont(ofSize: 15, weight: .semibold)
            preferredFonts[.h6] = Font.systemFont(ofSize: 13, weight: .semibold)
            preferredFonts[.paragraph] = Font.systemFont(ofSize: 17, weight: .regular)
        #else
            preferredFonts[.h1] = Font.preferredFont(forTextStyle: .title1).maaku_bold()
            preferredFonts[.h2] = Font.preferredFont(forTextStyle: .title2).maaku_bold()
            preferredFonts[.h3] = Font.preferredFont(forTextStyle: .title3).maaku_bold()
            preferredFonts[.h4] = Font.preferredFont(forTextStyle: .headline).maaku_bold()
            preferredFonts[.h5] = Font.preferredFont(forTextStyle: .subheadline).maaku_bold()
            preferredFonts[.h6] = Font.preferredFont(forTextStyle: .footnote).maaku_bold()
            preferredFonts[.paragraph] = Font.preferredFont(forTextStyle: .body)
        #endif

        return Style(fonts: preferredFonts,
                     colors: colors,
                     hasStrikethrough: hasStrikethrough)
    }

    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - type: The font type.
    ///     - font: The font.
    /// - Returns:
    ///     - The updated Style.
    public func font(type: FontType, font: Font) -> Style {
        var updatedFonts = fonts
        updatedFonts[type] = font
        return Style(fonts: updatedFonts,
                     colors: colors,
                     hasStrikethrough: hasStrikethrough)
    }

    /// Returns an updated Style with specified heading.
    ///
    /// - Parameters:
    ///     - heading: The heading.
    /// - Returns:
    ///     - The updated Style.
    public func font(heading: Heading) -> Style {
        var updatedFonts = fonts
        updatedFonts[.current] = font(forHeading: heading)

        return Style(fonts: updatedFonts,
                     colors: colors,
                     hasStrikethrough: hasStrikethrough)
    }

    /// Returns an updated Style with specified color.
    ///
    /// - Parameters:
    ///     - type: The color type.
    ///     - color: The color.
    /// - Returns:
    ///     - The updated Style.
    public func color(type: ColorType, color: Color) -> Style {
        var updatedColors = colors
        updatedColors[type] = color

        return Style(fonts: fonts,
                     colors: updatedColors,
                     hasStrikethrough: hasStrikethrough)
    }

    /// Returns an updated Style with strikethrough enabled.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func enableStrikethrough() -> Style {
        return Style(fonts: fonts,
                     colors: colors,
                     hasStrikethrough: true)
    }

    /// Returns an updated Style with strikethrough disabled.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func disableStrikethrough() -> Style {
        return Style(fonts: fonts,
                     colors: colors,
                     hasStrikethrough: false)
    }

    /// Returns an updated Style with a bold/strong font.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func strong() -> Style {
        let currentFont = font(.current)
        var updatedFonts = fonts
        updatedFonts[.current] = currentFont.maaku_bold()

        return Style(fonts: updatedFonts,
                     colors: colors,
                     hasStrikethrough: hasStrikethrough)
    }

    /// Returns an updated Style with an italic/emphasis font.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func emphasis() -> Style {
        let currentFont = font(.current)
        var updatedFonts = fonts
        updatedFonts[.current] = currentFont.maaku_italic()

        return Style(fonts: updatedFonts,
                     colors: colors,
                     hasStrikethrough: hasStrikethrough)
    }

    /// Returns the font for the specified heading.
    ///
    /// - Parameters:
    ///     - heading: The heading.
    /// - Returns:
    ///     - The font for the heading.
    public func font(forHeading heading: Heading) -> Font {
        switch heading.level {
        case .h1:
            return font(.h1)
        case .h2:
            return font(.h2)
        case .h3:
            return font(.h3)
        case .h4:
            return font(.h4)
        case .h5:
            return font(.h5)
        case .h6:
            return font(.h6)
        case .unknown:
            return font(.paragraph)
        }
    }

}
