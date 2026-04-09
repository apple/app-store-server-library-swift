// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The position where the header text appears in a message.
///
///[headerPosition](https://developer.apple.com/documentation/retentionmessaging/headerposition)
public enum HeaderPosition: String, Decodable, Encodable, Hashable, Sendable {
    case aboveBody = "ABOVE_BODY"
    case aboveImage = "ABOVE_IMAGE"
}
