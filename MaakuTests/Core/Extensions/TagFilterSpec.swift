//
//  TagFilterSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class TagFilterSpec: QuickSpec {
    
    override func spec() {
        
        describe("TagFilter") {
            let md = loadExample("tagfilter")
            
            guard let text = md else {
                XCTFail("example tagfilter nil")
                return
            }
            
            do {
                let document = try CMDocument(text: text)
                let html = try document.renderHtml()
                
                it("filters the html") {
                    expect(html).to(equal("<p>test &lt;iframe src=\"https://www.github.com\">filtered&lt;/iframe></p>\n"))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
