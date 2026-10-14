// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body for turning off automatic renewal of a subscription.
///
///[SubscriptionCancelRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncancelrequest)
public struct AdvancedCommerceSubscriptionCancelRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, storefront: String? = nil) {
        self.requestInfo = requestInfo
        self.storefront = storefront
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?
}
