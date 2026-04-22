// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///An object that enumerates the test configuration parameters.
///
///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
public struct PerformanceTestConfig: Decodable, Encodable, Hashable, Sendable {

    public init(maxConcurrentRequests: Int64, totalRequests: Int64, totalDuration: Int64, responseTimeThreshold: Int64, successRateThreshold: Int32) {
        self.maxConcurrentRequests = maxConcurrentRequests
        self.totalRequests = totalRequests
        self.totalDuration = totalDuration
        self.responseTimeThreshold = responseTimeThreshold
        self.successRateThreshold = successRateThreshold
    }

    ///The maximum number of concurrent requests the API allows.
    ///
    ///[maxConcurrentRequests](https://developer.apple.com/documentation/retentionmessaging/maxconcurrentrequests)
    public var maxConcurrentRequests: Int64

    ///The total number of requests to make during the test.
    ///
    ///[totalRequests](https://developer.apple.com/documentation/retentionmessaging/totalrequests)
    public var totalRequests: Int64

    ///The total duration of the test in milliseconds.
    ///
    ///[totalDuration](https://developer.apple.com/documentation/retentionmessaging/totalduration)
    public var totalDuration: Int64

    ///The maximum time your server has to respond when the system calls your Get Retention Message endpoint in the sandbox environment.
    ///
    ///[responseTimeThreshold](https://developer.apple.com/documentation/retentionmessaging/responsetimethreshold)
    public var responseTimeThreshold: Int64

    ///The success rate threshold percentage.
    ///
    ///[successRateThreshold](https://developer.apple.com/documentation/retentionmessaging/successratethreshold)
    public var successRateThreshold: Int32
}
