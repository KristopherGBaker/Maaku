//
//  OrderedListSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class OrderedListSpec: QuickSpec {
    
    override func spec() {
        
        describe("OrderedList") {
            let text = """
1.  Swift
2.  Objective-C
3.  C
"""
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the ordered list") {
                    expect(document[0]).to(beAKindOf(OrderedList.self))
                    let list = document[0] as! OrderedList
                    expect(list.items.count).to(equal(3))
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
