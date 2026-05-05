// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///An item in a subscription to reactive.
///
///[SubscriptionReactivateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionreactivateitem)
public struct AdvancedCommerceSubscriptionReactivateItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
    }

    ///The SKU of the item to reactivate.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
    }
}
