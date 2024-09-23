// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Example",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(name: "DebugOnlyMacro", path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "Example",
            dependencies:  [
                .product(name: "DebugOnly", package: "DebugOnlyMacro"),
            ]
        ),
    ]
)
