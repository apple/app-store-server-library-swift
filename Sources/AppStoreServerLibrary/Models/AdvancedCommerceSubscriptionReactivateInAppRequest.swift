// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request your app provides to reactivate a subscription that has automatic renewal turned off.
///
///[SubscriptionReactivateInAppRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionreactivateinapprequest)
public struct AdvancedCommerceSubscriptionReactivateInAppRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, transactionId: String, items: [AdvancedCommerceSubscriptionReactivateItem]? = nil, storefront: String? = nil) throws {
        self.requestInfo = requestInfo
        self.transactionId = transactionId
        self.items = try items.map { try HelperValidationUtils.validateItems($0) }
        self.storefront = storefront
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[SubscriptionReactivateInAppRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionreactivateinapprequest)
    private var operation: String {
        return "REACTIVATE_SUBSCRIPTION"
    }

    ///A number that represents the version of the data structure or Advanced Commerce API.
    ///
    ///[version](https://developer.apple.com/documentation/advancedcommerceapi/version)
    private var version: String {
        return "1"
    }

    ///An item in a subscription to reactivate.
    ///
    ///[SubscriptionReactivateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionreactivateitem)
    public var items: [AdvancedCommerceSubscriptionReactivateItem]?

    ///A three-letter code that represents the country or region associated with the App Store storefront.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///A unique identifier that the App Store generates for a transaction.
    ///
    ///[transactionId](https://developer.apple.com/documentation/advancedcommerceapi/transactionid)
    public var transactionId: String

    public enum CodingKeys: CodingKey {
        case requestInfo
        case operation
        case version
        case items
        case storefront
        case transactionId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.items = try container.decodeIfPresent([AdvancedCommerceSubscriptionReactivateItem].self, forKey: .items)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.transactionId = try container.decode(String.self, forKey: .transactionId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.version, forKey: .version)
        try container.encodeIfPresent(self.items.map { try HelperValidationUtils.validateItems($0) }, forKey: .items)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encode(self.transactionId, forKey: .transactionId)
    }
}
