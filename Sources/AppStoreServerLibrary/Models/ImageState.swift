// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The approval state of an image.
///
///[imageState](https://developer.apple.com/documentation/retentionmessaging/imagestate)
public enum ImageState: String, Decodable, Encodable, Hashable, Sendable {
    case pending = "PENDING"
    case approved = "APPROVED"
    case rejected = "REJECTED"
}
