// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The response body the App Store sends in a version 2 server notification.
///
///[responseBodyV2](https://developer.apple.com/documentation/appstoreservernotifications/responsebodyv2)
public struct ResponseBodyV2: Decodable, Encodable, Hashable, Sendable {

    public init(signedPayload: String? = nil) {
        self.signedPayload = signedPayload
    }

    ///The payload in JSON Web Signature (JWS) format, signed by the App Store.
    ///
    ///[signedPayload](https://developer.apple.com/documentation/appstoreservernotifications/signedpayload)
    public var signedPayload: String?
}
