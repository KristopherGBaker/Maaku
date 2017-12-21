//
//  CodeBlockSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class CodeBlockSpec: QuickSpec {
    
    override func spec() {
        
        describe("CodeBlock") {
            let md = loadExample("codeblock")
            
            guard let text = md else {
                XCTFail("example code block nil")
                return
            }
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the code block") {
                    expect(document[0]).to(beAKindOf(CodeBlock.self))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
