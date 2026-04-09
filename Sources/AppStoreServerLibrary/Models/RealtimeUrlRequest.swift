// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The request body for configuring the URL of your Get Retention Message endpoint.
///
///[RealtimeUrlRequest](https://developer.apple.com/documentation/retentionmessaging/realtimeurlrequest)
public struct RealtimeUrlRequest: Decodable, Encodable, Hashable, Sendable {

    private static let maximumRealtimeURLLength = 256

    public enum ValidationError: Error {
        case realtimeURLTooLong
    }

    public init(realtimeURL: String) throws {
        guard realtimeURL.count <= Self.maximumRealtimeURLLength else {
            throw ValidationError.realtimeURLTooLong
        }
        self.realtimeURL = realtimeURL
    }

    ///A string that contains the URL of your Get Retention Message endpoint for configuration.
    ///
    ///[realtimeURL](https://developer.apple.com/documentation/retentionmessaging/realtimeurl)
    public var realtimeURL: String
}
