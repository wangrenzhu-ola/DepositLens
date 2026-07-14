// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DepositLensCore",
    platforms: [.macOS(.v12)],
    products: [.library(name: "DepositLensCore", targets: ["DepositLensCore"])],
    targets: [
        .target(name: "DepositLensCore", path: "DepositLensCore"),
        .testTarget(name: "DepositLensCoreTests", dependencies: ["DepositLensCore"], path: "DepositLensCoreTests")
    ],
    swiftLanguageVersions: [.v5]
)
