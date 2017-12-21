//
//  StrikethroughSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class StrikethroughSpec: QuickSpec {
    
    override func spec() {
        
        describe("Strikethrough") {
            let md = loadExample("strikethrough")
            
            guard let text = md else {
                XCTFail("example strikethrough nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the paragraph") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                }
                
                let paragraph = document[0] as! Paragraph
                
                it("parses the strikethrough") {
                    expect(paragraph.items[0]).to(beAKindOf(Strikethrough.self))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
