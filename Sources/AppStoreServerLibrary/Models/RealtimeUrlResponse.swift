// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The response body that contains the URL for your Get Retention Message endpoint.
///
///[RealtimeUrlResponse](https://developer.apple.com/documentation/retentionmessaging/realtimeurlresponse)
public struct RealtimeUrlResponse: Decodable, Encodable, Hashable, Sendable {

    public init(realtimeURL: String) {
        self.realtimeURL = realtimeURL
    }

    ///A string that contains the URL you provided for your Get Retention Message endpoint.
    ///
    ///[realtimeURL](https://developer.apple.com/documentation/retentionmessaging/realtimeurl)
    public var realtimeURL: String
}
