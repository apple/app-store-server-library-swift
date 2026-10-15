// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The type of refund requested.
///
///[RequestRefundItem](https://developer.apple.com/documentation/advancedcommerceapi/requestrefunditem)
public enum AdvancedCommerceRefundType: String, Decodable, Encodable, Hashable, Sendable {
    case full = "FULL"
    case prorated = "PRORATED"
    case custom = "CUSTOM"
}
