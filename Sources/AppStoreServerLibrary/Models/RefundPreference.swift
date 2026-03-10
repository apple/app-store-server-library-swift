// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///A value that indicates your preferred outcome for the refund request.
///
///[refundPreference](https://developer.apple.com/documentation/appstoreserverapi/refundpreference)
public enum RefundPreference: String, Decodable, Encodable, Hashable, Sendable {
    case decline = "DECLINE"
    case grantFull = "GRANT_FULL"
    case grantProrated = "GRANT_PRORATED"
}
