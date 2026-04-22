// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request data your app provides when a customer purchases an auto-renewable subscription.
///
///[SubscriptionCreateRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncreaterequest)
public struct AdvancedCommerceSubscriptionCreateRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(currency: String, descriptors: AdvancedCommerceDescriptors, items: [AdvancedCommerceSubscriptionCreateItem], period: AdvancedCommercePeriod, requestInfo: AdvancedCommerceRequestInfo, taxCode: String, previousTransactionId: String? = nil, storefront: String? = nil) throws {
        self.currency = currency
        self.descriptors = descriptors
        self.items = try AdvancedCommerceValidationUtils.validateItems(items)
        self.rawPeriod = period.rawValue
        self.requestInfo = requestInfo
        self.taxCode = taxCode
        self.previousTransactionId = previousTransactionId
        self.storefront = storefront
    }

    public init(currency: String, descriptors: AdvancedCommerceDescriptors, items: [AdvancedCommerceSubscriptionCreateItem], rawPeriod: String, requestInfo: AdvancedCommerceRequestInfo, taxCode: String, previousTransactionId: String? = nil, storefront: String? = nil) throws {
        self.currency = currency
        self.descriptors = descriptors
        self.items = try AdvancedCommerceValidationUtils.validateItems(items)
        self.rawPeriod = rawPeriod
        self.requestInfo = requestInfo
        self.taxCode = taxCode
        self.previousTransactionId = previousTransactionId
        self.storefront = storefront
    }

    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String

    ///[descriptors](https://developer.apple.com/documentation/advancedcommerceapi/descriptors)
    public var descriptors: AdvancedCommerceDescriptors

    ///[SubscriptionCreateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncreateitem)
    public var items: [AdvancedCommerceSubscriptionCreateItem]

    private var operation: String {
        return "CREATE_SUBSCRIPTION"
    }

    ///[period](https://developer.apple.com/documentation/advancedcommerceapi/period)
    public var period: AdvancedCommercePeriod? {
        get {
            return AdvancedCommercePeriod(rawValue: rawPeriod)
        }
        set {
            self.rawPeriod = newValue.map { $0.rawValue } ?? rawPeriod
        }
    }

    ///See ``period``
    public var rawPeriod: String

    ///[transactionId](https://developer.apple.com/documentation/advancedcommerceapi/transactionid)
    public var previousTransactionId: String?

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxCode)
    public var taxCode: String

    ///The version of this request.
    private var version: String {
        return "1"
    }

    public enum CodingKeys: CodingKey {
        case currency
        case descriptors
        case items
        case operation
        case period
        case previousTransactionId
        case requestInfo
        case storefront
        case taxCode
        case version
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.descriptors = try container.decode(AdvancedCommerceDescriptors.self, forKey: .descriptors)
        self.items = try container.decode([AdvancedCommerceSubscriptionCreateItem].self, forKey: .items)
        self.rawPeriod = try container.decode(String.self, forKey: .period)
        self.previousTransactionId = try container.decodeIfPresent(String.self, forKey: .previousTransactionId)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.taxCode = try container.decode(String.self, forKey: .taxCode)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.currency, forKey: .currency)
        try container.encode(self.descriptors, forKey: .descriptors)
        try container.encode(self.items, forKey: .items)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.rawPeriod, forKey: .period)
        try container.encodeIfPresent(self.previousTransactionId, forKey: .previousTransactionId)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encode(self.taxCode, forKey: .taxCode)
        try container.encode(self.version, forKey: .version)
    }
}
