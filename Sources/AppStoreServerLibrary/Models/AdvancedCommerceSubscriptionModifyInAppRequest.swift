// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request data your app provides to make changes to an auto-renewable subscription.
///
///[SubscriptionModifyInAppRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyinapprequest)
public struct AdvancedCommerceSubscriptionModifyInAppRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, retainBillingCycle: Bool, transactionId: String, addItems: [AdvancedCommerceSubscriptionModifyAddItem]? = nil, changeItems: [AdvancedCommerceSubscriptionModifyChangeItem]? = nil, currency: String? = nil, descriptors: AdvancedCommerceSubscriptionModifyDescriptors? = nil, periodChange: AdvancedCommerceSubscriptionModifyPeriodChange? = nil, removeItems: [AdvancedCommerceSubscriptionModifyRemoveItem]? = nil, storefront: String? = nil, taxCode: String? = nil) throws {
        self.requestInfo = requestInfo
        self.retainBillingCycle = retainBillingCycle
        self.transactionId = transactionId
        self.addItems = try addItems.map { try HelperValidationUtils.validateItems($0, fieldName: "addItems") }
        self.changeItems = try changeItems.map { try HelperValidationUtils.validateItems($0, fieldName: "changeItems") }
        self.currency = currency
        self.descriptors = descriptors
        self.periodChange = periodChange
        self.removeItems = try removeItems.map { try HelperValidationUtils.validateItems($0, fieldName: "removeItems") }
        self.storefront = storefront
        self.taxCode = taxCode
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[SubscriptionModifyInAppRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyinapprequest)
    private var operation: String {
        return "MODIFY_SUBSCRIPTION"
    }

    ///A number that represents the version of the data structure or Advanced Commerce API.
    ///
    ///[version](https://developer.apple.com/documentation/advancedcommerceapi/version)
    private var version: String {
        return "1"
    }

    ///The data your app provides to add items when it makes changes to an auto-renewable subscription.
    ///
    ///[SubscriptionModifyAddItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyadditem)
    public var addItems: [AdvancedCommerceSubscriptionModifyAddItem]?

    ///The data your app provides to change an item of an auto-renewable subscription.
    ///
    ///[SubscriptionModifyChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifychangeitem)
    public var changeItems: [AdvancedCommerceSubscriptionModifyChangeItem]?

    ///The three-letter ISO 4217 currency code for the price of a product.
    ///
    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String?

    ///The data your app provides to change the description and display name of an auto-renewable subscription.
    ///
    ///[SubscriptionModifyDescriptors](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifydescriptors)
    public var descriptors: AdvancedCommerceSubscriptionModifyDescriptors?

    ///The data your app provides to change the period of an auto-renewable subscription.
    ///
    ///[SubscriptionModifyPeriodChange](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyperiodchange)
    public var periodChange: AdvancedCommerceSubscriptionModifyPeriodChange?

    ///The data your app provides to remove an item from an auto-renewable subscription.
    ///
    ///[SubscriptionModifyRemoveItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyremoveitem)
    public var removeItems: [AdvancedCommerceSubscriptionModifyRemoveItem]?

    ///A Boolean value that determines whether to keep the existing billing cycle with the change you request.
    ///
    ///[retainBillingCycle](https://developer.apple.com/documentation/advancedcommerceapi/retainbillingcycle)
    public var retainBillingCycle: Bool

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///A tax code that applies to a SKU.
    ///
    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String?

    ///A unique identifier that the App Store generates for a transaction.
    ///
    ///[transactionId](https://developer.apple.com/documentation/advancedcommerceapi/transactionid)
    public var transactionId: String

    public enum CodingKeys: CodingKey {
        case requestInfo
        case operation
        case version
        case addItems
        case changeItems
        case currency
        case descriptors
        case periodChange
        case removeItems
        case retainBillingCycle
        case storefront
        case taxCode
        case transactionId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.addItems = try container.decodeIfPresent([AdvancedCommerceSubscriptionModifyAddItem].self, forKey: .addItems)
        self.changeItems = try container.decodeIfPresent([AdvancedCommerceSubscriptionModifyChangeItem].self, forKey: .changeItems)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.descriptors = try container.decodeIfPresent(AdvancedCommerceSubscriptionModifyDescriptors.self, forKey: .descriptors)
        self.periodChange = try container.decodeIfPresent(AdvancedCommerceSubscriptionModifyPeriodChange.self, forKey: .periodChange)
        self.removeItems = try container.decodeIfPresent([AdvancedCommerceSubscriptionModifyRemoveItem].self, forKey: .removeItems)
        self.retainBillingCycle = try container.decode(Bool.self, forKey: .retainBillingCycle)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.taxCode = try container.decodeIfPresent(String.self, forKey: .taxCode)
        self.transactionId = try container.decode(String.self, forKey: .transactionId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.version, forKey: .version)
        try container.encodeIfPresent(self.addItems.map { try HelperValidationUtils.validateItems($0, fieldName: "addItems") }, forKey: .addItems)
        try container.encodeIfPresent(self.changeItems.map { try HelperValidationUtils.validateItems($0, fieldName: "changeItems") }, forKey: .changeItems)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encodeIfPresent(self.descriptors, forKey: .descriptors)
        try container.encodeIfPresent(self.periodChange, forKey: .periodChange)
        try container.encodeIfPresent(self.removeItems.map { try HelperValidationUtils.validateItems($0, fieldName: "removeItems") }, forKey: .removeItems)
        try container.encode(self.retainBillingCycle, forKey: .retainBillingCycle)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encodeIfPresent(self.taxCode, forKey: .taxCode)
        try container.encode(self.transactionId, forKey: .transactionId)
    }
}
