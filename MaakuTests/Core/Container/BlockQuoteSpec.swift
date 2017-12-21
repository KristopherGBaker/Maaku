//
//  BlockQuoteSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class BlockQuoteSpec: QuickSpec {
    
    override func spec() {
        
        describe("BlockQuote") {
            let md = loadExample("blockquote")
            
            guard let text = md else {
                XCTFail("example blockquote nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the blockquote") {
                    expect(document[0]).to(beAKindOf(BlockQuote.self))
                    let blockquote = document[0] as! BlockQuote
                    expect(blockquote.items.count).to(equal(2))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
