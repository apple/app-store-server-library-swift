// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to change an item of an auto-renewable subscription.
///
///[SubscriptionModifyChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifychangeitem)
public struct AdvancedCommerceSubscriptionModifyChangeItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, description: String, displayName: String, currentSku: String, effective: AdvancedCommerceEffective, price: Int64, reason: AdvancedCommerceReason, offer: AdvancedCommerceOffer? = nil, proratedPrice: Int64? = nil) throws {
        try self.init(sku: sku, description: description, displayName: displayName, currentSku: currentSku, rawEffective: effective.rawValue, price: price, rawReason: reason.rawValue, offer: offer, proratedPrice: proratedPrice)
    }

    public init(sku: String, description: String, displayName: String, currentSku: String, rawEffective: String, price: Int64, rawReason: String, offer: AdvancedCommerceOffer? = nil, proratedPrice: Int64? = nil) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
        self.description = try HelperValidationUtils.validateDescription(description)
        self.displayName = try HelperValidationUtils.validateDisplayName(displayName)
        self.currentSku = try HelperValidationUtils.validateSku(currentSku, fieldName: "currentSKU")
        self.rawEffective = rawEffective
        self.price = price
        self.rawReason = rawReason
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

    ///The product identifier of an Apple In-App Purchase product you manage in your own system.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var currentSku: String

    ///A string value that indicates when a requested change to an auto-renewable subscription goes into effect.
    ///
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

    ///[SubscriptionModifyChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifychangeitem)
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

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case description = "description"
        case displayName = "displayName"
        case currentSku = "currentSKU"
        case effective = "effective"
        case offer = "offer"
        case price = "price"
        case proratedPrice = "proratedPrice"
        case reason = "reason"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sku = try container.decode(String.self, forKey: .sku)
        self.description = try container.decode(String.self, forKey: .description)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.currentSku = try container.decode(String.self, forKey: .currentSku)
        self.rawEffective = try container.decode(String.self, forKey: .effective)
        self.offer = try container.decodeIfPresent(AdvancedCommerceOffer.self, forKey: .offer)
        self.price = try container.decode(Int64.self, forKey: .price)
        self.proratedPrice = try container.decodeIfPresent(Int64.self, forKey: .proratedPrice)
        self.rawReason = try container.decode(String.self, forKey: .reason)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateSku(self.sku), forKey: .sku)
        try container.encode(HelperValidationUtils.validateDescription(self.description), forKey: .description)
        try container.encode(HelperValidationUtils.validateDisplayName(self.displayName), forKey: .displayName)
        try container.encode(HelperValidationUtils.validateSku(self.currentSku, fieldName: "currentSKU"), forKey: .currentSku)
        try container.encode(self.rawEffective, forKey: .effective)
        try container.encodeIfPresent(self.offer, forKey: .offer)
        try container.encode(self.price, forKey: .price)
        try container.encodeIfPresent(self.proratedPrice, forKey: .proratedPrice)
        try container.encode(self.rawReason, forKey: .reason)
    }
}
