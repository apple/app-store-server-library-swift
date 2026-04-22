// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A discount offer for an auto-renewable subscription.
///
///[Offer](https://developer.apple.com/documentation/advancedcommerceapi/offer)
public struct AdvancedCommerceOffer: Decodable, Encodable, Hashable, Sendable {

    public init(period: AdvancedCommerceOfferPeriod, periodCount: Int32, price: Int64, reason: AdvancedCommerceOfferReason) throws {
        self.rawPeriod = period.rawValue
        self.periodCount = try AdvancedCommerceValidationUtils.validatePeriodCount(periodCount)
        self.price = price
        self.rawReason = reason.rawValue
    }

    public init(rawPeriod: String, periodCount: Int32, price: Int64, rawReason: String) throws {
        self.rawPeriod = rawPeriod
        self.periodCount = try AdvancedCommerceValidationUtils.validatePeriodCount(periodCount)
        self.price = price
        self.rawReason = rawReason
    }

    ///The period of the offer.
    public var period: AdvancedCommerceOfferPeriod? {
        get {
            return AdvancedCommerceOfferPeriod(rawValue: rawPeriod)
        }
        set {
            self.rawPeriod = newValue.map { $0.rawValue } ?? rawPeriod
        }
    }

    ///See ``period``
    public var rawPeriod: String

    ///The number of periods the offer is active.
    public var periodCount: Int32

    ///The offer price, in milliunits.
    ///
    ///[Price](https://developer.apple.com/documentation/advancedcommerceapi/price)
    public var price: Int64

    ///The reason for the offer.
    public var reason: AdvancedCommerceOfferReason? {
        get {
            return AdvancedCommerceOfferReason(rawValue: rawReason)
        }
        set {
            self.rawReason = newValue.map { $0.rawValue } ?? rawReason
        }
    }

    ///See ``reason``
    public var rawReason: String

    public enum CodingKeys: CodingKey {
        case period
        case periodCount
        case price
        case reason
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawPeriod = try container.decode(String.self, forKey: .period)
        self.periodCount = try container.decode(Int32.self, forKey: .periodCount)
        self.price = try container.decode(Int64.self, forKey: .price)
        self.rawReason = try container.decode(String.self, forKey: .reason)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawPeriod, forKey: .period)
        try container.encode(self.periodCount, forKey: .periodCount)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.rawReason, forKey: .reason)
    }
}
