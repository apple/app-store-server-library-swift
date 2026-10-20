// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The size of an image.
///
///[imageSize](https://developer.apple.com/documentation/retentionmessaging/imagesize)
public enum ImageSize: String, Decodable, Encodable, Hashable, Sendable {
    ///3840 pixels in width, and from 160 to 2160 pixels in height, inclusive.
    case fullSize = "FULL_SIZE"

    ///1024 by 1024 pixels, to use for bullet points only.
    case bulletPoint = "BULLET_POINT"
}
