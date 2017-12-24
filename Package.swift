// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Maaku",
    products: [
        .library(
            name: "Maaku",
            targets: ["Maaku"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KristopherGBaker/libcmark_gfm.git", from: "0.28.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "Maaku",
            dependencies: ["libcmark_gfm"]),
        .testTarget(
            name: "MaakuTests",
            dependencies: ["Maaku", "Nimble", "Quick"]),
    ],
    swiftLanguageVersions: [4]
)
