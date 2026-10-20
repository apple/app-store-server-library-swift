// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The response body for a transaction refund request.
///
///[RequestRefundResponse](https://developer.apple.com/documentation/advancedcommerceapi/requestrefundresponse)
public struct AdvancedCommerceRequestRefundResponse: Decodable, Encodable, Hashable, Sendable {

    public init(signedTransactionInfo: String, signedRenewalInfo: String? = nil) {
        self.signedTransactionInfo = signedTransactionInfo
        self.signedRenewalInfo = signedRenewalInfo
    }

    ///Subscription renewal information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/advancedcommerceapi/jwsrenewalinfo)
    public var signedRenewalInfo: String?

    ///Transaction information signed by the App Store, in JWS Compact Serialization format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/advancedcommerceapi/jwstransaction)
    public var signedTransactionInfo: String
}
