// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to change the price of an item in an auto-renewable subscription.
///
///[SubscriptionPriceChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionpricechangeitem)
public struct AdvancedCommerceSubscriptionPriceChangeItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, price: Int64, dependentSKUs: [String]? = nil) throws {
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
        self.price = price
        if let dependentSKUs = dependentSKUs {
            for dependentSku in dependentSKUs {
                _ = try AdvancedCommerceValidationUtils.validateSku(dependentSku)
            }
        }
        self.dependentSKUs = dependentSKUs
    }

    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    ///[dependentSKU](https://developer.apple.com/documentation/advancedcommerceapi/dependentsku)
    public var dependentSKUs: [String]?

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case price = "price"
        case dependentSKUs = "dependentSKUs"
    }
}
