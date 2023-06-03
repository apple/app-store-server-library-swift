// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The most recent App Store-signed transaction information and App Store-signed renewal information for an auto-renewable subscription.
///
///[lastTransactionsItem](https://developer.apple.com/documentation/appstoreserverapi/lasttransactionsitem)
public struct LastTransactionsItem: Decodable, Encodable, Hashable {
    ///The status of the auto-renewable subscription.
    ///
    ///[status](https://developer.apple.com/documentation/appstoreserverapi/status)
    public var status: Status?

    ///The original transaction identifier of a purchase.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?

    ///Transaction information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String?

    ///Subscription renewal information, signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    public var signedRenewalInfo: String?
}
