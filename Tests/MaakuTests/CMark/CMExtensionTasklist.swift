//
//  CMExtensionTasklist.swift
//  Maaku
//
//  Created by Tim Learmont on 4/18/19.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Foundation
import Maaku
import Nimble
import Quick
import XCTest

extension String {
    /// Split a string into separate lines, trimming whitespace from the beginning and end of each line.
    ///
    /// This is useful for comparing results with expected results in tests, to avoid false mismatches
    /// just because there is different indentation in a line.
    ///
    /// - Returns: an array of strings, one for each line in the original string, with any
    //       whitespace trimmed from the front or end of the line.
    ///
    func splitIntoTrimmedLines() -> [String] {
        var lines: [String] = []
        self.enumerateLines { currentLine, _ in
            lines.append(currentLine.trimmingCharacters(in: CharacterSet.whitespaces))
        }
        return lines
    }
}

/// Test the tasklist extension
class CMExtensionTasklistSpec: QuickSpec {
    struct Constants {
        // Type names aren't available via the Maaku interface.
        static let tasklistTypeName = "tasklist"
    }

    // swiftlint:disable function_body_length
    override func spec() {
        let text = """
- [ ] task 1
- [x] completed ~~task~~
- [X] another completed task
- not a task
"""
        describe("TaskList extension") {
            context("no extensions enabled") {
                it("checks that no node has an extension") {
                    do {
                        let document = try CMDocument(text: text, options: .default, extensions: .none)

                        var extensionNodesFound: [CMNode] = []
                        var itemsFound: [CMNode] = []
                        for node in document.node.preorderSequence {
                            if node.extension != nil {
                                extensionNodesFound.append(node)
                            }
                            if node.type == .item {
                                itemsFound.append(node)
                            }
                        }
                        // We expect no extension nodes found (since none are enabled), and to find 4 items
                        expect(extensionNodesFound.count).to(equal(0))
                        expect(itemsFound.count).to(equal(4))
                    } catch let error {
                        it("fails to initialize the document") {
                            fail("\(error.localizedDescription)")
                        }
                    }
                }
            }

            context("tasklist extension enabled") {
                it("checks that the list nodes have extensions as appropriate") {
                    do {
                        let document = try CMDocument(text: text, options: .default, extensions: .tasklist)
                        var tasklistNodesFromExtension: [CMNode] = []
                        var tasklistNodesFromHumanReadableType: [CMNode] = []
                        var itemsFound: [CMNode] = []
                        for node in document.node.preorderSequence {
                            if let ext = node.extension, ext == .tasklist {
                                tasklistNodesFromExtension.append(node)
                            }
                            if let type = node.humanReadableType, type == Constants.tasklistTypeName {
                                tasklistNodesFromHumanReadableType.append(node)
                            }

                            if node.type == .item {
                                itemsFound.append(node)
                            } else {
                                // If it isn't an item, then it can't possibly be a task,
                                // so we expect those to not have a taskCompleted value.
                                expect(node.taskCompleted).to(beNil())
                            }
                        }
                        // We expect 3 task items and 4 items (since task items are included in items.
                        expect(tasklistNodesFromExtension.count).to(equal(3))
                        expect(itemsFound.count).to(equal(4))
                        // We expect that we get the same result whether we look at the human readable type
                        // or if we look at the extension + type.
                        expect(tasklistNodesFromExtension).to(equal(tasklistNodesFromHumanReadableType))

                        // Check that all the nodes from the tasklist extension have the tasklist type for their
                        // Readable value.
                        for node in tasklistNodesFromExtension {
                            expect(node.humanReadableType).to(equal(Constants.tasklistTypeName))
                        }
                        // But they have the item type for their actual type value.
                        for node in tasklistNodesFromExtension {
                            expect(node.type).to(equal(CMNodeType.item))
                        }

                        // Check the completion values.
                        expect(itemsFound[0].taskCompleted).to(equal(false))
                        expect(itemsFound[1].taskCompleted).to(equal(true))
                        expect(itemsFound[2].taskCompleted).to(equal(true))
                        // The last item isn't a task, so we expect taskCompleted to be nil
                        expect(itemsFound[3].taskCompleted).to(beNil())
                    } catch let error {
                        it("fails to initialize the document") {
                            fail("\(error.localizedDescription)")
                        }
                    }
                }
                it("can modify the tasklist state") {
                    do {
                        let text =
"""
- [ ] task

"""
                        let doc = try CMDocument(text: text, options: .default, extensions: .tasklist)
                        expect(try doc.renderCommonMark(width: 0)).to(equal(text))
                        let listNode = doc.node.firstChild!
                        // swiftlint:disable:next line_length
                        expect(try listNode.setTaskCompleted(false)).to(throwError(CMNode.ASTError.canNotSetValue))
                        let taskNode = listNode.firstChild!
                        expect(taskNode.humanReadableType).to(equal("tasklist"))
                        expect(taskNode.taskCompleted).to(equal(false))
                        expect(try taskNode.setTaskCompleted(true)).toNot(throwError())
                        expect(taskNode.taskCompleted).to(equal(true))
                        expect(try doc.renderCommonMark(width: 0)).to(equal(text.replacingOccurrences(of: "[ ]", with: "[x]")))
                        expect(try taskNode.setTaskCompleted(false)).toNot(throwError())
                        expect(taskNode.taskCompleted).to(equal(false))
                        expect(try doc.renderCommonMark(width: 0)).to(equal(text))
                    } catch let error {
                        it("fails to initialize the document") {
                            fail("\(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        describe("render document") {
            do {
                let document = try CMDocument(text: text, options: .sourcepos, extensions: .tasklist)
                let noExtensionDocument = try CMDocument(text: text, options: .sourcepos, extensions: .none)

                it("checks HTML version") {
                    do {
                        let htmlSplitAndTrimmed = try document.renderHtml().splitIntoTrimmedLines()
                        // swiftlint:disable:next line_length
                        let noExtensionsHtmlSplitAndTrimmed = try noExtensionDocument.renderHtml().splitIntoTrimmedLines()
                        // swiftlint:disable line_length
                        let expectedHtmlSplitAndTrimmed = [
                            "<ul data-sourcepos=\"1:1-4:12\">",
                            "<li data-sourcepos=\"1:1-1:12\"><input type=\"checkbox\" disabled=\"\" /> task 1</li>",
                            "<li data-sourcepos=\"2:1-2:24\"><input type=\"checkbox\" checked=\"\" disabled=\"\" /> completed ~~task~~</li>",
                            "<li data-sourcepos=\"3:1-3:28\"><input type=\"checkbox\" checked=\"\" disabled=\"\" /> another completed task</li>",
                            "<li data-sourcepos=\"4:1-4:12\">not a task</li>",
                            "</ul>"
                        ]
                        // swiftlint:enable line_length
                        // We expect that enabling tasklist will change the html
                        expect(htmlSplitAndTrimmed).toNot(equal(noExtensionsHtmlSplitAndTrimmed))
                        expect(htmlSplitAndTrimmed).to(equal(expectedHtmlSplitAndTrimmed))
                    } catch let error {
                        fail("Couldn't render doc as HTML: \(error.localizedDescription)")
                    }
                }
                it("checks XML version") {
                    do {
                        let xmlSplitAndTrimmed = try document.renderXml().splitIntoTrimmedLines()
                        let noExtensionsXmlSplitAndTrimmed = try noExtensionDocument.renderXml().splitIntoTrimmedLines()
                        let expectedXmlSplitAndTrimmed = [
                            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
                            "<!DOCTYPE document SYSTEM \"CommonMark.dtd\">",
                            "<document sourcepos=\"1:1-4:12\" xmlns=\"http://commonmark.org/xml/1.0\">",
                            "<list sourcepos=\"1:1-4:12\" type=\"bullet\" tight=\"true\">",
                            "<tasklist sourcepos=\"1:1-1:12\" completed=\"false\">",
                            "<paragraph sourcepos=\"1:7-1:12\">",
                            "<text sourcepos=\"1:7-1:12\" xml:space=\"preserve\">task 1</text>",
                            "</paragraph>",
                            "</tasklist>",
                            "<tasklist sourcepos=\"2:1-2:24\" completed=\"true\">",
                            "<paragraph sourcepos=\"2:7-2:24\">",
                            "<text sourcepos=\"2:7-2:24\" xml:space=\"preserve\">completed ~~task~~</text>",
                            "</paragraph>",
                            "</tasklist>",
                            "<tasklist sourcepos=\"3:1-3:28\" completed=\"true\">",
                            "<paragraph sourcepos=\"3:7-3:28\">",
                            "<text sourcepos=\"3:7-3:28\" xml:space=\"preserve\">another completed task</text>",
                            "</paragraph>",
                            "</tasklist>",
                            "<item sourcepos=\"4:1-4:12\">",
                            "<paragraph sourcepos=\"4:3-4:12\">",
                            "<text sourcepos=\"4:3-4:12\" xml:space=\"preserve\">not a task</text>",
                            "</paragraph>",
                            "</item>",
                            "</list>",
                            "</document>"
                        ]
                        // We expect that enabling tasklist will change the xml
                        expect(xmlSplitAndTrimmed).toNot(equal(noExtensionsXmlSplitAndTrimmed))
                        // Expected failure because the XML version doesn't (yet) report that a task
                        // is marked completed.
                        expect(xmlSplitAndTrimmed).to(equal(expectedXmlSplitAndTrimmed))
                    } catch let error {
                        fail("Couldn't render doc as XML: \(error.localizedDescription)")
                    }
                }
                it("checks man page version") {
                    do {
                        let manSplitAndTrimmed = try document.renderMan(width: 100).splitIntoTrimmedLines()
                        // swiftlint:disable:next line_length
                        let noExtensionsManSplitAndTrimmed = try noExtensionDocument.renderMan(width: 100).splitIntoTrimmedLines()
                        let expectedManSplitAndTrimmed = [
                            ".IP \\[bu] 2",
                            "task 1",
                            ".IP \\[bu] 2",
                            "completed ~~task~~",
                            ".IP \\[bu] 2",
                            "another completed task",
                            ".IP \\[bu] 2",
                            "not a task"
                        ]
                        // TODO fix Man rendering to include whether completed
                        // We expect that enabling tasklist will change the Man page
                        expect(manSplitAndTrimmed).toNot(equal(noExtensionsManSplitAndTrimmed))
                        expect(manSplitAndTrimmed).to(equal(expectedManSplitAndTrimmed))
                    } catch let error {
                        fail("Couldn't render doc as Man page: \(error.localizedDescription)")
                    }
                }
                it("checks CommonMark version") {
                    do {
                        // swiftlint:disable line_length
                        let commonMarkSplitAndTrimmed = try document.renderCommonMark(width: 100).splitIntoTrimmedLines()
                        let noExtensionsCommonMarkSplitAndTrimmed = try noExtensionDocument.renderCommonMark(width: 100).splitIntoTrimmedLines()
                        // swiftlint:enable line_length
                        let expectedCommonMarkSplitAndTrimmed = [
                            "- [ ] task 1",
                            "- [x] completed \\~\\~task\\~\\~",
                            "- [x] another completed task",
                            "- not a task"
                        ]
                        // We expect that enabling tasklist will change the common mark
                        expect(commonMarkSplitAndTrimmed).toNot(equal(noExtensionsCommonMarkSplitAndTrimmed))
                        expect(commonMarkSplitAndTrimmed).to(equal(expectedCommonMarkSplitAndTrimmed))
                    } catch let error {
                        fail("Couldn't render doc as CommonMark: \(error.localizedDescription)")
                    }
                }
                it("checks Latex version") {
                    do {
                        let latexSplitAndTrimmed = try document.renderLatex(width: 100).splitIntoTrimmedLines()
                        // swiftlint:disable:next line_length
                        let noExtensionsLatexSplitAndTrimmed = try noExtensionDocument.renderLatex(width: 100).splitIntoTrimmedLines()
                        let expectedLatexSplitAndTrimmed = [
                            "\\begin{itemize}",
                            "\\item task 1",
                            "",
                            // swiftlint:disable:next line_length
                            "\\item completed \\textasciitilde{}\\textasciitilde{}task\\textasciitilde{}\\textasciitilde{}",
                            "",
                            "\\item another completed task",
                            "",
                            "\\item not a task",
                            "",
                            "\\end{itemize}"
                        ]
                        // TODO fix Latex rendering to include whether completed
                        // We expect that enabling tasklist will change the latex
                        expect(latexSplitAndTrimmed).toNot(equal(noExtensionsLatexSplitAndTrimmed))
                        expect(latexSplitAndTrimmed).to(equal(expectedLatexSplitAndTrimmed))
                    } catch let error {
                        fail("Couldn't render doc as Latex: \(error.localizedDescription)")
                    }
                }
                it("checks plain text version") {
                    do {
                        let plainTextSplitAndTrimmed = try document.renderPlainText(width: 100).splitIntoTrimmedLines()
                        let noExtensionsPlainText = try noExtensionDocument.renderPlainText(width: 100)
                        let noExtensionsPlainTextSplitAndTrimmed = noExtensionsPlainText.splitIntoTrimmedLines()
                        let expectedPlainTextSplitAndTrimmed = [
                            "- [ ] task 1",
                            "- [x] completed ~~task~~",
                            "- [x] another completed task",
                            "- not a task"
                        ]
                        // We expect that enabling tasklist will change the plain text because of the
                        // uppper/lower case X
                        expect(plainTextSplitAndTrimmed).toNot(equal(noExtensionsPlainTextSplitAndTrimmed))
                        // We expect that really, the only difference between whether or not the tasklist
                        // extension is enabled is whether the upper case X was converted to a lower case one.
                        // swiftlint:disable:next line_length
                        expect(plainTextSplitAndTrimmed).to(equal(noExtensionsPlainText.replacingOccurrences(of: "[X]", with: "[x]").splitIntoTrimmedLines()))
                        expect(plainTextSplitAndTrimmed).to(equal(expectedPlainTextSplitAndTrimmed))
                    } catch let error {
                        fail("Couldn't render doc as plain text: \(error.localizedDescription)")
                    }
                }
            } catch let error {
                it("fails to initialize the document") {
                    fail("\(error.localizedDescription)")
                }
            }
        }

    }

}
