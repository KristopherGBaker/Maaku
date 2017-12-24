//
//  Style.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

#if os(OSX)
    public typealias Font  = NSFont
    public typealias Color = NSColor
#else
    public typealias Font  = UIFont
    public typealias Color = UIColor
#endif

/// Represents the styles (fonts, colors) to apply to attributed strings created from markdown.
public struct Style {
    
    /// Has strikethrough enabled.
    public let hasStrikethrough: Bool
    
    /// The current font.
    public let currentFont: Font
    
    /// The H1 font.
    public let h1Font: Font
    
    /// The H2 font.
    public let h2Font: Font
    
    /// The H3 font.
    public let h3Font: Font
    
    /// The H4 font.
    public let h4Font: Font
    
    /// The H5 font.
    public let h5Font: Font
    
    /// The H6 font.
    public let h6Font: Font
    
    /// The paragraph font.
    public let paragraphFont: Font
    
    /// The current foreground color.
    public let currentForegroundColor: Color
    
    /// The H1 foreground color.
    public let h1ForegroundColor: Color
    
    /// The H2 foreground color.
    public let h2ForegroundColor: Color
    
    /// The H3 foreground color.
    public let h3ForegroundColor: Color
    
    /// The H4 foreground color.
    public let h4ForegroundColor: Color
    
    /// The H5 foreground color.
    public let h5ForegroundColor: Color
    
    /// The H6 foreground color.
    public let h6ForegroundColor: Color
    
    /// The paragraph foreground color.
    public let paragraphForegroundColor: Color
    
    /// The link foreground color.
    public let linkForegroundColor: Color
    
    /// Initializes a Style with the default values.
    ///
    /// - Returns:
    ///     The initialized Style.
    public init() {
        #if os(OSX)
            h1Font = Font.systemFont(ofSize: 28, weight: .semibold)
            h2Font = Font.systemFont(ofSize: 22, weight: .semibold)
            h3Font = Font.systemFont(ofSize: 20, weight: .semibold)
            h4Font = Font.systemFont(ofSize: 17, weight: .semibold)
            h5Font = Font.systemFont(ofSize: 15, weight: .semibold)
            h6Font = Font.systemFont(ofSize: 13, weight: .semibold)
            paragraphFont = Font.systemFont(ofSize: 17, weight: .regular)
        #else
        h1Font = Font.preferredFont(forTextStyle: .title1)
        h2Font = Font.preferredFont(forTextStyle: .title2)
        h3Font = Font.preferredFont(forTextStyle: .title3)
        h4Font = Font.preferredFont(forTextStyle: .headline)
        h5Font = Font.preferredFont(forTextStyle: .subheadline)
        h6Font = Font.preferredFont(forTextStyle: .footnote)
        paragraphFont = Font.preferredFont(forTextStyle: .body)
        #endif
        currentFont = paragraphFont
        
        h1ForegroundColor = .black
        h2ForegroundColor = .black
        h3ForegroundColor = .black
        h4ForegroundColor = .black
        h5ForegroundColor = .black
        h6ForegroundColor = .black
        paragraphForegroundColor = .black
        linkForegroundColor = .blue
        currentForegroundColor = paragraphForegroundColor
        hasStrikethrough = false
    }
    
    /// Initializes a Style with the specified values.
    ///
    /// - Parameters:
    ///     - currentFont: The current font.
    ///     - h1Font: The h1 font.
    ///     - h2Font: The h2 font.
    ///     - h3Font: The h3 font.
    ///     - h4Font: The h4 font.
    ///     - h5Font: The h5 font.
    ///     - h6Font: The h6 font.
    ///     - paragraphFont: The paragraph font.
    ///     - currentForegroundColor: The current foreground color.
    ///     - h1ForegroundColor: The h1 foreground color.
    ///     - h2ForegroundColor: The h2 foreground color.
    ///     - h3ForegroundColor: The h3 foreground color.
    ///     - h4ForegroundColor: The h4 foreground color.
    ///     - h5ForegroundColor: The h5 foreground color.
    ///     - h6ForegroundColor: The h6 foreground color.
    ///     - paragraphForegroundColor: The paragraph foreground color.
    ///     - linkForegroundColor: The link foreground color.
    /// - Returns:
    ///     The initialized Style.
    public init(currentFont: Font, h1Font: Font, h2Font: Font, h3Font: Font, h4Font: Font, h5Font: Font, h6Font: Font, paragraphFont: Font, currentForegroundColor: Color, h1ForegroundColor: Color, h2ForegroundColor: Color, h3ForegroundColor: Color, h4ForegroundColor: Color, h5ForegroundColor: Color, h6ForegroundColor: Color, paragraphForegroundColor: Color, linkForegroundColor: Color, hasStrikethrough: Bool) {
        self.currentFont = currentFont
        self.h1Font = h1Font
        self.h2Font = h2Font
        self.h3Font = h3Font
        self.h4Font = h4Font
        self.h5Font = h5Font
        self.h6Font = h6Font
        self.paragraphFont = paragraphFont
        self.h1ForegroundColor = h1ForegroundColor
        self.h2ForegroundColor = h2ForegroundColor
        self.h3ForegroundColor = h3ForegroundColor
        self.h4ForegroundColor = h4ForegroundColor
        self.h5ForegroundColor = h5ForegroundColor
        self.h6ForegroundColor = h6ForegroundColor
        self.paragraphForegroundColor = paragraphForegroundColor
        self.linkForegroundColor = linkForegroundColor
        self.currentForegroundColor = currentForegroundColor
        self.hasStrikethrough = hasStrikethrough
    }
    
}

