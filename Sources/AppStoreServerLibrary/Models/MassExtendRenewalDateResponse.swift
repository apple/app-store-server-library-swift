// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that indicates the server successfully received the subscription-renewal-date extension request.
///
///[MassExtendRenewalDateResponse](https://developer.apple.com/documentation/appstoreserverapi/massextendrenewaldateresponse)
public struct MassExtendRenewalDateResponse: Decodable, Encodable, Hashable, Sendable {

    private static let maximumRequestIdentifierLength = 128

    public enum ValidationError: Error {
        case requestIdentifierTooLong
    }

    public init(requestIdentifier: String? = nil) throws {
        if let requestIdentifier = requestIdentifier {
            guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
                throw ValidationError.requestIdentifierTooLong
            }
        }
        self.requestIdentifier = requestIdentifier
    }

    ///A string that contains the UUID that identifies the subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?

    public enum CodingKeys: CodingKey {
        case requestIdentifier
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestIdentifier = try container.decodeIfPresent(String.self, forKey: .requestIdentifier)
        if let requestIdentifier = requestIdentifier {
            guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
                throw ValidationError.requestIdentifierTooLong
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if let requestIdentifier = requestIdentifier {
            guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
                throw ValidationError.requestIdentifierTooLong
            }
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.requestIdentifier, forKey: .requestIdentifier)
    }
}
