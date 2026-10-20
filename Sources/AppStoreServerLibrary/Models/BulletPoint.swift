// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The text and its bullet-point image to include in a retention message’s bulleted list.
///
///[BulletPoint](https://developer.apple.com/documentation/retentionmessaging/bulletpoint)
public struct BulletPoint: Decodable, Encodable, Hashable, Sendable {

    private static let maximumAltTextLength = 150
    private static let maximumTextLength = 66

    public enum ValidationError: Error {
        case altTextTooLong
        case textTooLong
    }

    public init(altText: String, imageIdentifier: UUID, text: String) throws {
        guard altText.unicodeScalars.count <= Self.maximumAltTextLength else {
            throw ValidationError.altTextTooLong
        }
        guard text.unicodeScalars.count <= Self.maximumTextLength else {
            throw ValidationError.textTooLong
        }
        self.altText = altText
        self.imageIdentifier = imageIdentifier
        self.text = text
    }

    ///The alternative text you provide for the corresponding image of the bullet point.
    ///
    ///[altText](https://developer.apple.com/documentation/retentionmessaging/alttext)
    public var altText: String

    ///The identifier of the image to use as the bullet point.
    ///
    ///[imageIdentifier](https://developer.apple.com/documentation/retentionmessaging/imageidentifier)
    public var imageIdentifier: UUID

    ///The text of the individual bullet point.
    ///
    ///[bulletPointText](https://developer.apple.com/documentation/retentionmessaging/bulletpointtext)
    public var text: String

    public enum CodingKeys: CodingKey {
        case altText
        case imageIdentifier
        case text
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.altText, forKey: .altText)
        try container.encode(self.imageIdentifier.uuidString.lowercased(), forKey: .imageIdentifier)
        try container.encode(self.text, forKey: .text)
    }
}
