// swift-tools-version: 5.9
// Mac Notes App with AI Diagram Generation
import PackageDescription

let package = Package(
    name: "Newaipp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Newaipp", targets: ["Newaipp"])
    ],
    targets: [
        .executableTarget(
            name: "Newaipp",
            path: "Sources"
        )
    ]
)
