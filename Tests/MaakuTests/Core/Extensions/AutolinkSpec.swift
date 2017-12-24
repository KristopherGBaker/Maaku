//
//  AutolinkSpec.swift
//  Maaku
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class AutolinkSpec: QuickSpec {
    
    override func spec() {
        
        describe("Autolink") {
            let text = "https://www.github.com/\n"
            
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
                    let text = link.text[0] as! Text
                    expect(text.text).to(equal("https://www.github.com/"))
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
