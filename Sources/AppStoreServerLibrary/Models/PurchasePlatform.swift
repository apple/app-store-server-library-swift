// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The platform on which a customer originally purchases an app.
///
///[AppStore.Platform](https://developer.apple.com/documentation/storekit/appstore/platform)
///[originalPlatform](https://developer.apple.com/documentation/appstoreserverapi/originalplatform)
public enum PurchasePlatform: String, Decodable, Encodable, Hashable, Sendable {
    case macOS = "macOS"
    case iOS = "iOS"
    case tvOS = "tvOS"
    case visionOS = "visionOS"
}
