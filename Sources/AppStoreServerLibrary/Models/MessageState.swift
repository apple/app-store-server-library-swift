// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The approval state of the message.
///
///[messageState](https://developer.apple.com/documentation/retentionmessaging/messagestate)
public enum MessageState: String, Decodable, Encodable, Hashable, Sendable {
    ///The message is awaiting approval.
    case pending = "PENDING"

    ///The message is approved.
    case approved = "APPROVED"

    ///The message is rejected.
    case rejected = "REJECTED"
}
