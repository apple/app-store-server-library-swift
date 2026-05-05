// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///[advancedCommerceTransactionItem](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetransactionitem)
public struct AdvancedCommerceTransactionItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String? = nil, description: String? = nil, displayName: String? = nil, offer: AdvancedCommerceOffer? = nil, price: Int64? = nil, refunds: [AdvancedCommerceRefund]? = nil, revocationDate: Date? = nil) {
        self.sku = sku
        self.description = description
        self.displayName = displayName
        self.offer = offer
        self.price = price
        self.refunds = refunds
        self.revocationDate = revocationDate
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

    ///[advancedCommerceRefunds](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerefunds)
    public var refunds: [AdvancedCommerceRefund]?

    ///[revocationDate](https://developer.apple.com/documentation/appstoreserverapi/revocationdate)
    public var revocationDate: Date?

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case description
        case displayName
        case offer
        case price
        case refunds
        case revocationDate
    }
}
