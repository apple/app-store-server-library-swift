// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The position where the header text appears in a message.
///
///[headerPosition](https://developer.apple.com/documentation/retentionmessaging/headerposition)
public enum HeaderPosition: String, Decodable, Encodable, Hashable, Sendable {
    ///Position the header text above the message body.
    case aboveBody = "ABOVE_BODY"

    ///Position the header text above the image.
    case aboveImage = "ABOVE_IMAGE"
}
