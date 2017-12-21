//
//  ParagraphSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class ParagraphSpec: QuickSpec {
    
    override func spec() {
        
        describe("Paragraph") {
            let md = loadExample("paragraph")
            
            guard let text = md else {
                XCTFail("example paragraph nil")
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
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
