//
//  StyleSpec.swift
//  Maaku
//
//  Created by Kris Baker on 12/28/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

#if os(OSX)
    import AppKit
    public typealias Font  = NSFont
    public typealias Color = NSColor
#else
    import UIKit
    public typealias Font  = UIFont
    public typealias Color = UIColor
#endif

@testable import Maaku
import Nimble
import Quick
import XCTest

class StyleSpec: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {
        describe("Style") {

            context("init()") {
                let style: Style = DefaultStyle()

                it("sets the colors") {
                    expect(style.colors.h1).to(equal(Color.black))
                    expect(style.colors.h2).to(equal(Color.black))
                    expect(style.colors.h3).to(equal(Color.black))
                    expect(style.colors.h4).to(equal(Color.black))
                    expect(style.colors.h5).to(equal(Color.black))
                    expect(style.colors.h6).to(equal(Color.black))
                    expect(style.colors.paragraph).to(equal(Color.black))
                    expect(style.colors.link).to(equal(Color.blue))
                    expect(style.colors.current).to(equal(Color.black))
                    expect(style.colors.inlineCodeBackground).to(equal(Color(white: 0.95, alpha: 1.0)))
                    let inlineForegroundColor = Color(red: 0.91, green: 0.11, blue: 0.25, alpha: 1.00)
                    expect(style.colors.inlineCodeForeground).to(equal(inlineForegroundColor))
                }

                it("sets the fonts") {
                    #if os(OSX)
                        expect(style.fonts.h1).to(equal(Font.systemFont(ofSize: 28, weight: .semibold)))
                        expect(style.fonts.h2).to(equal(Font.systemFont(ofSize: 22, weight: .semibold)))
                        expect(style.fonts.h3).to(equal(Font.systemFont(ofSize: 20, weight: .semibold)))
                        expect(style.fonts.h4).to(equal(Font.systemFont(ofSize: 17, weight: .semibold)))
                        expect(style.fonts.h5).to(equal(Font.systemFont(ofSize: 15, weight: .semibold)))
                        expect(style.fonts.h6).to(equal(Font.systemFont(ofSize: 13, weight: .semibold)))
                        expect(style.fonts.paragraph).to(equal(Font.systemFont(ofSize: 17, weight: .regular)))
                        expect(style.fonts.current).to(equal(Font.systemFont(ofSize: 17, weight: .regular)))
                    #else
                        expect(style.fonts.h1).to(equal(Font.preferredFont(forTextStyle: .title1).maaku_bold()))
                        expect(style.fonts.h2).to(equal(Font.preferredFont(forTextStyle: .title2).maaku_bold()))
                        expect(style.fonts.h3).to(equal(Font.preferredFont(forTextStyle: .title3).maaku_bold()))
                        expect(style.fonts.h4).to(equal(Font.preferredFont(forTextStyle: .headline).maaku_bold()))
                        expect(style.fonts.h5).to(equal(Font.preferredFont(forTextStyle: .subheadline).maaku_bold()))
                        expect(style.fonts.h6).to(equal(Font.preferredFont(forTextStyle: .footnote).maaku_bold()))
                        expect(style.fonts.paragraph).to(equal(Font.preferredFont(forTextStyle: .body)))
                        expect(style.fonts.current).to(equal(Font.preferredFont(forTextStyle: .body)))
                    #endif
                }

                it("sets the strikethrough") {
                    expect(style.hasStrikethrough).to(equal(false))
                }
            }

            context("init(colors:fonts:hasStrikethrough:)") {
                var fonts: FontStyle = DefaultFontStyle()
                fonts.h1 = Font.systemFont(ofSize: 38, weight: .bold)
                fonts.h2 = Font.systemFont(ofSize: 32, weight: .bold)
                fonts.h3 = Font.systemFont(ofSize: 30, weight: .bold)
                fonts.h4 = Font.systemFont(ofSize: 27, weight: .bold)
                fonts.h5 = Font.systemFont(ofSize: 25, weight: .bold)
                fonts.h6 = Font.systemFont(ofSize: 23, weight: .bold)
                fonts.paragraph = Font.systemFont(ofSize: 27, weight: .thin)
                fonts.current = Font.systemFont(ofSize: 27, weight: .thin)

                var colors: ColorStyle = DefaultColorStyle()
                colors.h1 = .white
                colors.h2 = .white
                colors.h3 = .white
                colors.h4 = .white
                colors.h5 = .white
                colors.h6 = .white
                colors.paragraph = .white
                colors.link = .red
                colors.current = .white

                let style: Style = DefaultStyle(colors: colors, fonts: fonts, hasStrikethrough: true)

                it("sets the colors") {
                    expect(style.colors.h1).to(equal(Color.white))
                    expect(style.colors.h2).to(equal(Color.white))
                    expect(style.colors.h3).to(equal(Color.white))
                    expect(style.colors.h4).to(equal(Color.white))
                    expect(style.colors.h5).to(equal(Color.white))
                    expect(style.colors.h6).to(equal(Color.white))
                    expect(style.colors.paragraph).to(equal(Color.white))
                    expect(style.colors.link).to(equal(Color.red))
                    expect(style.colors.current).to(equal(Color.white))
                }

                it("sets the fonts") {
                    expect(style.fonts.h1).to(equal(Font.systemFont(ofSize: 38, weight: .bold)))
                    expect(style.fonts.h2).to(equal(Font.systemFont(ofSize: 32, weight: .bold)))
                    expect(style.fonts.h3).to(equal(Font.systemFont(ofSize: 30, weight: .bold)))
                    expect(style.fonts.h4).to(equal(Font.systemFont(ofSize: 27, weight: .bold)))
                    expect(style.fonts.h5).to(equal(Font.systemFont(ofSize: 25, weight: .bold)))
                    expect(style.fonts.h6).to(equal(Font.systemFont(ofSize: 23, weight: .bold)))
                    expect(style.fonts.paragraph).to(equal(Font.systemFont(ofSize: 27, weight: .thin)))
                    expect(style.fonts.current).to(equal(Font.systemFont(ofSize: 27, weight: .thin)))
                }

                it("sets the strikethrough") {
                    expect(style.hasStrikethrough).to(equal(true))
                }
            }

            context("strong()") {
                var style: Style = DefaultStyle()
                style.strong()

                it("sets the strong font") {
                    let currentFont = style.fonts.current

                    #if os(OSX)
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.bold))
                    #else
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.traitBold))
                    #endif
                }
            }

            context("emphasis()") {
                var style: Style = DefaultStyle()
                style.emphasis()

                it("sets the emphasis font") {
                    let currentFont = style.fonts.current

                    #if os(OSX)
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.italic))
                    #else
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.traitItalic))
                    #endif
                }
            }

            context("font(forHeading:)") {
                let style: Style = DefaultStyle()

                it("gets the h1 font") {
                    let heading = Heading(level: .h1)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.fonts.h1))
                }

                it("gets the h2 font") {
                    let heading = Heading(level: .h2)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.fonts.h2))
                }

                it("gets the h3 font") {
                    let heading = Heading(level: .h3)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.fonts.h3))
                }

                it("gets the h4 font") {
                    let heading = Heading(level: .h4)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.fonts.h4))
                }

                it("gets the h5 font") {
                    let heading = Heading(level: .h5)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.fonts.h5))
                }

                it("gets the h6 font") {
                    let heading = Heading(level: .h6)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.fonts.h6))
                }

                it("gets the unknown font") {
                    let heading = Heading(level: .unknown)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.fonts.paragraph))
                }
            }

            context("color(forHeading:)") {
                let style: Style = DefaultStyle()

                it("gets the h1 color") {
                    let heading = Heading(level: .h1)
                    let color = style.color(forHeading: heading)
                    expect(color).to(equal(style.colors.h1))
                }

                it("gets the h2 color") {
                    let heading = Heading(level: .h2)
                    let color = style.color(forHeading: heading)
                    expect(color).to(equal(style.colors.h2))
                }

                it("gets the h3 color") {
                    let heading = Heading(level: .h3)
                    let color = style.color(forHeading: heading)
                    expect(color).to(equal(style.colors.h3))
                }

                it("gets the h4 color") {
                    let heading = Heading(level: .h4)
                    let color = style.color(forHeading: heading)
                    expect(color).to(equal(style.colors.h4))
                }

                it("gets the h5 color") {
                    let heading = Heading(level: .h5)
                    let color = style.color(forHeading: heading)
                    expect(color).to(equal(style.colors.h5))
                }

                it("gets the h6 color") {
                    let heading = Heading(level: .h6)
                    let color = style.color(forHeading: heading)
                    expect(color).to(equal(style.colors.h6))
                }

                it("gets the unknown color") {
                    let heading = Heading(level: .unknown)
                    let color = style.color(forHeading: heading)
                    expect(color).to(equal(style.colors.paragraph))
                }
            }
        }
    }

}
