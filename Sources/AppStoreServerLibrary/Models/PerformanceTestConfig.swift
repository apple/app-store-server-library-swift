// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///An object that enumerates the test configuration parameters.
///
///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
public struct PerformanceTestConfig: Decodable, Encodable, Hashable, Sendable {

    public init(maxConcurrentRequests: Int64, responseTimeThreshold: Int64, successRateThreshold: Int32, totalDuration: Int64, totalRequests: Int64) {
        self.maxConcurrentRequests = maxConcurrentRequests
        self.responseTimeThreshold = responseTimeThreshold
        self.successRateThreshold = successRateThreshold
        self.totalDuration = totalDuration
        self.totalRequests = totalRequests
    }

    ///The maximum number of concurrent requests the API allows.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var maxConcurrentRequests: Int64

    ///The maximum time your server has to respond when the system calls your Get Retention Message endpoint in the sandbox environment.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var responseTimeThreshold: Int64

    ///The success rate threshold percentage.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var successRateThreshold: Int32

    ///The total duration of the test in milliseconds.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var totalDuration: Int64

    ///The total number of requests to make during the test.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var totalRequests: Int64
}
