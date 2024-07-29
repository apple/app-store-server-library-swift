// Copyright (c) 2024 Apple Inc. Licensed under MIT License.

///A value that indicates your preferred outcome for the refund request.
///
///[refundPreference](https://developer.apple.com/documentation/appstoreserverapi/refundpreference)
public enum RefundPreference: Int32, Decodable, Encodable, Hashable, Sendable {
    case undeclared = 0
    case preferGrant = 1
    case preferDecline = 2
    case noPreference = 3
}
