// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The request body that contains an app account token value.
///
///[UpdateAppAccountTokenRequest](https://developer.apple.com/documentation/appstoreserverapi/updateappaccounttokenrequest)
public struct UpdateAppAccountTokenRequest: Decodable, Encodable, Hashable, Sendable {

    public init(appAccountToken: UUID) {
        self.appAccountToken = appAccountToken
    }

    ///A UUID value to associate with the transaction you indicate in the endpoint parameter.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID

    public enum CodingKeys: CodingKey {
        case appAccountToken
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.appAccountToken.uuidString.lowercased(), forKey: .appAccountToken)
    }
}
