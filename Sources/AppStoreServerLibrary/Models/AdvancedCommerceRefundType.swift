// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///Information about the refund request for an item, such as its SKU, the refund amount, reason, and type.
///
///[RequestRefundItem](https://developer.apple.com/documentation/advancedcommerceapi/requestrefunditem)
public enum AdvancedCommerceRefundType: String, Decodable, Encodable, Hashable, Sendable {
    case full = "FULL"
    case prorated = "PRORATED"
    case custom = "CUSTOM"
}
