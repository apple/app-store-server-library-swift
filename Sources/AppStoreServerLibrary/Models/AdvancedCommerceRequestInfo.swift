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
    public var appAccountToken: UUID?

    ///The value of the advancedCommerceConsistencyToken that you receive in the JWSRenewalInfo renewal information for a subscription. Don't generate this value.
    ///
    ///[advancedCommerceConsistencyToken](https://developer.apple.com/documentation/AppStoreServerAPI/advancedCommerceConsistencyToken)
    public var consistencyToken: String?

    ///A UUID that you provide to uniquely identify each request. If the request times out, you can use the same requestReferenceId value to retry the request. Otherwise, provide a unique value.
    public var requestReferenceId: UUID
}
