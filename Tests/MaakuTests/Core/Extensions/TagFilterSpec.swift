//
//  TagFilterSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class TagFilterSpec: QuickSpec {

    override func spec() {

        describe("TagFilter") {
            let text = "test <iframe src=\"https://www.github.com\">filtered</iframe>\n"

            do {
                let document = try CMDocument(text: text)
                let html = try document.renderHtml()

                it("filters the html") {
                    let expected = """
<p>test <!-- raw HTML omitted -->filtered<!-- raw HTML omitted --></p>

"""
                    expect(html).to(equal(expected))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
