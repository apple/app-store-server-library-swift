// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body you provide to terminate a subscription and all its items immediately.
///
///[SubscriptionRevokeRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionrevokerequest)
public struct AdvancedCommerceSubscriptionRevokeRequest: Decodable, Encodable, Hashable, Sendable {

    public init(refundReason: AdvancedCommerceRefundReason, refundRiskingPreference: Bool, requestInfo: AdvancedCommerceRequestInfo, refundType: AdvancedCommerceRefundType, storefront: String? = nil) {
        self.rawRefundReason = refundReason.rawValue
        self.refundRiskingPreference = refundRiskingPreference
        self.requestInfo = requestInfo
        self.rawRefundType = refundType.rawValue
        self.storefront = storefront
    }

    public init(rawRefundReason: String, refundRiskingPreference: Bool, requestInfo: AdvancedCommerceRequestInfo, rawRefundType: String, storefront: String? = nil) {
        self.rawRefundReason = rawRefundReason
        self.refundRiskingPreference = refundRiskingPreference
        self.requestInfo = requestInfo
        self.rawRefundType = rawRefundType
        self.storefront = storefront
    }

    ///[refundReason](https://developer.apple.com/documentation/advancedcommerceapi/refundreason)
    public var refundReason: AdvancedCommerceRefundReason? {
        get {
            return AdvancedCommerceRefundReason(rawValue: rawRefundReason)
        }
        set {
            self.rawRefundReason = newValue.map { $0.rawValue } ?? rawRefundReason
        }
    }

    ///See ``refundReason``
    public var rawRefundReason: String

    ///[refundRiskingPreference](https://developer.apple.com/documentation/advancedcommerceapi/refundriskingpreference)
    public var refundRiskingPreference: Bool

    public var refundType: AdvancedCommerceRefundType? {
        get {
            return AdvancedCommerceRefundType(rawValue: rawRefundType)
        }
        set {
            self.rawRefundType = newValue.map { $0.rawValue } ?? rawRefundType
        }
    }

    ///See ``refundType``
    public var rawRefundType: String

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    public enum CodingKeys: CodingKey {
        case refundReason
        case refundRiskingPreference
        case refundType
        case requestInfo
        case storefront
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawRefundReason = try container.decode(String.self, forKey: .refundReason)
        self.refundRiskingPreference = try container.decode(Bool.self, forKey: .refundRiskingPreference)
        self.rawRefundType = try container.decode(String.self, forKey: .refundType)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawRefundReason, forKey: .refundReason)
        try container.encode(self.refundRiskingPreference, forKey: .refundRiskingPreference)
        try container.encode(self.rawRefundType, forKey: .refundType)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
    }
}
