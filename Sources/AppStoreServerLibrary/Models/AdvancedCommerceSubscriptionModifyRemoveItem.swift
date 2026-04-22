// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to remove an item from an auto-renewable subscription.
///
///[SubscriptionModifyRemoveItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyremoveitem)
public struct AdvancedCommerceSubscriptionModifyRemoveItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String) throws {
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
    }

    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
    }
}
