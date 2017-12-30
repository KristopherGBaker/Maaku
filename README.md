# Maaku

[![Build Status](https://travis-ci.org/KristopherGBaker/Maaku.svg?branch=master)](https://travis-ci.org/KristopherGBaker/Maaku)

The Maaku framework provides a Swift wrapper around [cmark-gfm](https://github.com/github/cmark) with the addition of a Swift friendly representation of the AST. gfm extensions for tables, strikethrough, autolinks, and tag filters are supported.

Maaku also supports a convention for plugins that custom renderers can use. One plugin is provided as an example.

+ [Installation](#installation)
+ [Core](#core)
+ [Style](#core)
+ [CMark](#cmark)
+ [Plugins](#plugins)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Maaku into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Maaku'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Maaku into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "KristopherGBaker/Maaku" ~> 0.1.5
```

Run `carthage update` to build the framework and drag the built `Maaku.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Maaku does support its use on supported platforms. 

Once you have your Swift package set up, adding Maaku as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/KristopherGBaker/Maaku.git", from: "0.1.5")
]
```

#### Building with the Swift PM

##### Building for macOS
```bash
$ swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.11"
```

##### Running Tests
```bash
$ swift test -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.11"
```

## Core

`Document` is the primary interface for using Maaku. Document can be intialized by passing Data or String representing the CommonMark.

```swift
let document = try Document(text: commonMark)
```

Initializing a Document will parse the CommonMark and create an AST you can access. The document contains a list of the top level block elements, which each may contain either other block elements or inline elements. Block elements may be either container blocks or leaf blocks. Container blocks may contain other blocks, while leaf blocks may not.


## Style

Core types that adopt the Node protocol support conversion to NSAttributedString using the `attributedText` method (most types are supported, but there are currently some limits, in particular with inline images and HTML - both inline and blocks).

The fonts and colors used by the attributedText method can be specified using the `Style` type.

## CMark

The CMark* types (inspired in part by [CocoaMarkdown](https://github.com/indragiek/CocoaMarkdown)) provide a Swift friendly interface on top of cmark-gfm. The CMark types can be used on their own without Core by including only the `Maaku/CMark` subspec in your Podfile.

## Plugins

Plugins follow a convention where the plugin appears in the form of a single link in a paragraph in the CommonMark text. Here's an example of what a youtube plugin might look like in CommonMark:

```
Some other markdown text.

[youtubevideo](https://youtu.be/kkdBB1hVLX0)

More markdown.
```

To add support for this plugin, we need to implement two protocols: Plugin and PluginParser (defined in Plugin.swift and shown below for reference).

```swift
public protocol Plugin: LeafBlock {
    static var pluginName: PluginName { get }
}
```

```swift
public protocol PluginParser {
    var name: String { get }
    func parse(text: String) -> Plugin?
}
```

#### Plugin example

The Youtube plugin is provided as an example in the framework (as an optional subspec if you install with CocoaPods).

```swift
public struct YoutubePlugin: Plugin {

    public static let pluginName: PluginName = "youtubevideo"

    public let url: URL

    public var videoId: String? {
        return url.path.components(separatedBy: "/").last
    }

    public init(url: URL) {
        self.url = url
    }
}
```

The `pluginName` value should be unique to the plugin. It can be the same as the `name` used for the PluginParser, but does not need to be.

#### PluginParser example

```swift
public struct YoutubePluginParser: PluginParser {

    public let name = "youtubevideo"

    public func parse(text: String) -> Plugin? {
        guard let url = parseURL(text) else {
            return nil
        }

        return YoutubePlugin(url: url)
    }

    public init() {

    }
}
```

The `name` value should match the link text you use for the the plugin. Since the Youtube plugin looks like `[youtubevideo](https://youtu.be/kkdBB1hVLX0)`, `youtubevideo` is used for the `name`.

The raw link destination is passed to the parse method. You can decide how to deal with the text value to initialize your plugin, but there are convenience methods available to plugins to ease this process.

The `splitPluginParams` method supports the following format for multiple plugin parameters in the link destination.

```
param1::value1|param2::value2|param3::value3
```

`splitPluginParams` will split parameters in that format into a dictionary which you can use to initialize your plugin.

Let's say a Youtube plugin looked like this:

```
[youtubevideo](source::https://youtu.be/kkdBB1hVLX0||caption::Checkout this video)
```

Then the Plugin would be updated to look like:

```swift
public struct YoutubePlugin: Plugin {

    public static let pluginName: PluginName = "youtubevideo"

    public let url: URL
    
    public let caption: String?

    public var videoId: String? {
        return url.path.components(separatedBy: "/").last
    }

    public init(url: URL, caption: String?) {
        self.url = url
        self.caption = caption
    }
}
```

And the PluginParser might look like:

```swift
public struct YoutubePluginParser: PluginParser {

    public let name = "youtubevideo"

    public func parse(text: String) -> Plugin? {
        let parameters = splitPluginParams(text)
        
        guard parameters.count > 0,
            let source = parameters["source"],
            let url = URL(string: source) else {
            return nil
        }
        
        let caption = parameters["caption"]

        return YoutubePlugin(url: url, caption: caption)
    }

    public init() {

    }
}
```

#### Registering the plugin

The PluginParser must be registered with `PluginManager` before it will be used by the Maaku parser. If you don't register the plugin, it will instead appear as either a Link or Text rather than a Plugin. 

To register the PluginParser, intialize it and pass it to `PluginManager.registerParsers`.

For the Youtube example:

```swift
PluginManager.registerParsers([YoutubePluginParser()])
```
