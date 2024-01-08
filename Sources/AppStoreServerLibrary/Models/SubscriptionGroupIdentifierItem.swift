// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///Information for auto-renewable subscriptions, including signed transaction information and signed renewal information, for one subscription group.
///
///[SubscriptionGroupIdentifierItem](https://developer.apple.com/documentation/appstoreserverapi/subscriptiongroupidentifieritem)
public struct SubscriptionGroupIdentifierItem: Decodable, Encodable, Hashable {

    public init(subscriptionGroupIdentifier: String? = nil, lastTransactions: [LastTransactionsItem]? = nil) {
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.lastTransactions = lastTransactions
    }

    ///The identifier of the subscription group that the subscription belongs to.
    ///
    ///[subscriptionGroupIdentifier](https://developer.apple.com/documentation/appstoreserverapi/subscriptiongroupidentifier)
    public var subscriptionGroupIdentifier: String?
    
    ///An array of the most recent App Store-signed transaction information and App Store-signed renewal information for all auto-renewable subscriptions in the subscription group.
    public var lastTransactions: [LastTransactionsItem]?
}
