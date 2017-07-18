// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Spectre",
  targets: [
    .target(name: "Spectre", dependencies: [], path: "Sources"),
    .testTarget(name: "SpectreTests", dependencies: ["Spectre"], path: "Tests")
  ]
)
