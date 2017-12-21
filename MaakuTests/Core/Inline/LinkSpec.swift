//
//  LinkSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class LinkSpec: QuickSpec {
    
    override func spec() {
        
        describe("Link") {
            let md = loadExample("link")
            
            guard let text = md else {
                XCTFail("example link nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the link") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(1))
                    expect(paragraph.items[0]).to(beAKindOf(Link.self))
                    let link = paragraph.items[0] as! Link
                    expect(link.destination).to(equal("https://www.github.com/"))
                    expect(link.text[0]).to(beAKindOf(Text.self))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
