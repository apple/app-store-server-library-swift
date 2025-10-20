// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A response that contains status information for all messages.
///
///[GetMessageListResponse](https://developer.apple.com/documentation/retentionmessaging/getmessagelistresponse)
public struct GetMessageListResponse: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifiers: [GetMessageListResponseItem]? = nil) {
        self.messageIdentifiers = messageIdentifiers
    }

    ///An array of all message identifiers and their message state.
    ///
    ///[messageIdentifiers](https://developer.apple.com/documentation/retentionmessaging/getmessagelistresponseitem)
    public var messageIdentifiers: [GetMessageListResponseItem]?
}
