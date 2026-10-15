// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The request body for uploading a message, which includes the message text and an optional image reference and bullet points.
///
///[UploadMessageRequestBody](https://developer.apple.com/documentation/retentionmessaging/uploadmessagerequestbody)
public struct UploadMessageRequestBody: Decodable, Encodable, Hashable, Sendable {

    private static let maximumHeaderLength = 66
    private static let maximumBodyLength = 144
    private static let maximumBulletPointsCount = 5

    public enum ValidationError: Error {
        case headerTooLong
        case bodyTooLong
        case tooManyBulletPoints
    }

    public init(header: String, body: String, image: UploadMessageImage? = nil, bulletPoints: [BulletPoint]? = nil, headerPosition: HeaderPosition? = nil) throws {
        try self.init(header: header, body: body, image: image, bulletPoints: bulletPoints, rawHeaderPosition: headerPosition?.rawValue)
    }

    @_disfavoredOverload
    public init(header: String, body: String, image: UploadMessageImage? = nil, bulletPoints: [BulletPoint]? = nil, rawHeaderPosition: String? = nil) throws {
        guard header.unicodeScalars.count <= Self.maximumHeaderLength else {
            throw ValidationError.headerTooLong
        }
        guard body.unicodeScalars.count <= Self.maximumBodyLength else {
            throw ValidationError.bodyTooLong
        }
        if let bulletPoints = bulletPoints {
            guard bulletPoints.count <= Self.maximumBulletPointsCount else {
                throw ValidationError.tooManyBulletPoints
            }
        }
        self.header = header
        self.body = body
        self.image = image
        self.bulletPoints = bulletPoints
        self.rawHeaderPosition = rawHeaderPosition
    }

    ///The header text of the retention message that the system displays to customers.
    ///
    ///[header](https://developer.apple.com/documentation/retentionmessaging/header)
    public var header: String

    ///The body text of the retention message that the system displays to customers.
    ///
    ///[body](https://developer.apple.com/documentation/retentionmessaging/body)
    public var body: String

    ///The optional image identifier and its alternative text to appear as part of a text-based message with an image.
    ///
    ///[UploadMessageImage](https://developer.apple.com/documentation/retentionmessaging/uploadmessageimage)
    public var image: UploadMessageImage?

    ///An optional array of up to five bullet points.
    ///
    ///[BulletPoint](https://developer.apple.com/documentation/retentionmessaging/bulletpoint)
    public var bulletPoints: [BulletPoint]?

    ///The position of header text, which defaults to placing header text above the body.
    ///
    ///[headerPosition](https://developer.apple.com/documentation/retentionmessaging/headerposition)
    public var headerPosition: HeaderPosition? {
        get {
            return rawHeaderPosition.flatMap { HeaderPosition(rawValue: $0) }
        }
        set {
            self.rawHeaderPosition = newValue.map { $0.rawValue }
        }
    }

    ///See ``headerPosition``
    public var rawHeaderPosition: String?

    public enum CodingKeys: CodingKey {
        case header
        case body
        case image
        case bulletPoints
        case headerPosition
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.header = try container.decode(String.self, forKey: .header)
        self.body = try container.decode(String.self, forKey: .body)
        self.image = try container.decodeIfPresent(UploadMessageImage.self, forKey: .image)
        self.bulletPoints = try container.decodeIfPresent([BulletPoint].self, forKey: .bulletPoints)
        self.rawHeaderPosition = try container.decodeIfPresent(String.self, forKey: .headerPosition)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.header, forKey: .header)
        try container.encode(self.body, forKey: .body)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encodeIfPresent(self.bulletPoints, forKey: .bulletPoints)
        try container.encodeIfPresent(self.rawHeaderPosition, forKey: .headerPosition)
    }
}