/// Defines Style extension methods.
public extension Style {
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - current: The current font.
    /// - Returns:
    ///     - The updated Style.
    public func font(current currentFont: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - h1: The h1 font.
    /// - Returns:
    ///     - The updated Style.
    public func font(h1 h1Font: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - h2: The h2 font.
    /// - Returns:
    ///     - The updated Style.
    public func font(h2 h2Font: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - h3: The h3 font.
    /// - Returns:
    ///     - The updated Style.
    public func font(h3 h3Font: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - h4: The h4 font.
    /// - Returns:
    ///     - The updated Style.
    public func font(h4 h4Font: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - h5: The h5 font.
    /// - Returns:
    ///     - The updated Style.
    public func font(h5 h5Font: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - h6: The h6 font.
    /// - Returns:
    ///     - The updated Style.
    public func font(h6 h6Font: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified heading.
    ///
    /// - Parameters:
    ///     - heading: The heading.
    /// - Returns:
    ///     - The updated Style.
    public func font(heading: Heading) -> Style {
        return Style(currentFont: font(forHeading: heading), h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified font.
    ///
    /// - Parameters:
    ///     - paragraph: The paragraph font.
    /// - Returns:
    ///     - The updated Style.
    public func font(paragraph paragraphFont: Font) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - current: The current foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(current currentForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - h1: The h1 foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(h1 h1ForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - h2: The h2 foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(h2 h2ForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - h3: The h3 foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(h3 h3ForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - h4: The h4 foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(h4 h4ForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - h5: The h5 foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(h5 h5ForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - h6: The h6 foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(h6 h6ForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - paragraph: The paragraph foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(paragraph paragraphForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with specified foreground color.
    ///
    /// - Parameters:
    ///     - link: The link foreground color.
    /// - Returns:
    ///     - The updated Style.
    public func color(link linkForegroundColor: Color) -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: hasStrikethrough)
    }
    
    /// Returns an updated Style with strikethrough enabled.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func enableStrikethrough() -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: true)
    }
    
    /// Returns an updated Style with strikethrough disabled.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func disableStrikethrough() -> Style {
        return Style(currentFont: currentFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: false)
    }
    
    /// Returns an updated Style with a bold/strong font.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func strong() -> Style {
        var strongFont = currentFont
        var traits = currentFont.fontDescriptor.symbolicTraits
        
        #if os(OSX)
            traits.insert(.bold)
            let descriptor = currentFont.fontDescriptor.withSymbolicTraits(traits)
            
            if let font = Font(descriptor: descriptor, size: 0.0) {
                strongFont = font
            }
        #else
            traits.insert(.traitBold)
            
            if let descriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                strongFont = UIFont(descriptor: descriptor, size: 0.0)
            }
        #endif
        
        return Style(currentFont: strongFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: false)
    }
    
    /// Returns an updated Style with an italic/emphasis font.
    ///
    /// - Returns:
    ///     - The updated Style.
    public func emphasis() -> Style {
        var emphasisFont = currentFont
        var traits = currentFont.fontDescriptor.symbolicTraits
        
        #if os(OSX)
            traits.insert(.italic)
            let descriptor = currentFont.fontDescriptor.withSymbolicTraits(traits)
            
            if let font = Font(descriptor: descriptor, size: 0.0) {
                emphasisFont = font
            }
        #else
            traits.insert(.traitItalic)
            
            if let descriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                emphasisFont = UIFont(descriptor: descriptor, size: 0.0)
            }
        #endif
        
        return Style(currentFont: emphasisFont, h1Font: h1Font, h2Font: h2Font, h3Font: h3Font, h4Font: h4Font, h5Font: h5Font, h6Font: h6Font, paragraphFont: paragraphFont, currentForegroundColor: currentForegroundColor, h1ForegroundColor: h1ForegroundColor, h2ForegroundColor: h2ForegroundColor, h3ForegroundColor: h3ForegroundColor, h4ForegroundColor: h4ForegroundColor, h5ForegroundColor: h5ForegroundColor, h6ForegroundColor: h6ForegroundColor, paragraphForegroundColor: paragraphForegroundColor, linkForegroundColor: linkForegroundColor, hasStrikethrough: false)
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
            return h1Font
        case .h2:
            return h2Font
        case .h3:
            return h3Font
        case .h4:
            return h4Font
        case .h5:
            return h5Font
        case .h6:
            return h6Font
        case .unknown:
            return paragraphFont
        }
    }
    
}
