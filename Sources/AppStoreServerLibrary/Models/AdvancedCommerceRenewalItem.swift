// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[advancedCommerceRenewalItem](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerenewalitem)
public struct AdvancedCommerceRenewalItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String? = nil, description: String? = nil, displayName: String? = nil, offer: AdvancedCommerceOffer? = nil, price: Int64? = nil, priceIncreaseInfo: AdvancedCommercePriceIncreaseInfo? = nil) {
        self.sku = sku
        self.description = description
        self.displayName = displayName
        self.offer = offer
        self.price = price
        self.priceIncreaseInfo = priceIncreaseInfo
    }

    ///[advancedCommerceSKU](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercesku)
    public var sku: String?

    ///[advancedCommerceDescription](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercedescription)
    public var description: String?

    ///[advancedCommerceDisplayName](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercedisplayname)
    public var displayName: String?

    ///[advancedCommerceOffer](https://developer.apple.com/documentation/appstoreserverapi/advancedcommerceoffer)
    public var offer: AdvancedCommerceOffer?

    ///[advancedCommercePrice](https://developer.apple.com/documentation/appstoreserverapi/advancedcommerceprice)
    public var price: Int64?

    ///[advancedCommercePriceIncreaseInfo](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercepriceincreaseinfo)
    public var priceIncreaseInfo: AdvancedCommercePriceIncreaseInfo?

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case description
        case displayName
        case offer
        case price
        case priceIncreaseInfo
    }
}
