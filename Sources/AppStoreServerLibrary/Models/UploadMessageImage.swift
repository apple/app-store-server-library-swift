// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The definition of an image with its alternative text.
///
///[UploadMessageImage](https://developer.apple.com/documentation/retentionmessaging/uploadmessageimage)
public struct UploadMessageImage: Decodable, Encodable, Hashable, Sendable {

    private static let maximumAltTextLength = 150

    public enum ValidationError: Error {
        case altTextTooLong
    }

    public init(imageIdentifier: UUID, altText: String) throws {
        guard altText.count <= Self.maximumAltTextLength else {
            throw ValidationError.altTextTooLong
        }
        self.imageIdentifier = imageIdentifier
        self.altText = altText
    }

    ///The unique identifier of an image.
    ///
    ///[imageIdentifier](https://developer.apple.com/documentation/retentionmessaging/imageidentifier)
    public var imageIdentifier: UUID

    ///The alternative text you provide for the corresponding image.
    ///
    ///[altText](https://developer.apple.com/documentation/retentionmessaging/alttext)
    public var altText: String
}
