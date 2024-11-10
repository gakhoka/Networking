// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [], path: "Sources"
        ),
    ]
)
