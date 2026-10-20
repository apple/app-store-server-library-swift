// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///An item in a subscription to reactivate.
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

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateSku(self.sku), forKey: .sku)
    }
}
