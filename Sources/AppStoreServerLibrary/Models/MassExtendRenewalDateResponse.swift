// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that indicates the server successfully received the subscription-renewal-date extension request.
///
///[MassExtendRenewalDateResponse](https://developer.apple.com/documentation/appstoreserverapi/massextendrenewaldateresponse)
public struct MassExtendRenewalDateResponse: Decodable, Encodable, Hashable, Sendable {

    public init(requestIdentifier: String? = nil) {
        self.requestIdentifier = requestIdentifier
    }

    ///A string that contains a unique identifier you provide to track each subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?
}
