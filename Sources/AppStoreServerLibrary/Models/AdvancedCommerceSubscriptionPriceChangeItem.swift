// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to change a subscription price.
///
///[SubscriptionPriceChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionpricechangeitem)
public struct AdvancedCommerceSubscriptionPriceChangeItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, price: Int64, dependentSKUs: [String]? = nil) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
        self.price = price
        if let dependentSKUs = dependentSKUs {
            for dependentSku in dependentSKUs {
                _ = try HelperValidationUtils.validateSku(dependentSku, fieldName: "dependentSKUs")
            }
        }
        self.dependentSKUs = dependentSKUs
    }

    ///The product identifier of an Apple In-App Purchase product you manage in your own system.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    ///The product identifier of a dependent SKU in a subscription price change.
    ///
    ///[dependentSKU](https://developer.apple.com/documentation/advancedcommerceapi/dependentsku)
    public var dependentSKUs: [String]?

    ///A price, in milliunits of a currency, for an Advanced Commerce API SKU.
    ///
    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case dependentSKUs = "dependentSKUs"
        case price = "price"
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateSku(self.sku), forKey: .sku)
        if let dependentSKUs = self.dependentSKUs {
            for dependentSku in dependentSKUs {
                _ = try HelperValidationUtils.validateSku(dependentSku, fieldName: "dependentSKUs")
            }
        }
        try container.encodeIfPresent(self.dependentSKUs, forKey: .dependentSKUs)
        try container.encode(self.price, forKey: .price)
    }
}
