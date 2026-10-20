// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The request body that contains the default configuration information.
///
///[DefaultConfigurationRequest](https://developer.apple.com/documentation/retentionmessaging/defaultconfigurationrequest)
public struct DefaultConfigurationRequest: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID) {
        self.messageIdentifier = messageIdentifier
    }

    ///The message identifier of the message to configure as a default message.
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
