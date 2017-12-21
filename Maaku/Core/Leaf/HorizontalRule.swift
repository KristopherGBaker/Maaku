//
//  HorizontalRule.swift
//  Maaku
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

/// Represents a markdonw horizontal rule (thematic break).
public struct HorizontalRule: LeafBlock {
    
}

public extension HorizontalRule {
    
    public func attributedText(style: Style) -> NSAttributedString {
        return NSAttributedString(string: "-----\n", attributes: [.font: style.currentFont, .foregroundColor: style.currentForegroundColor, .strikethroughColor: style.currentForegroundColor, .strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)])
    }
    
}
