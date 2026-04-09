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
}
