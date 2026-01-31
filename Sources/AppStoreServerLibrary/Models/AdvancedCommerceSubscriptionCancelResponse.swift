// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The response body for a successful subscription cancellation.
///
///[SubscriptionCancelResponse](https://developer.apple.com/documentation/advancedcommerceapi/subscriptioncancelresponse)
public struct AdvancedCommerceSubscriptionCancelResponse: Decodable, Encodable, Hashable, Sendable {

    public init(signedRenewalInfo: String, signedTransactionInfo: String) {
        self.signedRenewalInfo = signedRenewalInfo
        self.signedTransactionInfo = signedTransactionInfo
    }

    ///Subscription renewal information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    public var signedRenewalInfo: String

    ///Transaction information signed by the App Store, in JWS Compact Serialization format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String
}
