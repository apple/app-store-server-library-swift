// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The approval state of an image.
///
///[imageState](https://developer.apple.com/documentation/retentionmessaging/imagestate)
public enum ImageState: String, Decodable, Encodable, Hashable, Sendable {
    ///The image is awaiting approval.
    case pending = "PENDING"

    ///The image is approved.
    case approved = "APPROVED"

    ///The image is rejected.
    case rejected = "REJECTED"
}
