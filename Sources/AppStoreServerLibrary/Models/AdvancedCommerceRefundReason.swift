// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A reason to request a refund.
///
///[refundReason](https://developer.apple.com/documentation/advancedcommerceapi/refundreason)
public enum AdvancedCommerceRefundReason: String, Decodable, Encodable, Hashable, Sendable {
    ///The customer didn’t intend to make the Apple In-App Purchase.
    case unintendedPurchase = "UNINTENDED_PURCHASE"

    ///The customer had issues with receiving or using the Apple In-App Purchase.
    case fulfillmentIssue = "FULFILLMENT_ISSUE"

    ///The customer wasn’t satisfied with the Apple In-App Purchase.
    case unsatisfiedWithPurchase = "UNSATISFIED_WITH_PURCHASE"

    ///The customer requested a refund based on a legal reason.
    case legal = "LEGAL"

    ///The customer requested a refund for other reasons.
    case other = "OTHER"

    ///The customer modified one or more items in the subscription, which results in a refund.
    case modifyItemsRefund = "MODIFY_ITEMS_REFUND"

    ///For testing purposes only, a simulation of a refund that the App Store declines.
    case simulateRefundDecline = "SIMULATE_REFUND_DECLINE"
}
