// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A message identifier you provide in a real-time response to your Get Retention Message endpoint.
///
///[message](https://developer.apple.com/documentation/retentionmessaging/message)
public struct Message: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID? = nil) {
        self.messageIdentifier = messageIdentifier
    }

    ///The identifier of the message to display to the customer.
    ///
    ///[messageIdentifier](https://developer.apple.com/documentation/retentionmessaging/messageidentifier)
    public var messageIdentifier: UUID?
}
