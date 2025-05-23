// swift-tools-version: 5.9
// Created a basic Swift Package Manager configuration file
import PackageDescription

let package = Package(
    name: "Newaipp",
    targets: [
        .executableTarget(
            name: "Newaipp",
            path: "Sources"
        )
    ]
)
