// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The type of an external purchase custom link token.
///
///[tokenType](https://developer.apple.com/documentation/appstoreservernotifications/tokentype)
public enum TokenType: String, Decodable, Encodable, Hashable, Sendable {
    ///A token type that indicates an initial acquisition.
    case acquisition = "ACQUISITION"

    ///A token type that indicates usage of App Store services.
    case services = "SERVICES"

    ///A token type an app receives from the MarketplaceKit token(for:) API.
    case coreTechnology = "CORE_TECHNOLOGY"
}
