// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request data your app provides when a customer purchases an auto-renewable subscription.
///
///[SubscriptionCreateRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncreaterequest)
public struct AdvancedCommerceSubscriptionCreateRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, currency: String, descriptors: AdvancedCommerceDescriptors, items: [AdvancedCommerceSubscriptionCreateItem], period: AdvancedCommercePeriod, taxCode: String, previousTransactionId: String? = nil, storefront: String? = nil) throws {
        try self.init(requestInfo: requestInfo, currency: currency, descriptors: descriptors, items: items, rawPeriod: period.rawValue, taxCode: taxCode, previousTransactionId: previousTransactionId, storefront: storefront)
    }

    public init(requestInfo: AdvancedCommerceRequestInfo, currency: String, descriptors: AdvancedCommerceDescriptors, items: [AdvancedCommerceSubscriptionCreateItem], rawPeriod: String, taxCode: String, previousTransactionId: String? = nil, storefront: String? = nil) throws {
        self.requestInfo = requestInfo
        self.currency = currency
        self.descriptors = descriptors
        self.items = try HelperValidationUtils.validateItems(items)
        self.rawPeriod = rawPeriod
        self.taxCode = taxCode
        self.previousTransactionId = previousTransactionId
        self.storefront = storefront
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[SubscriptionCreateRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncreaterequest)
    private var operation: String {
        return "CREATE_SUBSCRIPTION"
    }

    ///A number that represents the version of the data structure or Advanced Commerce API.
    ///
    ///[version](https://developer.apple.com/documentation/advancedcommerceapi/version)
    private var version: String {
        return "1"
    }

    ///The three-letter ISO 4217 currency code for the price of a product.
    ///
    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String

    ///The display name and description of a subscription product.
    ///
    ///[Descriptors](https://developer.apple.com/documentation/advancedcommerceapi/descriptors)
    public var descriptors: AdvancedCommerceDescriptors

    ///The data that describes a subscription item.
    ///
    ///[SubscriptionCreateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncreateitem)
    public var items: [AdvancedCommerceSubscriptionCreateItem]

    ///The duration of a single cycle of an auto-renewable subscription.
    ///
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

    ///A unique identifier that the App Store generates for a transaction.
    ///
    ///[transactionId](https://developer.apple.com/documentation/advancedcommerceapi/transactionid)
    public var previousTransactionId: String?

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///A tax code that applies to a SKU.
    ///
    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String

    public enum CodingKeys: CodingKey {
        case requestInfo
        case operation
        case version
        case currency
        case descriptors
        case items
        case period
        case previousTransactionId
        case storefront
        case taxCode
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.descriptors = try container.decode(AdvancedCommerceDescriptors.self, forKey: .descriptors)
        self.items = try container.decode([AdvancedCommerceSubscriptionCreateItem].self, forKey: .items)
        self.rawPeriod = try container.decode(String.self, forKey: .period)
        self.previousTransactionId = try container.decodeIfPresent(String.self, forKey: .previousTransactionId)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.taxCode = try container.decode(String.self, forKey: .taxCode)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.version, forKey: .version)
        try container.encode(self.currency, forKey: .currency)
        try container.encode(self.descriptors, forKey: .descriptors)
        try container.encode(HelperValidationUtils.validateItems(self.items), forKey: .items)
        try container.encode(self.rawPeriod, forKey: .period)
        try container.encodeIfPresent(self.previousTransactionId, forKey: .previousTransactionId)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encode(self.taxCode, forKey: .taxCode)
    }
}
