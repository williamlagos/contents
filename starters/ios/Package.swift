// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ContentsApp",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ContentsApp",
            targets: ["ContentsApp"]
        ),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ContentsApp",
            dependencies: []
        ),
        .testTarget(
            name: "ContentsAppTests",
            dependencies: ["ContentsApp"]
        ),
    ]
)
