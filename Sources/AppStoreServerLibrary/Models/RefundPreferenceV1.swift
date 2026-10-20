// Copyright (c) 2024 Apple Inc. Licensed under MIT License.

///A value that indicates your preferred outcome for the refund request.
///
///[refundPreferenceV1](https://developer.apple.com/documentation/appstoreserverapi/refundpreferencev1)
@available(*, deprecated, message: "Use RefundPreference instead")
public enum RefundPreferenceV1: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The refund preference is undeclared.
    case undeclared = 0

    ///You prefer that the App Store grants the refund.
    case preferGrant = 1

    ///You prefer that the App Store declines the refund.
    case preferDecline = 2

    ///You have no preference whether the App Store grants or declines the refund.
    case noPreference = 3
}
