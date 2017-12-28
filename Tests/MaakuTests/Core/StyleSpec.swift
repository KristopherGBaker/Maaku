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
                let style = Style()

                it("sets the colors") {
                    expect(style.color(.h1)).to(equal(Color.black))
                    expect(style.color(.h2)).to(equal(Color.black))
                    expect(style.color(.h3)).to(equal(Color.black))
                    expect(style.color(.h4)).to(equal(Color.black))
                    expect(style.color(.h5)).to(equal(Color.black))
                    expect(style.color(.h6)).to(equal(Color.black))
                    expect(style.color(.paragraph)).to(equal(Color.black))
                    expect(style.color(.link)).to(equal(Color.blue))
                    expect(style.color(.current)).to(equal(Color.black))
                }

                it("sets the fonts") {
                    #if os(OSX)
                        expect(style.font(.h1)).to(equal(Font.systemFont(ofSize: 28, weight: .semibold)))
                        expect(style.font(.h2)).to(equal(Font.systemFont(ofSize: 22, weight: .semibold)))
                        expect(style.font(.h3)).to(equal(Font.systemFont(ofSize: 20, weight: .semibold)))
                        expect(style.font(.h4)).to(equal(Font.systemFont(ofSize: 17, weight: .semibold)))
                        expect(style.font(.h5)).to(equal(Font.systemFont(ofSize: 15, weight: .semibold)))
                        expect(style.font(.h6)).to(equal(Font.systemFont(ofSize: 13, weight: .semibold)))
                        expect(style.font(.paragraph)).to(equal(Font.systemFont(ofSize: 17, weight: .regular)))
                        expect(style.font(.current)).to(equal(Font.systemFont(ofSize: 17, weight: .regular)))
                    #else
                        expect(style.font(.h1)).to(equal(Font.preferredFont(forTextStyle: .title1)))
                        expect(style.font(.h2)).to(equal(Font.preferredFont(forTextStyle: .title2)))
                        expect(style.font(.h3)).to(equal(Font.preferredFont(forTextStyle: .title3)))
                        expect(style.font(.h4)).to(equal(Font.preferredFont(forTextStyle: .headline)))
                        expect(style.font(.h5)).to(equal(Font.preferredFont(forTextStyle: .subheadline)))
                        expect(style.font(.h6)).to(equal(Font.preferredFont(forTextStyle: .footnote)))
                        expect(style.font(.paragraph)).to(equal(Font.preferredFont(forTextStyle: .body)))
                        expect(style.font(.current)).to(equal(Font.preferredFont(forTextStyle: .body)))
                    #endif
                }

                it("sets the strikethrough") {
                    expect(style.hasStrikethrough).to(equal(false))
                }
            }

            context("init(fonts:colors:hasStrikethrough:)") {
                var fonts = [Style.FontType: Font]()
                fonts[.h1] = Font.systemFont(ofSize: 38, weight: .bold)
                fonts[.h2] = Font.systemFont(ofSize: 32, weight: .bold)
                fonts[.h3] = Font.systemFont(ofSize: 30, weight: .bold)
                fonts[.h4] = Font.systemFont(ofSize: 27, weight: .bold)
                fonts[.h5] = Font.systemFont(ofSize: 25, weight: .bold)
                fonts[.h6] = Font.systemFont(ofSize: 23, weight: .bold)
                fonts[.paragraph] = Font.systemFont(ofSize: 27, weight: .thin)
                fonts[.current] = Font.systemFont(ofSize: 27, weight: .thin)

                var colors = [Style.ColorType: Color]()
                colors[.h1] = .white
                colors[.h2] = .white
                colors[.h3] = .white
                colors[.h4] = .white
                colors[.h5] = .white
                colors[.h6] = .white
                colors[.paragraph] = .white
                colors[.link] = .red
                colors[.current] = .white

                let style = Style(fonts: fonts, colors: colors, hasStrikethrough: true)

                it("sets the colors") {
                    expect(style.color(.h1)).to(equal(Color.white))
                    expect(style.color(.h2)).to(equal(Color.white))
                    expect(style.color(.h3)).to(equal(Color.white))
                    expect(style.color(.h4)).to(equal(Color.white))
                    expect(style.color(.h5)).to(equal(Color.white))
                    expect(style.color(.h6)).to(equal(Color.white))
                    expect(style.color(.paragraph)).to(equal(Color.white))
                    expect(style.color(.link)).to(equal(Color.red))
                    expect(style.color(.current)).to(equal(Color.white))
                }

                it("sets the fonts") {
                    expect(style.font(.h1)).to(equal(Font.systemFont(ofSize: 38, weight: .bold)))
                    expect(style.font(.h2)).to(equal(Font.systemFont(ofSize: 32, weight: .bold)))
                    expect(style.font(.h3)).to(equal(Font.systemFont(ofSize: 30, weight: .bold)))
                    expect(style.font(.h4)).to(equal(Font.systemFont(ofSize: 27, weight: .bold)))
                    expect(style.font(.h5)).to(equal(Font.systemFont(ofSize: 25, weight: .bold)))
                    expect(style.font(.h6)).to(equal(Font.systemFont(ofSize: 23, weight: .bold)))
                    expect(style.font(.paragraph)).to(equal(Font.systemFont(ofSize: 27, weight: .thin)))
                    expect(style.font(.current)).to(equal(Font.systemFont(ofSize: 27, weight: .thin)))
                }

                it("sets the strikethrough") {
                    expect(style.hasStrikethrough).to(equal(true))
                }
            }

            context("preferredFonts()") {
                var fonts = [Style.FontType: Font]()
                fonts[.h1] = Font.systemFont(ofSize: 38, weight: .bold)
                fonts[.h2] = Font.systemFont(ofSize: 32, weight: .bold)
                fonts[.h3] = Font.systemFont(ofSize: 30, weight: .bold)
                fonts[.h4] = Font.systemFont(ofSize: 27, weight: .bold)
                fonts[.h5] = Font.systemFont(ofSize: 25, weight: .bold)
                fonts[.h6] = Font.systemFont(ofSize: 23, weight: .bold)
                fonts[.paragraph] = Font.systemFont(ofSize: 27, weight: .thin)
                fonts[.current] = Font.systemFont(ofSize: 27, weight: .thin)

                let style = Style(fonts: fonts,
                                  colors: [Style.ColorType: Color](),
                                  hasStrikethrough: true)
                    .preferredFonts()

                it("sets the fonts") {
                    #if os(OSX)
                        expect(style.font(.h1)).to(equal(Font.systemFont(ofSize: 28, weight: .semibold)))
                        expect(style.font(.h2)).to(equal(Font.systemFont(ofSize: 22, weight: .semibold)))
                        expect(style.font(.h3)).to(equal(Font.systemFont(ofSize: 20, weight: .semibold)))
                        expect(style.font(.h4)).to(equal(Font.systemFont(ofSize: 17, weight: .semibold)))
                        expect(style.font(.h5)).to(equal(Font.systemFont(ofSize: 15, weight: .semibold)))
                        expect(style.font(.h6)).to(equal(Font.systemFont(ofSize: 13, weight: .semibold)))
                        expect(style.font(.paragraph)).to(equal(Font.systemFont(ofSize: 17, weight: .regular)))
                    #else
                        expect(style.font(.h1)).to(equal(Font.preferredFont(forTextStyle: .title1)))
                        expect(style.font(.h2)).to(equal(Font.preferredFont(forTextStyle: .title2)))
                        expect(style.font(.h3)).to(equal(Font.preferredFont(forTextStyle: .title3)))
                        expect(style.font(.h4)).to(equal(Font.preferredFont(forTextStyle: .headline)))
                        expect(style.font(.h5)).to(equal(Font.preferredFont(forTextStyle: .subheadline)))
                        expect(style.font(.h6)).to(equal(Font.preferredFont(forTextStyle: .footnote)))
                        expect(style.font(.paragraph)).to(equal(Font.preferredFont(forTextStyle: .body)))
                    #endif
                }
            }

            context("font(type:font:)") {
                let style = Style().font(type: .h1, font: Font.systemFont(ofSize: 40, weight: .black))

                it("sets the font") {
                    expect(style.font(.h1)).to(equal(Font.systemFont(ofSize: 40, weight: .black)))
                }
            }

            context("font(heading:)") {
                let heading = Heading(level: .h2)
                let style = Style().font(heading: heading)

                it("sets the font") {
                    expect(style.font(.current)).to(equal(style.font(.h2)))
                }
            }

            context("color(type:color:)") {
                let style = Style().color(type: .h3, color: Color.brown)

                it("sets the color") {
                    expect(style.color(.h3)).to(equal(Color.brown))
                }
            }

            context("enableStrikethrough()") {
                let style = Style().enableStrikethrough()

                it("sets the strikethrough") {
                    expect(style.hasStrikethrough).to(equal(true))
                }
            }

            context("disableStrikethrough()") {
                let style = Style().enableStrikethrough().disableStrikethrough()

                it("sets the strikethrough") {
                    expect(style.hasStrikethrough).to(equal(false))
                }
            }

            context("strong()") {
                let style = Style().strong()

                it("sets the strong font") {
                    let currentFont = style.font(.current)

                    #if os(OSX)
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.bold))
                    #else
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.traitBold))
                    #endif
                }
            }

            context("emphasis()") {
                let style = Style().emphasis()

                it("sets the emphasis font") {
                    let currentFont = style.font(.current)

                    #if os(OSX)
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.italic))
                    #else
                        XCTAssert(currentFont.fontDescriptor.symbolicTraits.contains(.traitItalic))
                    #endif
                }
            }

            context("font(forHeading:)") {
                let style = Style()

                it("gets the h1 font") {
                    let heading = Heading(level: .h1)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.font(.h1)))
                }

                it("gets the h2 font") {
                    let heading = Heading(level: .h2)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.font(.h2)))
                }

                it("gets the h3 font") {
                    let heading = Heading(level: .h3)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.font(.h3)))
                }

                it("gets the h4 font") {
                    let heading = Heading(level: .h4)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.font(.h4)))
                }

                it("gets the h5 font") {
                    let heading = Heading(level: .h5)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.font(.h5)))
                }

                it("gets the h6 font") {
                    let heading = Heading(level: .h6)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.font(.h6)))
                }

                it("gets the unknown font") {
                    let heading = Heading(level: .unknown)
                    let font = style.font(forHeading: heading)
                    expect(font).to(equal(style.font(.paragraph)))
                }
            }
        }
    }

}
