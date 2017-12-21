//
//  TableSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class TableSpec: QuickSpec {
    
    override func spec() {
        
        describe("Table") {
            let md = loadExample("table")
            
            guard let text = md else {
                XCTFail("example table nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the table") {
                    expect(document[0]).to(beAKindOf(Table.self))
                }
                
                let table = document[0] as! Table
                
                it("parses the header") {
                    expect(table.header.cells.count).to(equal(2))
                }
                
                it("parses the rows") {
                    expect(table.rows.count).to(equal(2))
                }
                
                it("parses the first row") {
                    expect(table.rows[0].cells.count).to(equal(2))
                }
                
                it("parses the second row") {
                    expect(table.rows[1].cells.count).to(equal(2))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
