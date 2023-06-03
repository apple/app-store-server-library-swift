// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The platform on which the customer consumed the in-app purchase.
///
///[platform](https://developer.apple.com/documentation/appstoreserverapi/platform)
public enum Platform: Int32, Decodable, Encodable, Hashable {
    case undeclared = 0
    case apple = 1
    case nonApple = 2
}
