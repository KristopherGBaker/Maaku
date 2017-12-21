//
//  LineBreakSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class LineBreakSpec: QuickSpec {
    
    override func spec() {
        
        describe("LineBreak") {
            let md = loadExample("linebreak")
            
            guard let text = md else {
                XCTFail("example line break nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the line break") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(3))
                    expect(paragraph.items[1]).to(beAKindOf(LineBreak.self))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
