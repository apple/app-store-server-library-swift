// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The status of the performance test.
///
///[PerformanceTestStatus](https://developer.apple.com/documentation/retentionmessaging/performanceteststatus)
public enum PerformanceTestStatus: String, Decodable, Encodable, Hashable, Sendable {
    case pending = "PENDING"
    case pass = "PASS"
    case fail = "FAIL"
}
