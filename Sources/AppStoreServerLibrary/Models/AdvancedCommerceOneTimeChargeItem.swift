// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The details of a one-time charge product, including its display name, price, SKU, and metadata.
///
///[OneTimeChargeItem](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargeitem)
public struct AdvancedCommerceOneTimeChargeItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, description: String, displayName: String, price: Int64) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
        self.description = try HelperValidationUtils.validateDescription(description)
        self.displayName = try HelperValidationUtils.validateDisplayName(displayName)
        self.price = price
    }

    ///The product identifier.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    ///A description of the product that doesn’t display to customers.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///The product name, suitable for display to customers.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///The price, in milliunits of the currency, of the one-time charge product.
    ///
    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case description = "description"
        case displayName = "displayName"
        case price = "price"
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateSku(self.sku), forKey: .sku)
        try container.encode(HelperValidationUtils.validateDescription(self.description), forKey: .description)
        try container.encode(HelperValidationUtils.validateDisplayName(self.displayName), forKey: .displayName)
        try container.encode(self.price, forKey: .price)
    }
}
