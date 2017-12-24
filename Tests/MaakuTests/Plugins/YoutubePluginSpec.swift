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
                let document = try Document(text: "[youtubevideo](source::https://youtu.be/kkdBB1hVLX0)\n")
                
                it("initializes the document") {
                    expect(document.count).to(equal(1))
                }
                
                it("parses the plugin") {
                    expect(document[0]).to(beAKindOf(YoutubePlugin.self))
                }
                
                let plugin = document[0] as! YoutubePlugin
                
                it("sets the url") {
                    expect(plugin.url).to(equal(URL(string: "https://youtu.be/kkdBB1hVLX0")))
                }
                
                it("gets the video id") {
                    expect(plugin.videoId).to(equal("kkdBB1hVLX0"))
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
