// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The performance test response object.
///
///[PerformanceTestResponse](https://developer.apple.com/documentation/retentionmessaging/performancetestresponse)
public struct PerformanceTestResponse: Decodable, Encodable, Hashable, Sendable {

    public init(config: PerformanceTestConfig, requestId: String) {
        self.config = config
        self.requestId = requestId
    }

    ///The performance test configuration object.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var config: PerformanceTestConfig

    ///The performance test request identifier.
    ///
    ///[requestId](https://developer.apple.com/documentation/retentionmessaging/requestid)
    public var requestId: String
}
