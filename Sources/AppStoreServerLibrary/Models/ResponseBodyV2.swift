// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The response body the App Store sends in a version 2 server notification.
///
///[responseBodyV2](https://developer.apple.com/documentation/appstoreservernotifications/responsebodyv2)
public struct ResponseBodyV2: Decodable, Encodable, Hashable {

    public init(signedPayload: String? = nil) {
        self.signedPayload = signedPayload
    }

    ///A cryptographically signed payload, in JSON Web Signature (JWS) format, containing the response body for a version 2 notification.
    ///
    ///[signedPayload](https://developer.apple.com/documentation/appstoreservernotifications/signedpayload)
    public var signedPayload: String?
}
