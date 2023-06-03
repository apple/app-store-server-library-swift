// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The status of a customer’s account within your app.
///
///[userStatus](https://developer.apple.com/documentation/appstoreserverapi/userstatus)
public enum UserStatus: Int32, Decodable, Encodable, Hashable {
    case undeclared = 0
    case active = 1
    case suspended = 2
    case terminated = 3
    case limitedAccess = 4
}
