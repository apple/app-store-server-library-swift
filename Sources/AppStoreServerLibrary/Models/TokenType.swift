// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The type of an external purchase custom link token.
///
///[tokenType](https://developer.apple.com/documentation/appstoreservernotifications/tokentype)
public enum TokenType: String, Decodable, Encodable, Hashable, Sendable {
    case services = "SERVICES"
    case acquisition = "ACQUISITION"
}
