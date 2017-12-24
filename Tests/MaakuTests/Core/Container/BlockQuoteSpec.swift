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
            let text = """
> This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,
> consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
> Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.
>
> Donec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse
> id sem consectetuer libero luctus adipiscing.
"""
            
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
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("Nested BlockQuote") {
            let text = """
text
> quoted text
> > deeper layer
> > > even deeper layer
"""
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(2))
                }
                
                it("parses the blockquote") {
                    expect(document[1]).to(beAKindOf(BlockQuote.self))
                }
                
                let blockquote = document[1] as! BlockQuote
                
                it("parses the nested blockquote") {
                    expect(blockquote.items.count).to(equal(2))
                    expect(blockquote.items[1]).to(beAKindOf(BlockQuote.self))
                }
                
                let nestedBlockquote = blockquote.items[1] as! BlockQuote
                
                it("parses the next nested blockquote") {
                    expect(nestedBlockquote.items.count).to(equal(2))
                    expect(nestedBlockquote.items[1]).to(beAKindOf(BlockQuote.self))
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
