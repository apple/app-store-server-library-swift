// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The response body that contains the URL for your Get Retention Message endpoint.
///
///[RealtimeUrlResponse](https://developer.apple.com/documentation/retentionmessaging/realtimeurlresponse)
public struct RealtimeUrlResponse: Decodable, Encodable, Hashable, Sendable {

    private static let maximumRealtimeURLLength = 256

    public enum ValidationError: Error {
        case realtimeURLTooLong
    }

    public init(realtimeURL: String) throws {
        guard realtimeURL.unicodeScalars.count <= Self.maximumRealtimeURLLength else {
            throw ValidationError.realtimeURLTooLong
        }
        self.realtimeURL = realtimeURL
    }

    ///A string that contains the URL you provided for your Get Retention Message endpoint.
    ///
    ///[realtimeURL](https://developer.apple.com/documentation/retentionmessaging/realtimeurl)
    public var realtimeURL: String

    public enum CodingKeys: CodingKey {
        case realtimeURL
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.realtimeURL = try container.decode(String.self, forKey: .realtimeURL)
        guard realtimeURL.unicodeScalars.count <= Self.maximumRealtimeURLLength else {
            throw ValidationError.realtimeURLTooLong
        }
    }

    public func encode(to encoder: any Encoder) throws {
        guard realtimeURL.unicodeScalars.count <= Self.maximumRealtimeURLLength else {
            throw ValidationError.realtimeURLTooLong
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.realtimeURL, forKey: .realtimeURL)
    }
}
