//
//  FootnoteReferenceSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class FootnoteReferenceSpec: QuickSpec {
    
    override func spec() {
        
        describe("FootnoteReference") {
            let md = loadExample("footnotedefinition")
            
            guard let text = md else {
                XCTFail("example footnote reference nil")
                return
            }
            
            do {
                let document = try Document(text: text, options: [.footnotes])
                
                it("initializes the document") {
                    expect(document.count).to(equal(2))
                }
                
                it("parses the footnote reference") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(3))
                    expect(paragraph.items[1]).to(beAKindOf(FootnoteReference.self))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
