// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///An object that describes test response times.
///
///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
public struct PerformanceTestResponseTimes: Decodable, Encodable, Hashable, Sendable {

    public init(average: Int64, p50: Int64, p90: Int64, p95: Int64, p99: Int64) {
        self.average = average
        self.p50 = p50
        self.p90 = p90
        self.p95 = p95
        self.p99 = p99
    }

    ///Average response time in milliseconds.
    ///
    ///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
    public var average: Int64

    ///The 50th percentile response time in milliseconds.
    ///
    ///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
    public var p50: Int64

    ///The 90th percentile response time in milliseconds.
    ///
    ///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
    public var p90: Int64

    ///The 95th percentile response time in milliseconds.
    ///
    ///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
    public var p95: Int64

    ///The 99th percentile response time in milliseconds.
    ///
    ///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
    public var p99: Int64
}
