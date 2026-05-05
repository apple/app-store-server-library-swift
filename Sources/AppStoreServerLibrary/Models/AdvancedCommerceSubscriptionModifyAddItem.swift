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

    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///A discount offer for an auto-renewable subscription.
    ///
    ///[Offer](https://developer.apple.com/documentation/advancedcommerceapi/offer)
    public var offer: AdvancedCommerceOffer?

    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    ///[proratedPrice](https://developer.apple.com/documentation/advancedcommerceapi/proratedprice)
    public var proratedPrice: Int64?

    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case description = "description"
        case displayName = "displayName"
        case offer = "offer"
        case price = "price"
        case proratedPrice = "proratedPrice"
        case sku = "SKU"
    }
}
