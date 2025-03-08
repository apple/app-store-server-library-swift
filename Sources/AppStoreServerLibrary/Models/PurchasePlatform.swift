// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///Values that represent Apple platforms.
///
///[AppStore.Platform](https://developer.apple.com/documentation/storekit/appstore/platform)
public enum PurchasePlatform: String, Decodable, Encodable, Hashable, Sendable {
    case iOS = "iOS"
    case macOS = "macOS"
    case tvOS = "tvOS"
    case visionOS = "visionOS"
}
