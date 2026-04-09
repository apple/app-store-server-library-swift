// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///An object the API returns that describes the performance test results.
///
///[PerformanceTestResultResponse](https://developer.apple.com/documentation/retentionmessaging/performancetestresultresponse)
public struct PerformanceTestResultResponse: Decodable, Encodable, Hashable, Sendable {

    public init(config: PerformanceTestConfig, target: String, result: PerformanceTestStatus, successRate: Int32, numPending: Int32, responseTimes: PerformanceTestResponseTimes, failures: [SendAttemptResult: Int32]) {
        self.init(config: config, target: target, rawResult: result.rawValue, successRate: successRate, numPending: numPending, responseTimes: responseTimes, rawFailures: Dictionary(uniqueKeysWithValues: failures.map { ($0.key.rawValue, $0.value) }))
    }

    public init(config: PerformanceTestConfig, target: String, rawResult: String, successRate: Int32, numPending: Int32, responseTimes: PerformanceTestResponseTimes, rawFailures: [String: Int32]) {
        self.config = config
        self.target = target
        self.rawResult = rawResult
        self.successRate = successRate
        self.numPending = numPending
        self.responseTimes = responseTimes
        self.rawFailures = rawFailures
    }

    ///A PerformanceTestConfig object that enumerates the test parameters.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var config: PerformanceTestConfig

    ///The target URL for the performance test.
    ///
    ///[target](https://developer.apple.com/documentation/retentionmessaging/target)
    public var target: String

    ///A PerformanceTestStatus object that describes the overall result of the test.
    ///
    ///[PerformanceTestStatus](https://developer.apple.com/documentation/retentionmessaging/performanceteststatus)
    public var result: PerformanceTestStatus? {
        get {
            return rawResult.flatMap { PerformanceTestStatus(rawValue: $0) }
        }
        set {
            self.rawResult = newValue.map { $0.rawValue }
        }
    }

    ///See ``result``
    public var rawResult: String?

    ///An integer that describes he success rate percentage of the performance test.
    ///
    ///[successRate](https://developer.apple.com/documentation/retentionmessaging/successrate)
    public var successRate: Int32

    ///An integer that describes the number of pending requests in the performance test.
    ///
    ///[numPending](https://developer.apple.com/documentation/retentionmessaging/numpending)
    public var numPending: Int32

    ///A PerformanceTestResponseTimes object that enumerates the response times measured during the test.
    ///
    ///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
    public var responseTimes: PerformanceTestResponseTimes

    ///A map of server-to-server notification failure reasons and counts that represent the number of failures encountered during the performance test.
    ///
    ///[Failures](https://developer.apple.com/documentation/retentionmessaging/failures)
    public var failures: [SendAttemptResult: Int32]? {
        get {
            return rawFailures.map { rawMap in
                var result: [SendAttemptResult: Int32] = [:]
                for (key, value) in rawMap {
                    if let attemptResult = SendAttemptResult(rawValue: key) {
                        result[attemptResult] = value
                    }
                }
                return result
            }
        }
        set {
            self.rawFailures = newValue.map { typedMap in
                Dictionary(uniqueKeysWithValues: typedMap.map { ($0.key.rawValue, $0.value) })
            }
        }
    }

    ///See ``failures``
    public var rawFailures: [String: Int32]?

    public enum CodingKeys: CodingKey {
        case config
        case target
        case result
        case successRate
        case numPending
        case responseTimes
        case failures
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.config = try container.decode(PerformanceTestConfig.self, forKey: .config)
        self.target = try container.decode(String.self, forKey: .target)
        self.rawResult = try container.decodeIfPresent(String.self, forKey: .result)
        self.successRate = try container.decode(Int32.self, forKey: .successRate)
        self.numPending = try container.decode(Int32.self, forKey: .numPending)
        self.responseTimes = try container.decode(PerformanceTestResponseTimes.self, forKey: .responseTimes)
        self.rawFailures = try container.decodeIfPresent([String: Int32].self, forKey: .failures)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.config, forKey: .config)
        try container.encode(self.target, forKey: .target)
        try container.encodeIfPresent(self.rawResult, forKey: .result)
        try container.encode(self.successRate, forKey: .successRate)
        try container.encode(self.numPending, forKey: .numPending)
        try container.encode(self.responseTimes, forKey: .responseTimes)
        try container.encodeIfPresent(self.rawFailures, forKey: .failures)
    }
}
