// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body for requesting a refund for a transaction.
///
///[RequestRefundRequest](https://developer.apple.com/documentation/advancedcommerceapi/requestrefundrequest)
public struct AdvancedCommerceRequestRefundRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, items: [AdvancedCommerceRequestRefundItem], refundRiskingPreference: Bool, currency: String? = nil, storefront: String? = nil) throws {
        self.requestInfo = requestInfo
        self.items = try HelperValidationUtils.validateItems(items)
        self.refundRiskingPreference = refundRiskingPreference
        self.currency = currency
        self.storefront = storefront
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///The currency of the transaction.
    ///
    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String?

    ///Information about the refund request for an item, such as its SKU, the refund amount, reason, and type.
    ///
    ///[RequestRefundItem](https://developer.apple.com/documentation/advancedcommerceapi/requestrefunditem)
    public var items: [AdvancedCommerceRequestRefundItem]

    ///A Boolean value that indicates whether the App Store asks you for consumption data to help inform the refund decision.
    ///
    ///[refundRiskingPreference](https://developer.apple.com/documentation/advancedcommerceapi/refundriskingpreference)
    public var refundRiskingPreference: Bool

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    public enum CodingKeys: CodingKey {
        case requestInfo
        case currency
        case items
        case refundRiskingPreference
        case storefront
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encode(HelperValidationUtils.validateItems(self.items), forKey: .items)
        try container.encode(self.refundRiskingPreference, forKey: .refundRiskingPreference)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
    }
}
