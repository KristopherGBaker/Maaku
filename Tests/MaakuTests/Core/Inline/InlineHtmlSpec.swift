//
//  InlineHtmlSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class InlineHtmlSpec: QuickSpec {
    
    override func spec() {
        
        describe("InlineHtml") {
            let text = "<del>*foo*</del>"
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the inline html") {
                    // TODO: update DocumentConverter to properly deal with inline HTML, and update this test accordingly
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(3))
                    expect(paragraph.items[0]).to(beAKindOf(InlineHtml.self))
                    expect(paragraph.items[1]).to(beAKindOf(Emphasis.self))
                    expect(paragraph.items[2]).to(beAKindOf(InlineHtml.self))
                }
            }
            catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }
    
}
