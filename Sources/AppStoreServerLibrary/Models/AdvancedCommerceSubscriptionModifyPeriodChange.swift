// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The data your app provides to change the period of an auto-renewable subscription.
///
///[SubscriptionModifyPeriodChange](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyperiodchange)
public struct AdvancedCommerceSubscriptionModifyPeriodChange: Decodable, Encodable, Hashable, Sendable {

    public init(effective: AdvancedCommerceEffective, period: AdvancedCommercePeriod) {
        self.rawEffective = effective.rawValue
        self.rawPeriod = period.rawValue
    }

    public init(rawEffective: String, rawPeriod: String) {
        self.rawEffective = rawEffective
        self.rawPeriod = rawPeriod
    }

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

    ///[Period](https://developer.apple.com/documentation/advancedcommerceapi/period)
    public var period: AdvancedCommercePeriod? {
        get {
            return AdvancedCommercePeriod(rawValue: rawPeriod)
        }
        set {
            self.rawPeriod = newValue.map { $0.rawValue } ?? rawPeriod
        }
    }

    ///See ``period``
    public var rawPeriod: String

    public enum CodingKeys: CodingKey {
        case effective
        case period
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawEffective = try container.decode(String.self, forKey: .effective)
        self.rawPeriod = try container.decode(String.self, forKey: .period)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawEffective, forKey: .effective)
        try container.encode(self.rawPeriod, forKey: .period)
    }
}
