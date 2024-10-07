// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///The success or error information and the date the App Store server records when it attempts to send a server notification to your server.
///
///[sendAttemptItem](https://developer.apple.com/documentation/appstoreserverapi/sendattemptitem)
public struct SendAttemptItem: Decodable, Encodable, Hashable, Sendable {
    
    public init(attemptDate: Date? = nil, sendAttemptResult: SendAttemptResult? = nil) {
        self.attemptDate = attemptDate
        self.sendAttemptResult = sendAttemptResult
    }
    
    public init(attemptDate: Date? = nil, rawSendAttemptResult: String? = nil) {
        self.attemptDate = attemptDate
        self.rawSendAttemptResult = rawSendAttemptResult
    }
    
    ///The date the App Store server attempts to send a notification.
    ///
    ///[attemptDate](https://developer.apple.com/documentation/appstoreservernotifications/attemptdate)
    public var attemptDate: Date?
    
    ///The success or error information the App Store server records when it attempts to send an App Store server notification to your server.
    ///
    ///[sendAttemptResult](https://developer.apple.com/documentation/appstoreserverapi/sendattemptresult)
    public var sendAttemptResult: SendAttemptResult? {
        get {
            return rawSendAttemptResult.flatMap { SendAttemptResult(rawValue: $0) }
        }
        set {
            self.rawSendAttemptResult = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``sendAttemptResult``
    public var rawSendAttemptResult: String?
    
    public enum CodingKeys: CodingKey {
        case attemptDate
        case sendAttemptResult
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attemptDate = try container.decodeIfPresent(Date.self, forKey: .attemptDate)
        self.rawSendAttemptResult = try container.decodeIfPresent(String.self, forKey: .sendAttemptResult)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.attemptDate, forKey: .attemptDate)
        try container.encodeIfPresent(self.rawSendAttemptResult, forKey: .sendAttemptResult)
    }
}
