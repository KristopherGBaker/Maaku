//
//  UnorderedListSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class UnorderedListSpec: QuickSpec {
    
    override func spec() {
        
        describe("UnorderedList") {
            let md = loadExample("unorderedlist")
            
            guard let text = md else {
                XCTFail("example unordered list nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the unordered list") {
                    expect(document[0]).to(beAKindOf(UnorderedList.self))
                    let list = document[0] as! UnorderedList
                    expect(list.items.count).to(equal(3))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
