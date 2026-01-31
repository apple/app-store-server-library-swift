// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request data your app provides to make changes to an auto-renewable subscription.
///
///[SubscriptionModifyInAppRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyinapprequest)
public struct AdvancedCommerceSubscriptionModifyInAppRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, transactionId: String, retainBillingCycle: Bool, addItems: [AdvancedCommerceSubscriptionModifyAddItem]? = nil, changeItems: [AdvancedCommerceSubscriptionModifyChangeItem]? = nil, currency: String? = nil, descriptors: AdvancedCommerceSubscriptionModifyDescriptors? = nil, periodChange: AdvancedCommerceSubscriptionModifyPeriodChange? = nil, removeItems: [AdvancedCommerceSubscriptionModifyRemoveItem]? = nil, storefront: String? = nil, taxCode: String? = nil) throws {
        self.requestInfo = requestInfo
        self.transactionId = transactionId
        self.retainBillingCycle = retainBillingCycle
        self.addItems = try addItems.map { try AdvancedCommerceValidationUtils.validateItems($0) }
        self.changeItems = try changeItems.map { try AdvancedCommerceValidationUtils.validateItems($0) }
        self.currency = currency
        self.descriptors = descriptors
        self.periodChange = periodChange
        self.removeItems = try removeItems.map { try AdvancedCommerceValidationUtils.validateItems($0) }
        self.storefront = storefront
        self.taxCode = taxCode
    }

    ///[SubscriptionModifyAddItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyadditem)
    public var addItems: [AdvancedCommerceSubscriptionModifyAddItem]?

    ///[SubscriptionModifyChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifychangeitem)
    public var changeItems: [AdvancedCommerceSubscriptionModifyChangeItem]?

    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String?

    ///[SubscriptionModifyDescriptors](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifydescriptors)
    public var descriptors: AdvancedCommerceSubscriptionModifyDescriptors?

    private var operation: String {
        return "MODIFY_SUBSCRIPTION"
    }

    ///[SubscriptionModifyPeriodChange](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyperiodchange)
    public var periodChange: AdvancedCommerceSubscriptionModifyPeriodChange?

    ///[SubscriptionModifyRemoveItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifyremoveitem)
    public var removeItems: [AdvancedCommerceSubscriptionModifyRemoveItem]?

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[retainBillingCycle](https://developer.apple.com/documentation/advancedcommerceapi/retainbillingcycle)
    public var retainBillingCycle: Bool

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargecreaterequest)
    public var storefront: String?

    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String?

    ///[transactionId](https://developer.apple.com/documentation/advancedcommerceapi/transactionid)
    public var transactionId: String

    private var version: String {
        return "1"
    }

    public enum CodingKeys: String, CodingKey {
        case addItems
        case changeItems
        case currency
        case descriptors
        case operation
        case periodChange
        case removeItems
        case requestInfo
        case retainBillingCycle
        case storefront
        case taxCode
        case transactionId
        case version
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.addItems = try container.decodeIfPresent([AdvancedCommerceSubscriptionModifyAddItem].self, forKey: .addItems)
        self.changeItems = try container.decodeIfPresent([AdvancedCommerceSubscriptionModifyChangeItem].self, forKey: .changeItems)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.descriptors = try container.decodeIfPresent(AdvancedCommerceSubscriptionModifyDescriptors.self, forKey: .descriptors)
        self.periodChange = try container.decodeIfPresent(AdvancedCommerceSubscriptionModifyPeriodChange.self, forKey: .periodChange)
        self.removeItems = try container.decodeIfPresent([AdvancedCommerceSubscriptionModifyRemoveItem].self, forKey: .removeItems)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.retainBillingCycle = try container.decode(Bool.self, forKey: .retainBillingCycle)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.taxCode = try container.decodeIfPresent(String.self, forKey: .taxCode)
        self.transactionId = try container.decode(String.self, forKey: .transactionId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.addItems, forKey: .addItems)
        try container.encodeIfPresent(self.changeItems, forKey: .changeItems)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encodeIfPresent(self.descriptors, forKey: .descriptors)
        try container.encode(self.operation, forKey: .operation)
        try container.encodeIfPresent(self.periodChange, forKey: .periodChange)
        try container.encodeIfPresent(self.removeItems, forKey: .removeItems)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encode(self.retainBillingCycle, forKey: .retainBillingCycle)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encodeIfPresent(self.taxCode, forKey: .taxCode)
        try container.encode(self.transactionId, forKey: .transactionId)
        try container.encode(self.version, forKey: .version)
    }
}
