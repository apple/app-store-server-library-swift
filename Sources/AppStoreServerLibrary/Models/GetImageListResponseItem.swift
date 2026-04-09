// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///An image identifier and state information for an image.
///
///[GetImageListResponseItem](https://developer.apple.com/documentation/retentionmessaging/getimagelistresponseitem)
public struct GetImageListResponseItem: Decodable, Encodable, Hashable, Sendable {

    public init(imageIdentifier: UUID? = nil, imageState: ImageState? = nil, imageSize: ImageSize? = nil) {
        self.init(imageIdentifier: imageIdentifier, rawImageState: imageState?.rawValue, rawImageSize: imageSize?.rawValue)
    }

    public init(imageIdentifier: UUID? = nil, rawImageState: String? = nil, rawImageSize: String? = nil) {
        self.imageIdentifier = imageIdentifier
        self.rawImageState = rawImageState
        self.rawImageSize = rawImageSize
    }

    ///The identifier of the image.
    ///
    ///[imageIdentifier](https://developer.apple.com/documentation/retentionmessaging/imageidentifier)
    public var imageIdentifier: UUID?

    ///The current state of the image.
    ///
    ///[imageState](https://developer.apple.com/documentation/retentionmessaging/imagestate)
    public var imageState: ImageState? {
        return rawImageState.flatMap { ImageState(rawValue: $0) }
    }

    ///See ``imageState``
    public var rawImageState: String?

    ///The size of the image.
    ///
    ///[imageSize](https://developer.apple.com/documentation/retentionmessaging/imagesize)
    public var imageSize: ImageSize? {
        return rawImageSize.flatMap { ImageSize(rawValue: $0) }
    }

    ///See ``imageSize``
    public var rawImageSize: String?

    public enum CodingKeys: CodingKey {
        case imageIdentifier
        case imageState
        case imageSize
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageIdentifier = try container.decodeIfPresent(UUID.self, forKey: .imageIdentifier)
        self.rawImageState = try container.decodeIfPresent(String.self, forKey: .imageState)
        self.rawImageSize = try container.decodeIfPresent(String.self, forKey: .imageSize)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.imageIdentifier, forKey: .imageIdentifier)
        try container.encodeIfPresent(self.rawImageState, forKey: .imageState)
        try container.encodeIfPresent(self.rawImageSize, forKey: .imageSize)
    }
}
