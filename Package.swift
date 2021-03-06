// swift-tools-version:4.0

import PackageDescription


let package = Package(
  name: "Spectre",
  products: [
    .library(name: "Spectre", targets: ["Spectre"]),
  ],
  targets: [
    .target(name: "Spectre"),
    .testTarget(name: "SpectreTests", dependencies: ["Spectre"]),
  ]
)
