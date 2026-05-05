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

    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///[Offer](https://developer.apple.com/documentation/advancedcommerceapi/offer)
    public var offer: AdvancedCommerceOffer?

    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    ///The item’s product identifier, which you define.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case description = "description"
        case displayName = "displayName"
        case offer = "offer"
        case price = "price"
        case sku = "SKU"
    }
}
