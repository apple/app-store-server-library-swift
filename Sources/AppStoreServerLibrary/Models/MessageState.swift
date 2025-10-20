// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The approval state of the message.
///
///[messageState](https://developer.apple.com/documentation/retentionmessaging/messagestate)
public enum MessageState: String, Decodable, Encodable, Hashable, Sendable {
    case pending = "PENDING"
    case approved = "APPROVED"
    case rejected = "REJECTED"
}
