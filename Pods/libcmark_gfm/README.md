# libcmark_gfm

Swift compatible framework for [cmark-gfm](https://github.com/github/cmark). Works with CocoaPods, Carthage, and the Swift Package Manager.

[![](https://travis-ci.org/KristopherGBaker/libcmark_gfm.svg?branch=master)](https://travis-ci.org/KristopherGBaker/libcmark_gfm)

You can use libcmark_gfm directly, or consider using [Maaku](https://github.com/KristopherGBaker/Maaku).

[Maaku](https://github.com/KristopherGBaker/Maaku) provides a Swift wrapper around libcmark_gfm with the addition of a Swift friendly representation of the AST. gfm extensions for tables, strikethrough, autolinks, and tag filters are supported.

[TexturedMaaku](https://github.com/KristopherGBaker/TexturedMaaku) builds on top of Maaku together with [Texture](http://texturegroup.org/) to provide a native iOS CommonMark rendering framework in Swift.
