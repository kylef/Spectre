import PackageDescription


let package = Package(
  name: "SpectreIntegration",
  targets: [
    Target(name: "Passing", dependencies: ["Spectre"]),
    Target(name: "Disabled", dependencies: ["Spectre"]),
    Target(name: "Failing", dependencies: ["Spectre"]),
  ]
)
