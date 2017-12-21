//
//  YoutubePluginSpec.swift
//  MaakuTests
//
//  Created by Kris Baker on 12/20/17.
//  Copyright © 2017 Kristopher Baker. All rights reserved.
//

@testable import Maaku
import Nimble
import Quick
import XCTest

class YoutubePluginSpec: QuickSpec {
    
    override func spec() {
        
        describe("YoutubePlugin") {
            do {
                PluginManager.registerParsers(parsers: [YoutubePluginParser()])
                let document = try Document(text: "[youtubevideo](source::https://youtu.be/cugj1h6PuK0)\n")
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the plugin") {
                    expect(document[0]).to(beAKindOf(YoutubePlugin.self))
                    let plugin = document[0] as! YoutubePlugin
                    expect(plugin.url).to(equal(URL(string: "https://youtu.be/cugj1h6PuK0")))
                }
            }
            catch let error {
                XCTFail("\(error.localizedDescription)")
            }
        }
    }
    
}
