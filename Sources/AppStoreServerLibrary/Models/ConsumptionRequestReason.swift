// Copyright (c) 2024 Apple Inc. Licensed under MIT License.

///The customer-provided reason for a refund request.
///
///[consumptionRequestReason](https://developer.apple.com/documentation/appstoreservernotifications/consumptionrequestreason)
public enum ConsumptionRequestReason: String, Decodable, Encodable, Hashable, Sendable {
    ///The customer didn’t intend to make the in-app purchase.
    case unintendedPurchase = "UNINTENDED_PURCHASE"

    ///The customer had issues with receiving or using the in-app purchase.
    case fulfillmentIssue = "FULFILLMENT_ISSUE"

    ///The customer wasn’t satisfied with the in-app purchase.
    case unsatisfiedWithPurchase = "UNSATISFIED_WITH_PURCHASE"

    ///The customer requested a refund based on a legal reason.
    case legal = "LEGAL"

    ///The customer requested a refund for other reasons.
    case other = "OTHER"
}
