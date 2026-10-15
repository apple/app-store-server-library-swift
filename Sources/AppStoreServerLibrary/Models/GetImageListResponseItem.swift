// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///An image identifier and state information for an image.
///
///[GetImageListResponseItem](https://developer.apple.com/documentation/retentionmessaging/getimagelistresponseitem)
public struct GetImageListResponseItem: Decodable, Encodable, Hashable, Sendable {

    public init(imageIdentifier: UUID? = nil, imageSize: ImageSize? = nil, imageState: ImageState? = nil) {
        self.init(imageIdentifier: imageIdentifier, rawImageSize: imageSize?.rawValue, rawImageState: imageState?.rawValue)
    }

    @_disfavoredOverload
    public init(imageIdentifier: UUID? = nil, rawImageSize: String? = nil, rawImageState: String? = nil) {
        self.imageIdentifier = imageIdentifier
        self.rawImageSize = rawImageSize
        self.rawImageState = rawImageState
    }

    ///The identifier of the image.
    ///
    ///[imageIdentifier](https://developer.apple.com/documentation/retentionmessaging/imageidentifier)
    public var imageIdentifier: UUID?

    ///The size of the image.
    ///
    ///[imageSize](https://developer.apple.com/documentation/retentionmessaging/imagesize)
    public var imageSize: ImageSize? {
        get {
            return rawImageSize.flatMap { ImageSize(rawValue: $0) }
        }
        set {
            self.rawImageSize = newValue.map { $0.rawValue }
        }
    }

    ///See ``imageSize``
    public var rawImageSize: String?

    ///The current state of the image.
    ///
    ///[imageState](https://developer.apple.com/documentation/retentionmessaging/imagestate)
    public var imageState: ImageState? {
        get {
            return rawImageState.flatMap { ImageState(rawValue: $0) }
        }
        set {
            self.rawImageState = newValue.map { $0.rawValue }
        }
    }

    ///See ``imageState``
    public var rawImageState: String?

    public enum CodingKeys: CodingKey {
        case imageIdentifier
        case imageSize
        case imageState
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageIdentifier = try container.decodeIfPresent(UUID.self, forKey: .imageIdentifier)
        self.rawImageSize = try container.decodeIfPresent(String.self, forKey: .imageSize)
        self.rawImageState = try container.decodeIfPresent(String.self, forKey: .imageState)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.imageIdentifier?.uuidString.lowercased(), forKey: .imageIdentifier)
        try container.encodeIfPresent(self.rawImageSize, forKey: .imageSize)
        try container.encodeIfPresent(self.rawImageState, forKey: .imageState)
    }
}
