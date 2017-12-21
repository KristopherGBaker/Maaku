//
//  CMDocumentSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class CMDocumentSpec: QuickSpec {
    
    override func spec() {
        describe("init(text: String)") {
            let md = loadExample("document")
            
            guard let text = md else {
                XCTFail("example document nil")
                return
            }
            
            it("initializes the document") {
                do {
                    let _ = try CMDocument(text: text)
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("init(data: Data)") {
            let md = loadExampleData("document")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            it("initializes the document") {
                do {
                    let _ = try CMDocument(data: data)
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("renderHtml") {
            let md = loadExampleData("paragraph")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            it("renders the document") {
                do {
                    let document = try CMDocument(data: data)
                    let html = try document.renderHtml()
                    expect(html).to(equal("<p>Hello, this is a simple markdown document with one paragraph.</p>\n"))
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("renderXml") {
            let md = loadExampleData("paragraph")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            it("renders the document") {
                do {
                    let document = try CMDocument(data: data)
                    let xml = try document.renderXml()
                    expect(xml).to(equal("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE document SYSTEM \"CommonMark.dtd\">\n<document xmlns=\"http://commonmark.org/xml/1.0\">\n  <paragraph>\n    <text>Hello, this is a simple markdown document with one paragraph.</text>\n  </paragraph>\n</document>\n"))
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("renderMan") {
            let md = loadExampleData("paragraph")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            it("renders the document") {
                do {
                    let document = try CMDocument(data: data)
                    let man = try document.renderMan(width: 100)
                    expect(man).to(equal(".PP\nHello, this is a simple markdown document with one paragraph.\n"))
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("renderCommonMark") {
            let md = loadExampleData("paragraph")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            it("renders the document") {
                do {
                    let document = try CMDocument(data: data)
                    let mark = try document.renderCommonMark(width: 100)
                    expect(mark).to(equal("Hello, this is a simple markdown document with one paragraph.\n"))
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("renderLatex") {
            let md = loadExampleData("blockquote")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            it("renders the document") {
                do {
                    let document = try CMDocument(data: data)
                    let latex = try document.renderLatex(width: 100)
                    expect(latex).to(equal("\\begin{quote}\nThis is a blockquote with two paragraphs. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\nAliquam hendrerit mi posuere lectus. Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae,\nrisus.\n\nDonec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse id sem consectetuer libero\nluctus adipiscing.\n\n\\end{quote}\n"))
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
        
        describe("renderPlainText") {
            let md = loadExampleData("paragraph")
            
            guard let data = md else {
                XCTFail("example document nil")
                return
            }
            
            it("renders the document") {
                do {
                    let document = try CMDocument(data: data)
                    let text = try document.renderPlainText(width: 100)
                    expect(text).to(equal("Hello, this is a simple markdown document with one paragraph.\n"))
                }
                catch let error {
                    XCTFail("\(error.localizedDescription)")
                }
            }
        }
    }
    
}
