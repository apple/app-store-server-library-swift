// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body for turning off automatic renewal of a subscription.
///
///[SubscriptionCancelRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncancelrequest)
public struct AdvancedCommerceSubscriptionCancelRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, storefront: String? = nil) {
        self.requestInfo = requestInfo
        self.storefront = storefront
    }

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?
}
