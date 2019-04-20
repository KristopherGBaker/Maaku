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

/// Represents the font style.
public protocol FontStyle {

    /// Current font
    var current: Font { get set }

    /// H1 font
    // swiftlint:disable identifier_name
    var h1: Font { get set }

    /// H2 font
    // swiftlint:disable identifier_name
    var h2: Font { get set }

    /// H3 font
    // swiftlint:disable identifier_name
    var h3: Font { get set }

    /// H4 font
    // swiftlint:disable identifier_name
    var h4: Font { get set }

    /// H5 font
    // swiftlint:disable identifier_name
    var h5: Font { get set }

    /// H6 font
    // swiftlint:disable identifier_name
    var h6: Font { get set }

    /// Paragraph font
    var paragraph: Font { get set }
}

/// Represents the color style.
public protocol ColorStyle {

    /// Current foreground color
    var current: Color { get set }

    /// H1 foreground color
    // swiftlint:disable identifier_name
    var h1: Color { get set }

    /// H2 foreground color
    // swiftlint:disable identifier_name
    var h2: Color { get set }

    /// H3 foreground color
    // swiftlint:disable identifier_name
    var h3: Color { get set }

    /// H4 foreground color
    // swiftlint:disable identifier_name
    var h4: Color { get set }

    /// H5 foreground color
    // swiftlint:disable identifier_name
    var h5: Color { get set }

    /// H6 foreground color
    // swiftlint:disable identifier_name
    var h6: Color { get set }

    /// Inline code foreground color
    var inlineCodeForeground: Color { get set }

    /// Inline code background color
    var inlineCodeBackground: Color { get set }

    /// Link foreground color
    var link: Color { get set }

    /// Link underline color
    var linkUnderline: Color { get set }

    /// Paragraph foreground color
    var paragraph: Color { get set }
}

/// Represents the styles (fonts, colors) to apply to attributed strings created from markdown.
public protocol Style {

    /// The fonts.
    var fonts: FontStyle { get set }

    /// The colors.
    var colors: ColorStyle { get set }

    /// Has strikethrough enabled.
    var hasStrikethrough: Bool { get set }

    /// Soft line break separator.
    var softbreakSeparator: String { get set }

}

/// Represents the default font style.
public struct DefaultFontStyle: FontStyle {

    /// The current font.
    public var current: Font

    /// The h1 font.
    public var h1: Font

    /// The h2 font.
    public var h2: Font

    /// The h3 font.
    public var h3: Font

    /// The h4 font.
    public var h4: Font

    /// The h5 font.
    public var h5: Font

    /// The h6 font.
    public var h6: Font

    /// The paragraph font.
    public var paragraph: Font

    public init() {
        #if os(OSX)
        h1 = Font.systemFont(ofSize: 28, weight: .semibold)
        h2 = Font.systemFont(ofSize: 22, weight: .semibold)
        h3 = Font.systemFont(ofSize: 20, weight: .semibold)
        h4 = Font.systemFont(ofSize: 17, weight: .semibold)
        h5 = Font.systemFont(ofSize: 15, weight: .semibold)
        h6 = Font.systemFont(ofSize: 13, weight: .semibold)
        paragraph = Font.systemFont(ofSize: 17, weight: .regular)
        current = Font.systemFont(ofSize: 17, weight: .regular)
        #else
        h1 = Font.preferredFont(forTextStyle: .title1).maaku_bold()
        h2 = Font.preferredFont(forTextStyle: .title2).maaku_bold()
        h3 = Font.preferredFont(forTextStyle: .title3).maaku_bold()
        h4 = Font.preferredFont(forTextStyle: .headline).maaku_bold()
        h5 = Font.preferredFont(forTextStyle: .subheadline).maaku_bold()
        h6 = Font.preferredFont(forTextStyle: .footnote).maaku_bold()
        paragraph = Font.preferredFont(forTextStyle: .body)
        current = Font.preferredFont(forTextStyle: .body)
        #endif
    }
}

/// Represents the default color style.
public struct DefaultColorStyle: ColorStyle {

    /// The current color.
    public var current: Color

    /// The h1 color.
    public var h1: Color

    /// The h2 color.
    public var h2: Color

    /// The h3 color.
    public var h3: Color

    /// The h4 color.
    public var h4: Color

    /// The h5 color.
    public var h5: Color

    /// The h6 color.
    public var h6: Color

    /// The inline code foreground color.
    public var inlineCodeForeground: Color

    /// The inline code background color.
    public var inlineCodeBackground: Color

    /// The link color.
    public var link: Color

    /// The link underline color.
    public var linkUnderline: Color

    /// The paragraph color.
    public var paragraph: Color

    public init() {
        h1 = .black
        h2 = .black
        h3 = .black
        h4 = .black
        h5 = .black
        h6 = .black
        paragraph = .black
        link = .blue
        linkUnderline = .blue
        current = .black
        inlineCodeBackground = Color(white: 0.95, alpha: 1.0)
        inlineCodeForeground = Color(red: 0.91, green: 0.11, blue: 0.25, alpha: 1.00)
    }
}

/// Represents the default styles (fonts, colors) to apply to attributed strings created from markdown.
public struct DefaultStyle: Style {

    /// The colors.
    public var colors: ColorStyle

    /// The fonts.
    public var fonts: FontStyle

    /// Has strikethrough enabled.
    public var hasStrikethrough: Bool

    /// Soft line break separator.
    public var softbreakSeparator: String

    /// Initializes a Style with the default values.
    ///
    /// - Returns:
    ///     The initialized Style.
    public init() {
        colors = DefaultColorStyle()
        fonts = DefaultFontStyle()
        hasStrikethrough = false
        softbreakSeparator = " "
    }

    /// Initializes a Style with the specified values.
    ///
    /// - Parameters:
    ///     - colors: The colors.
    ///     - fonts: The fonts.
    ///     - hasStrikethrough: Has strikethrough enabled.
    /// - Returns:
    ///     The initialized Style.
    public init(colors: ColorStyle, fonts: FontStyle, hasStrikethrough: Bool) {
        self.colors = colors
        self.fonts = fonts
        self.hasStrikethrough = hasStrikethrough
        self.softbreakSeparator = " "
    }
}

/// Defines Style extension methods.
public extension Style {

    /// Updates the current font with a bold/strong font.
    mutating func strong() {
        let newFont = fonts.current.maaku_bold()
        fonts.current = newFont
    }

    /// Updates the current font with an italic/emphasis font.
    mutating func emphasis() {
        let newFont = fonts.current.maaku_italic()
        fonts.current = newFont
    }

    /// Returns the font for the specified heading.
    ///
    /// - Parameters:
    ///     - heading: The heading.
    /// - Returns:
    ///     - The font for the heading.
    func font(forHeading heading: Heading) -> Font {
        switch heading.level {
        case .h1:
            return fonts.h1
        case .h2:
            return fonts.h2
        case .h3:
            return fonts.h3
        case .h4:
            return fonts.h4
        case .h5:
            return fonts.h5
        case .h6:
            return fonts.h6
        case .unknown:
            return fonts.paragraph
        }
    }

    /// Returns the color for the specified heading.
    ///
    /// - Parameters:
    ///     - heading: The heading.
    /// - Returns:
    ///     - The color for the heading.
    func color(forHeading heading: Heading) -> Color {
        switch heading.level {
        case .h1:
            return colors.h1
        case .h2:
            return colors.h2
        case .h3:
            return colors.h3
        case .h4:
            return colors.h4
        case .h5:
            return colors.h5
        case .h6:
            return colors.h6
        case .unknown:
            return colors.paragraph
        }
    }

}
