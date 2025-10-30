// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

 ///A response that contains signed app transaction information for a customer.
 ///
 ///[AppTransactionInfoResponse](https://developer.apple.com/documentation/appstoreserverapi/apptransactioninforesponse)
 public struct AppTransactionInfoResponse: Decodable, Encodable, Hashable, Sendable {

     public init(signedAppTransactionInfo: String? = nil) {
         self.signedAppTransactionInfo = signedAppTransactionInfo
     }

     ///A customer’s app transaction information, signed by Apple, in JSON Web Signature (JWS) format.
     ///
     ///[JWSAppTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwsapptransaction)
     public var signedAppTransactionInfo: String?
 }