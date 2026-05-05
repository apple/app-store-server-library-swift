// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body you use to change the price of an auto-renewable subscription.
///
///[SubscriptionPriceChangeRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionpricechangerequest)
public struct AdvancedCommerceSubscriptionPriceChangeRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, items: [AdvancedCommerceSubscriptionPriceChangeItem], currency: String? = nil, storefront: String? = nil) throws {
        self.requestInfo = requestInfo
        self.items = try HelperValidationUtils.validateItems(items)
        self.currency = currency
        self.storefront = storefront
    }

    ///The currency of the prices.
    ///
    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String?

    ///An array that contains one or more SKUs and the changed price for each SKU.
    ///
    ///[SubscriptionPriceChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionpricechangeitem)
    public var items: [AdvancedCommerceSubscriptionPriceChangeItem]

    ///Metadata that identifies the request.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///The App Store storefront of the subscription.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?
}
