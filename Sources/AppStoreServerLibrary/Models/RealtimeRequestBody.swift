// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The request body the App Store server sends to your Get Retention Message endpoint.
///
///[RealtimeRequestBody](https://developer.apple.com/documentation/retentionmessaging/realtimerequestbody)
public struct RealtimeRequestBody: Decodable, Encodable, Hashable, Sendable {

    public init(signedPayload: String? = nil) {
        self.signedPayload = signedPayload
    }

    ///The payload in JSON Web Signature (JWS) format, signed by the App Store.
    ///
    ///[signedPayload](https://developer.apple.com/documentation/retentionmessaging/signedpayload)
    public var signedPayload: String?
}
