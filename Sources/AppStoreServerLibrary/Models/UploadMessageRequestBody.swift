// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The request body for uploading a message, which includes the message text and an optional image reference.
///
///[UploadMessageRequestBody](https://developer.apple.com/documentation/retentionmessaging/uploadmessagerequestbody)
public struct UploadMessageRequestBody: Decodable, Encodable, Hashable, Sendable {

    private static let maximumHeaderLength = 66
    private static let maximumBodyLength = 144

    public enum ValidationError: Error {
        case headerTooLong
        case bodyTooLong
    }

    public init(header: String, body: String, image: UploadMessageImage? = nil) throws {
        guard header.count <= Self.maximumHeaderLength else {
            throw ValidationError.headerTooLong
        }
        guard body.count <= Self.maximumBodyLength else {
            throw ValidationError.bodyTooLong
        }
        self.header = header
        self.body = body
        self.image = image
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
}
