// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The details of a one-time charge product, including its display name, price, SKU, and metadata.
///
///[OneTimeChargeItem](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargeitem)
public struct AdvancedCommerceOneTimeChargeItem: Decodable, Encodable, Hashable, Sendable {

    public init(description: String, displayName: String, sku: String, price: Int64) throws {
        self.description = try AdvancedCommerceValidationUtils.validateDescription(description)
        self.displayName = try AdvancedCommerceValidationUtils.validateDisplayName(displayName)
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
        self.price = price
    }

    ///A description of the product that doesn’t display to customers.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///The product name, suitable for display to customers.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///The product identifier.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    ///The price, in milliunits of the currency, of the one-time charge product.
    ///
    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    public enum CodingKeys: String, CodingKey {
        case description = "description"
        case displayName = "displayName"
        case sku = "SKU"
        case price = "price"
    }
}
