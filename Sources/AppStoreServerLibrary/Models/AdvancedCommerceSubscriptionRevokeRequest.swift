// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body you provide to terminate a subscription and all its items immediately.
///
///[SubscriptionRevokeRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionrevokerequest)
public struct AdvancedCommerceSubscriptionRevokeRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, refundReason: AdvancedCommerceRefundReason, refundRiskingPreference: Bool, refundType: AdvancedCommerceRefundType, storefront: String? = nil) {
        self.init(requestInfo: requestInfo, rawRefundReason: refundReason.rawValue, refundRiskingPreference: refundRiskingPreference, rawRefundType: refundType.rawValue, storefront: storefront)
    }

    public init(requestInfo: AdvancedCommerceRequestInfo, rawRefundReason: String, refundRiskingPreference: Bool, rawRefundType: String, storefront: String? = nil) {
        self.requestInfo = requestInfo
        self.rawRefundReason = rawRefundReason
        self.refundRiskingPreference = refundRiskingPreference
        self.rawRefundType = rawRefundType
        self.storefront = storefront
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///A reason to request a refund.
    ///
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

    ///A Boolean value that indicates whether the App Store asks you for consumption data to help inform the refund decision.
    ///
    ///[refundRiskingPreference](https://developer.apple.com/documentation/advancedcommerceapi/refundriskingpreference)
    public var refundRiskingPreference: Bool

    ///[SubscriptionRevokeRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionrevokerequest)
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

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    public enum CodingKeys: CodingKey {
        case requestInfo
        case refundReason
        case refundRiskingPreference
        case refundType
        case storefront
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.rawRefundReason = try container.decode(String.self, forKey: .refundReason)
        self.refundRiskingPreference = try container.decode(Bool.self, forKey: .refundRiskingPreference)
        self.rawRefundType = try container.decode(String.self, forKey: .refundType)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encode(self.rawRefundReason, forKey: .refundReason)
        try container.encode(self.refundRiskingPreference, forKey: .refundRiskingPreference)
        try container.encode(self.rawRefundType, forKey: .refundType)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
    }
}
