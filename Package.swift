// swift-tools-version: 5.8
// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import PackageDescription


let package = Package(
    name: "AppStoreServerLibrary",
    platforms: [
        .macOS(.v13), // And other server environments
    ],
    products: [
        .library(
            name: "AppStoreServerLibrary",
            targets: ["AppStoreServerLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-certificates.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-asn1.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "4.0.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "AppStoreServerLibrary",
            dependencies: [
                .product(name: "X509", package: "swift-certificates"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "SwiftASN1", package: "swift-asn1"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
            ]),
        .testTarget(
            name: "AppStoreServerLibraryTests",
            dependencies: ["AppStoreServerLibrary"],
            resources: [.copy("resources")]
        ),
    ]
)
