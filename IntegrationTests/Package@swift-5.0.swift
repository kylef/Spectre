// swift-tools-version:5.0
import PackageDescription


let package = Package(
  name: "SpectreIntegration",
  products: [
    .executable(name: "Passing", targets: ["Passing"]),
    .executable(name: "Disabled", targets: ["Disabled"]),
    .executable(name: "Failing", targets: ["Failing"]),
  ],
  targets: [
    .target(name: "Spectre"),
    .target(name: "Passing", dependencies: ["Spectre"]),
    .target(name: "Disabled", dependencies: ["Spectre"]),
    .target(name: "Failing", dependencies: ["Spectre"]),
  ],
  swiftLanguageVersions: [.v5]
)
