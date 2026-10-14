// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data that describes a subscription item.
///
///[SubscriptionCreateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncreateitem)
public struct AdvancedCommerceSubscriptionCreateItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, description: String, displayName: String, price: Int64, offer: AdvancedCommerceOffer? = nil) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
        self.description = try HelperValidationUtils.validateDescription(description)
        self.displayName = try HelperValidationUtils.validateDisplayName(displayName)
        self.price = price
        self.offer = offer
    }

    ///The item’s product identifier, which you define.
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

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case description = "description"
        case displayName = "displayName"
        case offer = "offer"
        case price = "price"
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateSku(self.sku), forKey: .sku)
        try container.encode(HelperValidationUtils.validateDescription(self.description), forKey: .description)
        try container.encode(HelperValidationUtils.validateDisplayName(self.displayName), forKey: .displayName)
        try container.encodeIfPresent(self.offer, forKey: .offer)
        try container.encode(self.price, forKey: .price)
    }
}
