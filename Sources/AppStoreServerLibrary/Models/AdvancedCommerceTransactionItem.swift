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

    ///The UNIX time, in milliseconds, that the App Store refunded the transaction or revoked it from Family Sharing.
    ///
    ///[revocationDate](https://developer.apple.com/documentation/appstoreserverapi/revocationdate)
    public var revocationDate: Date?

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case description = "description"
        case displayName = "displayName"
        case offer = "offer"
        case price = "price"
        case refunds = "refunds"
        case revocationDate = "revocationDate"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sku = try container.decodeIfPresent(String.self, forKey: .sku)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.offer = try container.decodeIfPresent(AdvancedCommerceOffer.self, forKey: .offer)
        self.price = try container.decodeIfPresent(Int64.self, forKey: .price)
        self.refunds = try container.decodeIfPresent([AdvancedCommerceRefund].self, forKey: .refunds)
        self.revocationDate = try container.decodeIfPresent(Double.self, forKey: .revocationDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.sku, forKey: .sku)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encodeIfPresent(self.offer, forKey: .offer)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.refunds, forKey: .refunds)
        try container.encodeIfPresent(self.revocationDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .revocationDate)
    }
}
