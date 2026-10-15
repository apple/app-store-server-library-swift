// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The metadata to include in server requests.
///
///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
public struct AdvancedCommerceRequestInfo: Decodable, Encodable, Hashable, Sendable {

    public init(requestReferenceId: UUID, appAccountToken: UUID? = nil, consistencyToken: String? = nil) {
        self.requestReferenceId = requestReferenceId
        self.appAccountToken = appAccountToken
        self.consistencyToken = consistencyToken
    }

    ///A UUID that represents an app account token, to associate with the transaction in the request.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var appAccountToken: UUID?

    ///The value of the advancedCommerceConsistencyToken that you receive in the JWSRenewalInfo renewal information for a subscription.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var consistencyToken: String?

    ///A UUID that you provide to uniquely identify each request.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestReferenceId: UUID

    public enum CodingKeys: CodingKey {
        case appAccountToken
        case consistencyToken
        case requestReferenceId
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.appAccountToken?.uuidString.lowercased(), forKey: .appAccountToken)
        try container.encodeIfPresent(self.consistencyToken, forKey: .consistencyToken)
        try container.encode(self.requestReferenceId.uuidString.lowercased(), forKey: .requestReferenceId)
    }
}
