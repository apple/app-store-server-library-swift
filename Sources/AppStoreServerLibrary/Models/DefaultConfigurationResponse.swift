// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The response body that contains the default configuration information.
///
///[DefaultConfigurationResponse](https://developer.apple.com/documentation/retentionmessaging/defaultconfigurationresponse)
public struct DefaultConfigurationResponse: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID) {
        self.messageIdentifier = messageIdentifier
    }

    ///The message identifier of the retention message you configured as a default.
    ///
    ///[messageIdentifier](https://developer.apple.com/documentation/retentionmessaging/messageidentifier)
    public var messageIdentifier: UUID

    public enum CodingKeys: CodingKey {
        case messageIdentifier
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.messageIdentifier.uuidString.lowercased(), forKey: .messageIdentifier)
    }
}
