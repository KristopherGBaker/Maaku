//
//  HeadingSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class HeadingSpec: QuickSpec {
    
    override func spec() {
        
        describe("Heading") {
            let text = "# Maaku"
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the heading") {
                    expect(document[0]).to(beAKindOf(Heading.self))
                    let heading = document[0] as! Heading
                    expect(heading.level).to(equal(HeadingLevel.h1))
                    expect(heading.items.count).to(equal(1))
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
