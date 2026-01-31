// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The subscription details you provide to migrate a subscription from In-App Purchase to the Advanced Commerce API, such as descriptors, items, storefront, and more.
///
///[SubscriptionMigrateRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigraterequest)
public struct AdvancedCommerceSubscriptionMigrateRequest: Decodable, Encodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, descriptors: AdvancedCommerceSubscriptionMigrateDescriptors, items: [AdvancedCommerceSubscriptionMigrateItem], targetProductId: String, taxCode: String, renewalItems: [AdvancedCommerceSubscriptionMigrateRenewalItem]? = nil, storefront: String? = nil) throws {
        self.requestInfo = requestInfo
        self.descriptors = descriptors
        self.items = try AdvancedCommerceValidationUtils.validateItems(items)
        self.targetProductId = targetProductId
        self.taxCode = taxCode
        self.renewalItems = try renewalItems.map { try AdvancedCommerceValidationUtils.validateItems($0) }
        self.storefront = storefront
    }

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

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///Your generic product ID for an auto-renewable subscription.
    ///
    ///[targetProductId](https://developer.apple.com/documentation/advancedcommerceapi/targetproductid)
    public var targetProductId: String

    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String
}
