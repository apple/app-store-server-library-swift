// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The status of a customer’s account within your app.
///
///[userStatus](https://developer.apple.com/documentation/appstoreserverapi/userstatus)
public enum UserStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    ///Account status is undeclared.
    case undeclared = 0

    ///The customer’s account is active.
    case active = 1

    ///The customer’s account is suspended.
    case suspended = 2

    ///The customer’s account is terminated.
    case terminated = 3

    ///The customer’s account has limited access.
    case limitedAccess = 4
}
