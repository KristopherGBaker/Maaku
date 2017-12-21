//
//  Emphasis.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown emphasis.
public struct Emphasis: Inline {
    
    /// The inline items.
    public let items: [Inline]
    
    /// Creates a Emphasis.
    ///
    /// - Returns:
    ///     The initialized Emphasis.
    public init() {
        items = []
    }
    
    /// Creates a Emphasis with the specified items.
    ///
    /// - Parameters:
    ///     - items: The inline items.
    /// - Returns:
    ///     The initialized Emphasis.
    public init(items: [Inline]) {
        self.items = items
    }
}

public extension Emphasis {
    
    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()
        
        var emphasisFont = style.currentFont
        var traits = style.currentFont.fontDescriptor.symbolicTraits
        
        #if os(OSX)
            traits.insert(.italic)
            let descriptor = style.currentFont.fontDescriptor.withSymbolicTraits(traits)
            
            if let font = Font(descriptor: descriptor, size: 0.0) {
                emphasisFont = font
            }
        #else
            traits.insert(.traitItalic)
            
            if let descriptor = style.currentFont.fontDescriptor.withSymbolicTraits(traits) {
                emphasisFont = UIFont(descriptor: descriptor, size: 0.0)
            }
        #endif
        
        for item in items {
            attributed.append(item.attributedText(style: style.font(current: emphasisFont)))
        }
        
        return attributed
    }
    
}
