// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Newaipp",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        // Main app target
        .executableTarget(
            name: "Newaipp",
            dependencies: [],
            path: "Sources/Newaipp"
        ),
        
        // Core models and business logic
        .target(
            name: "NotesCore",
            dependencies: [],
            path: "Sources/NotesCore"
        ),
        
        // Test targets
        .testTarget(
            name: "NotesCoreTests",
            dependencies: ["NotesCore"],
            path: "Tests/NotesCoreTests"
        ),
        
        .testTarget(
            name: "NewaippTests",
            dependencies: ["Newaipp", "NotesCore"],
            path: "Tests/NewaippTests"
        )
    ]
)