//
//  DocumentSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class DocumentSpec: QuickSpec {

    override func spec() {
        
        describe("init(text: String)") {
            let md = loadExample("document")
            
            guard let text = md else {
                XCTFail("example document nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                    
                it("initializes the document") {
                    expect(document.count).to(equal(2))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
        
        describe("init(data: Data)") {
            let md = loadExampleData("document")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            do {
                let document = try Document(data: data)
                
                it("initializes the document") {
                    expect(document.count).to(equal(2))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
