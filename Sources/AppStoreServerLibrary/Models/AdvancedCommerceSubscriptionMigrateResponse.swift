// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A response that contains signed renewal and transaction information after a subscription successfully migrates to the Advanced Commerce API.
///
///[SubscriptionMigrateResponse](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigrateresponse)
public struct AdvancedCommerceSubscriptionMigrateResponse: Decodable, Encodable, Hashable, Sendable {

    public init(signedRenewalInfo: String, signedTransactionInfo: String) {
        self.signedRenewalInfo = signedRenewalInfo
        self.signedTransactionInfo = signedTransactionInfo
    }

    ///Subscription renewal information signed by the App Store, in JSON Web Signature (JWS) format, for the migrated subscription.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    public var signedRenewalInfo: String

    ///Transaction information signed by the App Store, in JSON Web Signature (JWS) Compact Serialization format, for the migrated subscription.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String
}
