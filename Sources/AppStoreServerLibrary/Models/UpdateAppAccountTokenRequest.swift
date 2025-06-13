// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The request body that contains an app account token value.
///
///[UpdateAppAccountTokenRequest](https://developer.apple.com/documentation/appstoreserverapi/updateappaccounttokenrequest)
public struct UpdateAppAccountTokenRequest: Decodable, Encodable, Hashable, Sendable  {
    ///The UUID that an app optionally generates to map a customer’s in-app purchase with its resulting App Store transaction.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public let appAccountToken: UUID

    public init(appAccountToken: UUID) {
        self.appAccountToken = appAccountToken
    }

    public enum CodingKeys: CodingKey {
        case appAccountToken
    }

    public init (from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appAccountToken = try container.decode(UUID.self, forKey: .appAccountToken)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.appAccountToken, forKey: .appAccountToken)
    }
}