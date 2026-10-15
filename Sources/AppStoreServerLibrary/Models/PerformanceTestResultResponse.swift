// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///An object the API returns that describes the performance test results.
///
///[PerformanceTestResultResponse](https://developer.apple.com/documentation/retentionmessaging/performancetestresultresponse)
public struct PerformanceTestResultResponse: Decodable, Encodable, Hashable, Sendable {

    public init(config: PerformanceTestConfig, failures: [SendAttemptResult: Int32], numPending: Int32, responseTimes: PerformanceTestResponseTimes, result: PerformanceTestStatus, successRate: Int32, target: String) {
        self.init(config: config, rawFailures: Dictionary(uniqueKeysWithValues: failures.map { ($0.key.rawValue, $0.value) }), numPending: numPending, responseTimes: responseTimes, rawResult: result.rawValue, successRate: successRate, target: target)
    }

    public init(config: PerformanceTestConfig, rawFailures: [String: Int32], numPending: Int32, responseTimes: PerformanceTestResponseTimes, rawResult: String, successRate: Int32, target: String) {
        self.config = config
        self.rawFailures = rawFailures
        self.numPending = numPending
        self.responseTimes = responseTimes
        self.rawResult = rawResult
        self.successRate = successRate
        self.target = target
    }

    ///A PerformanceTestConfig object that enumerates the test parameters.
    ///
    ///[PerformanceTestConfig](https://developer.apple.com/documentation/retentionmessaging/performancetestconfig)
    public var config: PerformanceTestConfig

    ///A Failures object that represents a map of server-to-server notification failure reasons and counts that represent the number of failures encountered during the performance test.
    ///
    ///[Failures](https://developer.apple.com/documentation/retentionmessaging/failures)
    public var failures: [SendAttemptResult: Int32]? {
        get {
            var result: [SendAttemptResult: Int32] = [:]
            for (key, value) in rawFailures {
                if let attemptResult = SendAttemptResult(rawValue: key) {
                    result[attemptResult] = value
                }
            }
            return result
        }
        set {
            self.rawFailures = newValue.map { typedMap in
                Dictionary(uniqueKeysWithValues: typedMap.map { ($0.key.rawValue, $0.value) })
            } ?? rawFailures
        }
    }

    ///See ``failures``
    public var rawFailures: [String: Int32]

    ///An integer that describes the number of pending requests in the performance test.
    ///
    ///[PerformanceTestResultResponse](https://developer.apple.com/documentation/retentionmessaging/performancetestresultresponse)
    public var numPending: Int32

    ///A PerformanceTestResponseTimes object that enumerates the response times measured during the test.
    ///
    ///[PerformanceTestResponseTimes](https://developer.apple.com/documentation/retentionmessaging/performancetestresponsetimes)
    public var responseTimes: PerformanceTestResponseTimes

    ///A PerformanceTestStatus object that describes the overall result of the test.
    ///
    ///[PerformanceTestStatus](https://developer.apple.com/documentation/retentionmessaging/performanceteststatus)
    public var result: PerformanceTestStatus? {
        get {
            return PerformanceTestStatus(rawValue: rawResult)
        }
        set {
            self.rawResult = newValue.map { $0.rawValue } ?? rawResult
        }
    }

    ///See ``result``
    public var rawResult: String

    ///An integer that describes the success rate percentage of the performance test.
    ///
    ///[PerformanceTestResultResponse](https://developer.apple.com/documentation/retentionmessaging/performancetestresultresponse)
    public var successRate: Int32

    ///The target URL for the performance test.
    ///
    ///[PerformanceTestResultResponse](https://developer.apple.com/documentation/retentionmessaging/performancetestresultresponse)
    public var target: String

    public enum CodingKeys: CodingKey {
        case config
        case failures
        case numPending
        case responseTimes
        case result
        case successRate
        case target
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.config = try container.decode(PerformanceTestConfig.self, forKey: .config)
        self.rawFailures = try container.decode([String: Int32].self, forKey: .failures)
        self.numPending = try container.decode(Int32.self, forKey: .numPending)
        self.responseTimes = try container.decode(PerformanceTestResponseTimes.self, forKey: .responseTimes)
        self.rawResult = try container.decode(String.self, forKey: .result)
        self.successRate = try container.decode(Int32.self, forKey: .successRate)
        self.target = try container.decode(String.self, forKey: .target)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.config, forKey: .config)
        try container.encode(self.rawFailures, forKey: .failures)
        try container.encode(self.numPending, forKey: .numPending)
        try container.encode(self.responseTimes, forKey: .responseTimes)
        try container.encode(self.rawResult, forKey: .result)
        try container.encode(self.successRate, forKey: .successRate)
        try container.encode(self.target, forKey: .target)
    }
}
