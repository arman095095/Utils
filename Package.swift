// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let remoteDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/malcommac/SwiftDate.git", from: "5.0.0"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
]

private let localDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/malcommac/SwiftDate.git", from: "5.0.0"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
]

let isDev = true
private let dependencies = isDev ? localDependencies : remoteDependencies

let package = Package(
    name: "Utils",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Utils",
            targets: ["Utils"]),
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Utils",
            dependencies: [
                .product(name: "SwiftDate", package: "SwiftDate"),
                .product(name: "Swinject", package: "Swinject")]),
    ]
)
