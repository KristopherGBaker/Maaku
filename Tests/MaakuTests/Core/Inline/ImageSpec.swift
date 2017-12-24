//
//  ImageSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class ImageSpec: QuickSpec {
    
    override func spec() {
        
        describe("Image") {
            let text = "![image](http://lorempixel.com/400/200/)\n"
            
            do {
                let document = try Document(text: text)
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the image") {
                    expect(document[0]).to(beAKindOf(Paragraph.self))
                    let paragraph = document[0] as! Paragraph
                    expect(paragraph.items.count).to(equal(1))
                    expect(paragraph.items[0]).to(beAKindOf(Image.self))
                    let image = paragraph.items[0] as! Image
                    expect(image.destination).to(equal("http://lorempixel.com/400/200/"))
                    expect(image.description.count).to(equal(1))
                    expect(image.description[0]).to(beAKindOf(Text.self))
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
