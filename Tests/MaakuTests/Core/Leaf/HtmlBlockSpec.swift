//
//  HtmlBlockSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class HtmlBlockSpec: QuickSpec {

    override func spec() {

        describe("HtmlBlock") {
            let text = """
<p>
Hello, this is a simple markdown document with one HTML block.
</p>
"""

            do {
                let document = try Document(text: text)

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the html block") {
                    expect(document[0]).to(beAKindOf(HtmlBlock.self))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
