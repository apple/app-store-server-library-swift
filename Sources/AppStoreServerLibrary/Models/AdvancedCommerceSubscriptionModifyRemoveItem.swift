// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to remove an item from an auto-renewable subscription.
///
///[SubscriptionModifyRemoveItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyremoveitem)
public struct AdvancedCommerceSubscriptionModifyRemoveItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
    }

    ///The product identifier of an Apple In-App Purchase product you manage in your own system.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateSku(self.sku), forKey: .sku)
    }
}
