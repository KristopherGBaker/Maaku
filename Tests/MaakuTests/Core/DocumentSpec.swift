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
        let text = """
# Maaku
The Maaku framework provides a Swift wrapper around cmark with the addition of a Swift friendly representation of the AST
"""
        let data = text.data(using: .utf8)!
        
        
        describe("init(text: String)") {
            do {
                let document = try Document(text: text)
                    
                it("initializes the document") {
                    expect(document.count).to(equal(2))
                }
            }
            catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("init(data: Data)") {
            do {
                let document = try Document(data: data)
                
                it("initializes the document") {
                    expect(document.count).to(equal(2))
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
