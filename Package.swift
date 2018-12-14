// swift-tools-version:4.2

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
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.3.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "Maaku",
            dependencies: ["libcmark_gfm"]),
        .testTarget(
            name: "MaakuTests",
            dependencies: ["Maaku", "Nimble", "Quick"]),
    ],
    swiftLanguageVersions: [.v4_2]
)
