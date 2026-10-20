// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///A value that indicates your preferred outcome for the refund request.
///
///[refundPreference](https://developer.apple.com/documentation/appstoreserverapi/refundpreference)
public enum RefundPreference: String, Decodable, Encodable, Hashable, Sendable {
    ///You prefer that the App Store declines the refund.
    case decline = "DECLINE"

    ///You prefer that the App Store grants the refund in full.
    case grantFull = "GRANT_FULL"

    ///You prefer that the App Store grants a prorated refund.
    case grantProrated = "GRANT_PRORATED"
}
