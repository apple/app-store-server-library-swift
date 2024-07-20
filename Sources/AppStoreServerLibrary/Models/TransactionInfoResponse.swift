// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains signed transaction information for a single transaction.
///
///[TransactionInfoResponse](https://developer.apple.com/documentation/appstoreserverapi/transactioninforesponse)
public struct TransactionInfoResponse: Decodable, Encodable, Hashable, Sendable {

    public init(signedTransactionInfo: String? = nil) {
        self.signedTransactionInfo = signedTransactionInfo
    }

    ///A customer’s in-app purchase transaction, signed by Apple, in JSON Web Signature (JWS) format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String?
}

