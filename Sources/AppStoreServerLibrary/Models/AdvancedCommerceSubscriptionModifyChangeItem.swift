// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to change an item of an auto-renewable subscription.
///
///[SubscriptionModifyChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifychangeitem)
public struct AdvancedCommerceSubscriptionModifyChangeItem: Decodable, Encodable, Hashable, Sendable {

    public init(currentSku: String, description: String, displayName: String, effective: AdvancedCommerceEffective, price: Int64, reason: AdvancedCommerceReason, sku: String, offer: AdvancedCommerceOffer? = nil, proratedPrice: Int64? = nil) throws {
        self.currentSku = try AdvancedCommerceValidationUtils.validateSku(currentSku)
        self.description = try AdvancedCommerceValidationUtils.validateDescription(description)
        self.displayName = try AdvancedCommerceValidationUtils.validateDisplayName(displayName)
        self.rawEffective = effective.rawValue
        self.price = price
        self.rawReason = reason.rawValue
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
        self.offer = offer
        self.proratedPrice = proratedPrice
    }

    public init(currentSku: String, description: String, displayName: String, rawEffective: String, price: Int64, rawReason: String, sku: String, offer: AdvancedCommerceOffer? = nil, proratedPrice: Int64? = nil) throws {
        self.currentSku = try AdvancedCommerceValidationUtils.validateSku(currentSku)
        self.description = try AdvancedCommerceValidationUtils.validateDescription(description)
        self.displayName = try AdvancedCommerceValidationUtils.validateDisplayName(displayName)
        self.rawEffective = rawEffective
        self.price = price
        self.rawReason = rawReason
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
        self.offer = offer
        self.proratedPrice = proratedPrice
    }

    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var currentSku: String

    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///[effective](https://developer.apple.com/documentation/advancedcommerceapi/effective)
    public var effective: AdvancedCommerceEffective? {
        get {
            return AdvancedCommerceEffective(rawValue: rawEffective)
        }
        set {
            self.rawEffective = newValue.map { $0.rawValue } ?? rawEffective
        }
    }

    ///See ``effective``
    public var rawEffective: String

    ///[Offer](https://developer.apple.com/documentation/advancedcommerceapi/offer)
    public var offer: AdvancedCommerceOffer?

    ///[price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    ///[proratedPrice](https://developer.apple.com/documentation/advancedcommerceapi/proratedprice)
    public var proratedPrice: Int64?

    public var reason: AdvancedCommerceReason? {
        get {
            return AdvancedCommerceReason(rawValue: rawReason)
        }
        set {
            self.rawReason = newValue.map { $0.rawValue } ?? rawReason
        }
    }

    ///See ``reason``
    public var rawReason: String

    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case currentSku = "currentSKU"
        case description = "description"
        case displayName = "displayName"
        case effective = "effective"
        case offer = "offer"
        case price = "price"
        case proratedPrice = "proratedPrice"
        case reason = "reason"
        case sku = "SKU"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentSku = try container.decode(String.self, forKey: .currentSku)
        self.description = try container.decode(String.self, forKey: .description)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.rawEffective = try container.decode(String.self, forKey: .effective)
        self.offer = try container.decodeIfPresent(AdvancedCommerceOffer.self, forKey: .offer)
        self.price = try container.decode(Int64.self, forKey: .price)
        self.proratedPrice = try container.decodeIfPresent(Int64.self, forKey: .proratedPrice)
        self.rawReason = try container.decode(String.self, forKey: .reason)
        self.sku = try container.decode(String.self, forKey: .sku)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.currentSku, forKey: .currentSku)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.displayName, forKey: .displayName)
        try container.encode(self.rawEffective, forKey: .effective)
        try container.encodeIfPresent(self.offer, forKey: .offer)
        try container.encode(self.price, forKey: .price)
        try container.encodeIfPresent(self.proratedPrice, forKey: .proratedPrice)
        try container.encode(self.rawReason, forKey: .reason)
        try container.encode(self.sku, forKey: .sku)
    }
}
