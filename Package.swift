// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Maaku",
    products: [
        .library(
            name: "Maaku",
            targets: ["Maaku"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KristopherGBaker/libcmark_gfm.git", from: "0.29.2"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "Maaku",
            dependencies: ["libcmark_gfm"]),
        .testTarget(
            name: "MaakuTests",
            dependencies: ["Maaku", "Nimble", "Quick"]),
    ],
    swiftLanguageVersions: [.v5]
)
