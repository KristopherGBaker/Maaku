//
//  FootnoteReference.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdown footnote reference.
public struct FootnoteReference: Inline {
    
    /// The reference.
    public let reference: String
    
    /// Creates a FootnoteReference with the specified reference.
    ///
    /// - Parameters:
    ///     - reference: The reference.
    /// - Returns:
    ///     The initialized FootnoteReference.
    public init(reference: String) {
        self.reference = reference
    }
}

public extension FootnoteReference {
    
    public func attributedText(style: Style) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: reference, attributes: [.font: style.currentFont, .foregroundColor: style.currentForegroundColor])
        
        if let url = URL(string: "footnote://\(reference)") {
            attributed.addAttribute(.link, value: url, range: NSMakeRange(0, attributed.string.utf16.count))
        }
        
        return attributed
    }
    
}
