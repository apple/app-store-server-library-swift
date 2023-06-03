// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains an array of signed JSON Web Signature (JWS) refunded transactions, and paging information.
///
///[RefundHistoryResponse](https://developer.apple.com/documentation/appstoreserverapi/refundhistoryresponse)
public struct RefundHistoryResponse: Decodable, Encodable, Hashable {
    ///A list of up to 20 JWS transactions, or an empty array if the customer hasn&#39;t received any refunds in your app. The transactions are sorted in ascending order by revocationDate.
    public var signedTransactions: [String]?
    
    ///A token you use in a query to request the next set of transactions for the customer.
    ///
    ///[revision](https://developer.apple.com/documentation/appstoreserverapi/revision)
    public var revision: String?
    
    ///A Boolean value indicating whether the App Store has more transaction data.
    ///
    ///[hasMore](https://developer.apple.com/documentation/appstoreserverapi/hasmore)
    public var hasMore: Bool?
}
