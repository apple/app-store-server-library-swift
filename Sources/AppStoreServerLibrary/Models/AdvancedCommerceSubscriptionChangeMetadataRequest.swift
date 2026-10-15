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

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///The subscription metadata to change, specifically the description and display name.
    ///
    ///[SubscriptionChangeMetadataDescriptors](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadatadescriptors)
    public var descriptors: AdvancedCommerceSubscriptionChangeMetadataDescriptors?

    ///The metadata to change for an item, specifically its SKU, description, and display name.
    ///
    ///[SubscriptionChangeMetadataItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadataitem)
    public var items: [AdvancedCommerceSubscriptionChangeMetadataItem]?

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///A tax code that applies to a SKU.
    ///
    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String?

    public enum CodingKeys: CodingKey {
        case requestInfo
        case descriptors
        case items
        case storefront
        case taxCode
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encodeIfPresent(self.descriptors, forKey: .descriptors)
        try container.encodeIfPresent(self.items.map { try HelperValidationUtils.validateItems($0) }, forKey: .items)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encodeIfPresent(self.taxCode, forKey: .taxCode)
    }
}
