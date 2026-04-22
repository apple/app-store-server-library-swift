// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request body you provide to change the metadata of a subscription.
///
///[SubscriptionChangeMetadataRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadatarequest)
public struct AdvancedCommerceSubscriptionChangeMetadataRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, descriptors: AdvancedCommerceSubscriptionChangeMetadataDescriptors? = nil, items: [AdvancedCommerceSubscriptionChangeMetadataItem]? = nil, storefront: String? = nil, taxCode: String? = nil) {
        self.requestInfo = requestInfo
        self.descriptors = descriptors
        self.items = items
        self.storefront = storefront
        self.taxCode = taxCode
    }

    ///[SubscriptionChangeMetadataDescriptors](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadatadescriptors)
    public var descriptors: AdvancedCommerceSubscriptionChangeMetadataDescriptors?

    ///[SubscriptionChangeMetadataItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadataitem)
    public var items: [AdvancedCommerceSubscriptionChangeMetadataItem]?

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String?
}
