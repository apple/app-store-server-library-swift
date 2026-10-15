// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The platform on which the customer consumed the in-app purchase.
///
///[platform](https://developer.apple.com/documentation/appstoreserverapi/platform)
public enum Platform: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The platform is undeclared.
    case undeclared = 0

    ///An Apple platform.
    case apple = 1

    ///Non-Apple platform.
    case nonApple = 2
}
