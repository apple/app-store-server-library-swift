// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The status of an auto-renewable subscription.
///
///[status](https://developer.apple.com/documentation/appstoreserverapi/status)
public enum Status: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The auto-renewable subscription is active.
    case active = 1

    ///The auto-renewable subscription is expired.
    case expired = 2

    ///The auto-renewable subscription is in a billing retry period.
    case billingRetry = 3

    ///The auto-renewable subscription is in a Billing Grace Period.
    case billingGracePeriod = 4

    ///The auto-renewable subscription is revoked.
    case revoked = 5
}
