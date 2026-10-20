// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The status of the performance test.
///
///[PerformanceTestStatus](https://developer.apple.com/documentation/retentionmessaging/performanceteststatus)
public enum PerformanceTestStatus: String, Decodable, Encodable, Hashable, Sendable {
    ///The test is still pending.
    case pending = "PENDING"

    ///The test passed.
    case pass = "PASS"

    ///The test failed.
    case fail = "FAIL"
}
