// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The subscription details you provide to migrate a subscription from Apple In-App Purchase to the Advanced Commerce API, such as descriptors, items, storefront, and more.
///
///[SubscriptionMigrateRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigraterequest)
public struct AdvancedCommerceSubscriptionMigrateRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, descriptors: AdvancedCommerceSubscriptionMigrateDescriptors, items: [AdvancedCommerceSubscriptionMigrateItem], targetProductId: String, taxCode: String, renewalItems: [AdvancedCommerceSubscriptionMigrateRenewalItem]? = nil, storefront: String? = nil) throws {
        self.requestInfo = requestInfo
        self.descriptors = descriptors
        self.items = try HelperValidationUtils.validateItems(items)
        self.targetProductId = targetProductId
        self.taxCode = taxCode
        self.renewalItems = try renewalItems.map { try HelperValidationUtils.validateItems($0, fieldName: "renewalItems") }
        self.storefront = storefront
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///The description and display name of the subscription to migrate to that you manage.
    ///
    ///[SubscriptionMigrateDescriptors](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigratedescriptors)
    public var descriptors: AdvancedCommerceSubscriptionMigrateDescriptors

    ///An array of one or more SKUs, along with descriptions and display names, that are included in the subscription.
    ///
    ///[SubscriptionMigrateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigrateitem)
    public var items: [AdvancedCommerceSubscriptionMigrateItem]

    ///An optional array of subscription items that represents the items that renew at the next renewal period, if they differ from items.
    ///
    ///[SubscriptionMigrateRenewalItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigraterenewalitem)
    public var renewalItems: [AdvancedCommerceSubscriptionMigrateRenewalItem]?

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///Your generic product ID for an auto-renewable subscription.
    ///
    ///[targetProductId](https://developer.apple.com/documentation/advancedcommerceapi/targetproductid)
    public var targetProductId: String

    ///A tax code that applies to a SKU.
    ///
    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String

    public enum CodingKeys: CodingKey {
        case requestInfo
        case descriptors
        case items
        case renewalItems
        case storefront
        case targetProductId
        case taxCode
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encode(self.descriptors, forKey: .descriptors)
        try container.encode(HelperValidationUtils.validateItems(self.items), forKey: .items)
        try container.encodeIfPresent(self.renewalItems.map { try HelperValidationUtils.validateItems($0, fieldName: "renewalItems") }, forKey: .renewalItems)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encode(self.targetProductId, forKey: .targetProductId)
        try container.encode(self.taxCode, forKey: .taxCode)
    }
}
