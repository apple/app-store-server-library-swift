// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body for requesting a refund for a transaction.
///
///[RequestRefundRequest](https://developer.apple.com/documentation/advancedcommerceapi/requestrefundrequest)
public struct AdvancedCommerceRequestRefundRequest: Decodable, Encodable, Hashable, Sendable {

    public init(items: [AdvancedCommerceRequestRefundItem], refundRiskingPreference: Bool, requestInfo: AdvancedCommerceRequestInfo, currency: String? = nil, storefront: String? = nil) throws {
        self.items = try HelperValidationUtils.validateItems(items)
        self.refundRiskingPreference = refundRiskingPreference
        self.requestInfo = requestInfo
        self.currency = currency
        self.storefront = storefront
    }

    ///The currency of the transaction.
    ///
    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String?

    ///[RequestRefundItem](https://developer.apple.com/documentation/advancedcommerceapi/requestrefunditem)
    public var items: [AdvancedCommerceRequestRefundItem]

    ///[RefundRiskingPreference](https://developer.apple.com/documentation/advancedcommerceapi/refundriskingpreference)
    public var refundRiskingPreference: Bool

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?
}
