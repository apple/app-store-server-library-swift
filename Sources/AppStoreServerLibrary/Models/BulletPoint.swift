// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The text and its bullet-point image to include in a retention message’s bulleted list.
///
///[BulletPoint](https://developer.apple.com/documentation/retentionmessaging/bulletpoint)
public struct BulletPoint: Decodable, Encodable, Hashable, Sendable {

    private static let maximumTextLength = 66
    private static let maximumAltTextLength = 150

    public enum ValidationError: Error {
        case textTooLong
        case altTextTooLong
    }

    public init(text: String, imageIdentifier: UUID, altText: String) throws {
        guard text.count <= Self.maximumTextLength else {
            throw ValidationError.textTooLong
        }
        guard altText.count <= Self.maximumAltTextLength else {
            throw ValidationError.altTextTooLong
        }
        self.text = text
        self.imageIdentifier = imageIdentifier
        self.altText = altText
    }

    ///The text of the individual bullet point.
    ///
    ///[text](https://developer.apple.com/documentation/retentionmessaging/text)
    public var text: String

    ///The identifier of the image to use as the bullet point.
    ///
    ///[imageIdentifier](https://developer.apple.com/documentation/retentionmessaging/imageidentifier)
    public var imageIdentifier: UUID

    ///The alternative text you provide for the corresponding image of the bullet point.
    ///
    ///[altText](https://developer.apple.com/documentation/retentionmessaging/alttext)
    public var altText: String
}
