// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///An image identifier and state information for an image.
///
///[GetImageListResponseItem](https://developer.apple.com/documentation/retentionmessaging/getimagelistresponseitem)
public struct GetImageListResponseItem: Decodable, Encodable, Hashable, Sendable {

    public init(imageIdentifier: UUID? = nil, imageState: ImageState? = nil) {
        self.imageIdentifier = imageIdentifier
        self.rawImageState = imageState?.rawValue
    }

    public init(imageIdentifier: UUID? = nil, rawImageState: String? = nil) {
        self.imageIdentifier = imageIdentifier
        self.rawImageState = rawImageState
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

    public enum CodingKeys: CodingKey {
        case imageIdentifier
        case imageState
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageIdentifier = try container.decodeIfPresent(UUID.self, forKey: .imageIdentifier)
        self.rawImageState = try container.decodeIfPresent(String.self, forKey: .imageState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.imageIdentifier, forKey: .imageIdentifier)
        try container.encodeIfPresent(self.rawImageState, forKey: .imageState)
    }
}
