// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The size of an image.
///
///[imageSize](https://developer.apple.com/documentation/retentionmessaging/imagesize)
public enum ImageSize: String, Decodable, Encodable, Hashable, Sendable {
    case fullSize = "FULL_SIZE"
    case bulletPoint = "BULLET_POINT"
}
