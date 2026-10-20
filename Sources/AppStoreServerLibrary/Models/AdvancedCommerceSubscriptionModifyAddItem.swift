// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to add items when it makes changes to an auto-renewable subscription.
///
///[SubscriptionModifyAddItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyadditem)
public struct AdvancedCommerceSubscriptionModifyAddItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, description: String, displayName: String, price: Int64, offer: AdvancedCommerceOffer? = nil, proratedPrice: Int64? = nil) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
        self.description = try HelperValidationUtils.validateDescription(description)
        self.displayName = try HelperValidationUtils.validateDisplayName(displayName)
        self.price = price
        self.offer = offer
        self.proratedPrice = proratedPrice
    }

    ///The product identifier of an Apple In-App Purchase product you manage in your own system.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    ///A string you provide that describes a SKU.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///A string with a product name that you can localize and is suitable for display to customers.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///A discount offer for an auto-renewable subscription.
    ///
    ///[Offer](https://developer.apple.com/documentation/advancedcommerceapi/offer)
    public var offer: AdvancedCommerceOffer?

    ///A price, in milliunits of a currency, for an Advanced Commerce API SKU.
    ///
    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    ///A prorated price, in milliunits of a currency, for an Advanced Commerce API SKU.
    ///
    ///[proratedPrice](https://developer.apple.com/documentation/advancedcommerceapi/proratedprice)
    public var proratedPrice: Int64?

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case description = "description"
        case displayName = "displayName"
        case offer = "offer"
        case price = "price"
        case proratedPrice = "proratedPrice"
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateSku(self.sku), forKey: .sku)
        try container.encode(HelperValidationUtils.validateDescription(self.description), forKey: .description)
        try container.encode(HelperValidationUtils.validateDisplayName(self.displayName), forKey: .displayName)
        try container.encodeIfPresent(self.offer, forKey: .offer)
        try container.encode(self.price, forKey: .price)
        try container.encodeIfPresent(self.proratedPrice, forKey: .proratedPrice)
    }
}
