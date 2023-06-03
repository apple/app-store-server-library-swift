// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The status of an auto-renewable subscription.
///
///[status](https://developer.apple.com/documentation/appstoreserverapi/status)
public enum Status: Int32, Decodable, Encodable, Hashable {
    case active = 1
    case expired = 2
    case billingRetry = 3
    case billingGracePeriod = 4
    case revoked = 5
}
