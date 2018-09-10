// swift-tools-version:4.0

import PackageDescription


let package = Package(
  name: "Spectre",
  products: [
    .library(name: "Spectre", targets: ["Spectre"]),
  ],
  targets: [
    .testTarget(name: "SpectreTests", dependencies: ["Spectre"]),
    .target(name: "Spectre", dependencies: []),
  ]
)
