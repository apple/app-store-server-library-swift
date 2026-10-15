// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains an array of signed JSON Web Signature (JWS) refunded transactions, and paging information.
///
///[RefundHistoryResponse](https://developer.apple.com/documentation/appstoreserverapi/refundhistoryresponse)
public struct RefundHistoryResponse: Decodable, Encodable, Hashable, Sendable {

    public init(hasMore: Bool? = nil, revision: String? = nil, signedTransactions: [String]? = nil) {
        self.hasMore = hasMore
        self.revision = revision
        self.signedTransactions = signedTransactions
    }

    ///A Boolean value that indicates whether the App Store has more transactions than it returns in signedTransactions.
    ///
    ///[hasMore](https://developer.apple.com/documentation/appstoreserverapi/hasmore)
    public var hasMore: Bool?

    ///A token you provide in a query to request the next set of transactions from the Get Refund History endpoint.
    ///
    ///[revision](https://developer.apple.com/documentation/appstoreserverapi/revision)
    public var revision: String?

    ///A list of up to 20 JWS transactions, or an empty array if the customer hasn’t received any refunds in your app.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactions: [String]?
}
