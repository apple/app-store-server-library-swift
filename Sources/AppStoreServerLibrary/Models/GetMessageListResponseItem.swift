// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A message identifier and status information for a message.
///
///[GetMessageListResponseItem](https://developer.apple.com/documentation/retentionmessaging/getmessagelistresponseitem)
public struct GetMessageListResponseItem: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID? = nil, messageState: MessageState? = nil) {
        self.messageIdentifier = messageIdentifier
        self.rawMessageState = messageState?.rawValue
    }

    public init(messageIdentifier: UUID? = nil, rawMessageState: String? = nil) {
        self.messageIdentifier = messageIdentifier
        self.rawMessageState = rawMessageState
    }

    ///The identifier of the message.
    ///
    ///[messageIdentifier](https://developer.apple.com/documentation/retentionmessaging/messageidentifier)
    public var messageIdentifier: UUID?

    ///The current state of the message.
    ///
    ///[messageState](https://developer.apple.com/documentation/retentionmessaging/messageState)
    public var messageState: MessageState? {
        return rawMessageState.flatMap { MessageState(rawValue: $0) }
    }

    ///See ``messageState``
    public var rawMessageState: String?

    public enum CodingKeys: CodingKey {
        case messageIdentifier
        case messageState
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.messageIdentifier = try container.decodeIfPresent(UUID.self, forKey: .messageIdentifier)
        self.rawMessageState = try container.decodeIfPresent(String.self, forKey: .messageState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.messageIdentifier, forKey: .messageIdentifier)
        try container.encodeIfPresent(self.rawMessageState, forKey: .messageState)
    }
}
