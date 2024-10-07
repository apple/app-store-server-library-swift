// Copyright (c) 2024 Apple Inc. Licensed under MIT License.

///The customer-provided reason for a refund request.
///
///[consumptionRequestReason](https://developer.apple.com/documentation/appstoreservernotifications/consumptionrequestreason)
public enum ConsumptionRequestReason: String, Decodable, Encodable, Hashable, Sendable {
    case unintendedPurchase = "UNINTENDED_PURCHASE"
    case fulfillmentIssue = "FULFILLMENT_ISSUE"
    case unsatisfiedWithPurchase = "UNSATISFIED_WITH_PURCHASE"
    case legal = "LEGAL"
    case other = "OTHER"
}
