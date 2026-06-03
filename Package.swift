// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "KeyScout",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "KeyScout", targets: ["KeyScout"])
    ],
    targets: [
        .executableTarget(
            name: "KeyScout",
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("ApplicationServices")
            ]
        ),
        .testTarget(
            name: "KeyScoutTests",
            dependencies: ["KeyScout"]
        )
    ]
)
