// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The performance test response object.
///
///[PerformanceTestResponse](https://developer.apple.com/documentation/retentionmessaging/performancetestresponse)
public struct PerformanceTestResponse: Decodable, Encodable, Hashable, Sendable {

    public init(config: PerformanceTestConfig, requestId: UUID) {
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
    public var requestId: UUID

    public enum CodingKeys: CodingKey {
        case config
        case requestId
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.config, forKey: .config)
        try container.encode(self.requestId.uuidString.lowercased(), forKey: .requestId)
    }
}
