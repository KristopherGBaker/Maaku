//
//  TableSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/21/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

import Maaku
import Nimble
import Quick
import XCTest

class TableSpec: QuickSpec {

    override func spec() {

        describe("Table") {
            let text = """
| Left-aligned | Center-aligned | Right-aligned |
| :---         |     :---:      |          ---: |
| git status   | git status     | git status    |
| git diff     | git diff       | git diff      |
"""

            do {
                let document = try Document(text: text)

                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }

                it("parses the table") {
                    expect(document[0]).to(beAKindOf(Table.self))
                }

                // swiftlint:disable force_cast
                let table = document[0] as! Table

                it("parses the header") {
                    expect(table.header.cells.count).to(equal(3))
                }

                it("parses the rows") {
                    expect(table.rows.count).to(equal(2))
                }

                it("parses the first row") {
                    expect(table.rows[0].cells.count).to(equal(3))
                }

                it("parses the second row") {
                    expect(table.rows[1].cells.count).to(equal(3))
                }

                it("parses the number of columns") {
                    expect(table.columns).to(equal(3))
                }

                it("parses the alignments") {
                    expect(table.alignments).to(equal([.left, .center, .right]))
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }
    }

}
