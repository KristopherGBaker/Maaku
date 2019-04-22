//
//  Font+Maaku.swift
//  Maaku
//
//  Created by Kris Baker on 12/30/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

#if os(OSX)
    import AppKit
    public typealias FontDescriptorSymbolicTraits = NSFontDescriptor.SymbolicTraits
#else
    import UIKit
    public typealias FontDescriptorSymbolicTraits = UIFontDescriptor.SymbolicTraits
#endif

/// Font extensions.
public extension Font {

    /// Returns the font with the specified trait set.
    ///
    /// - Parameters:
    ///     - trait: The trait to use with the current font.
    /// - Returns:
    ///     The font with the specified trait set.
    func maaku_with(trait: FontDescriptorSymbolicTraits) -> Font {
        var font = self
        var traits = self.fontDescriptor.symbolicTraits
        traits.insert(trait)

        #if os(OSX)
            traits.insert(.bold)
            let descriptor = self.fontDescriptor.withSymbolicTraits(traits)

            if let boldFont = Font(descriptor: descriptor, size: 0.0) {
                font = boldFont
            }
        #else
            if let descriptor = self.fontDescriptor.withSymbolicTraits(traits) {
                font = UIFont(descriptor: descriptor, size: 0.0)
            }
        #endif

        return font
    }

    /// Returns the font with the bold trait set.
    ///
    /// - Returns:
    ///     The font with the bold trait set.
    func maaku_bold() -> Font {
        #if os(OSX)
            return maaku_with(trait: .bold)
        #else
            return maaku_with(trait: .traitBold)
        #endif
    }

    /// Returns the font with the italic trait set.
    ///
    /// - Returns:
    ///     The font with the italic trait set.
    func maaku_italic() -> Font {
        #if os(OSX)
            return maaku_with(trait: .italic)
        #else
            return maaku_with(trait: .traitItalic)
        #endif
    }

}
