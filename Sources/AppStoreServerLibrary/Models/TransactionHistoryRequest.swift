// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

public struct TransactionHistoryRequest: Hashable {

    public init(startDate: Date? = nil, endDate: Date? = nil, productIds: [String]? = nil, productTypes: [ProductType]? = nil, sort: Order? = nil, subscriptionGroupIdentifiers: [String]? = nil, inAppOwnershipType: InAppOwnershipType? = nil, revoked: Bool? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.productIds = productIds
        self.productTypes = productTypes
        self.sort = sort
        self.subscriptionGroupIdentifiers = subscriptionGroupIdentifiers
        self.inAppOwnershipType = inAppOwnershipType
        self.revoked = revoked
    }

    /// An optional start date of the timespan for the transaction history records you’re requesting. The startDate must precede the endDate if you specify both dates. To be included in results, the transaction’s purchaseDate must be equal to or greater than the startDate.
    ///
    ///[startDate](https://developer.apple.com/documentation/appstoreserverapi/startdate)
    public var startDate: Date?
    
    ///An optional end date of the timespan for the transaction history records you’re requesting. Choose an endDate that’s later than the startDate if you specify both dates. Using an endDate in the future is valid. To be included in results, the transaction’s purchaseDate must be less than the endDate.
    ///
    ///[endDate](https://developer.apple.com/documentation/appstoreserverapi/enddate)
    public var endDate: Date?
    
    ///An optional filter that indicates the product identifier to include in the transaction history. Your query may specify more than one productID.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productIds: [String]?
    
    ///An optional filter that indicates the product type to include in the transaction history. Your query may specify more than one productType.
    public var productTypes: [ProductType]?
    
    ///An optional sort order for the transaction history records. The response sorts the transaction records by their recently modified date. The default value is ASCENDING, so you receive the oldest records first.
    public var sort: Order?
    
    ///An optional filter that indicates the subscription group identifier to include in the transaction history. Your query may specify more than one subscriptionGroupIdentifier.
    ///
    ///[subscriptionGroupIdentifier](https://developer.apple.com/documentation/appstoreserverapi/subscriptiongroupidentifier)
    public var subscriptionGroupIdentifiers: [String]?
    
    ///An optional filter that limits the transaction history by the in-app ownership type.
    ///
    ///[inAppOwnershipType](https://developer.apple.com/documentation/appstoreserverapi/inappownershiptype)
    public var inAppOwnershipType: InAppOwnershipType?
    
    ///An optional Boolean value that indicates whether the response includes only revoked transactions when the value is true, or contains only nonrevoked transactions when the value is false. By default, the request doesn't include this parameter.
    public var revoked: Bool?

    public enum ProductType: String, Decodable, Encodable {
        case autoRenewable = "AUTO_RENEWABLE"
        case nonRenewable = "NON_RENEWABLE"
        case consumable = "CONSUMABLE"
        case nonConsumable = "NON_CONSUMABLE"
    }

    public enum Order: String, Decodable, Encodable {
        case ascending = "ASCENDING"
        case descending = "DESCENDING"
    }
}
