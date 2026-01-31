// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A reason to request a refund.
///
///[refundReason](https://developer.apple.com/documentation/advancedcommerceapi/refundreason)
public enum AdvancedCommerceRefundReason: String, Decodable, Encodable, Hashable, Sendable {
    case unintendedPurchase = "UNINTENDED_PURCHASE"
    case fulfillmentIssue = "FULFILLMENT_ISSUE"
    case unsatisfiedWithPurchase = "UNSATISFIED_WITH_PURCHASE"
    case legal = "LEGAL"
    case other = "OTHER"
    case modifyItemsRefund = "MODIFY_ITEMS_REFUND"
    case simulateRefundDecline = "SIMULATE_REFUND_DECLINE"
}
