// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "RJPSCData"

let exclude = ["_Documents/", "_\(packageName)SampleApp/"]

let package = Package(
    name: "rjps-coredata",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(name: "\(packageName)", targets: ["\(packageName)"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "\(packageName)", dependencies: [], exclude: exclude),
        .testTarget(
            name: "\(packageName)Tests",
            dependencies: ["RJPSCData"])
    ]
)
