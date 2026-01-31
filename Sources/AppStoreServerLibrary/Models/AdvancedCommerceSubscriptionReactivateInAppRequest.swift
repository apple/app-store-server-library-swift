// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request your app provides to reactivate a subscription that has automatic renewal turned off.
///
///[SubscriptionReactivateInAppRequest](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionreactivateinapprequest)
public struct AdvancedCommerceSubscriptionReactivateInAppRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, transactionId: String, items: [AdvancedCommerceSubscriptionReactivateItem]? = nil, storefront: String? = nil) {
        self.requestInfo = requestInfo
        self.transactionId = transactionId
        self.items = items
        self.storefront = storefront
    }

    ///[SubscriptionReactivateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionreactivateitem)
    public var items: [AdvancedCommerceSubscriptionReactivateItem]?

    private var operation: String {
        return "REACTIVATE_SUBSCRIPTION"
    }

    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///[transactionId](https://developer.apple.com/documentation/appstoreserverapi/transactionid)
    public var transactionId: String

    private var version: String {
        return "1"
    }

    public enum CodingKeys: String, CodingKey {
        case items
        case operation
        case requestInfo
        case storefront
        case transactionId
        case version
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decodeIfPresent([AdvancedCommerceSubscriptionReactivateItem].self, forKey: .items)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.transactionId = try container.decode(String.self, forKey: .transactionId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.items, forKey: .items)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encode(self.transactionId, forKey: .transactionId)
        try container.encode(self.version, forKey: .version)
    }
}
