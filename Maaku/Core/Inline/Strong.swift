//
//  Strong.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown strong.
public struct Strong: Inline {
    
    /// The inline items.
    public let items: [Inline]
    
    /// Creates a Strong.
    ///
    /// - Returns:
    ///     The initialized Strong.
    public init() {
        items = []
    }
    
    /// Creates a Strong with the specified items.
    ///
    /// - Parameters:
    ///     - items: The inline items.
    /// - Returns:
    ///     The initialized Strong.
    public init(items: [Inline]) {
        self.items = items
    }

}

public extension Strong {
    
    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString()
        
        var strongFont = style.currentFont
        var traits = style.currentFont.fontDescriptor.symbolicTraits
        
        #if os(OSX)
            traits.insert(.bold)
            let descriptor = style.currentFont.fontDescriptor.withSymbolicTraits(traits)
            
            if let font = Font(descriptor: descriptor, size: 0.0) {
                strongFont = font
            }
        #else
            traits.insert(.traitBold)
            
            if let descriptor = style.currentFont.fontDescriptor.withSymbolicTraits(traits) {
                strongFont = UIFont(descriptor: descriptor, size: 0.0)
            }
        #endif
        
        for item in items {
            attributed.append(item.attributedText(style: style.font(current: strongFont)))
        }
        
        return attributed
    }
    
}
