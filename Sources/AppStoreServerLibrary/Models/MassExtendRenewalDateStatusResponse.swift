// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///A response that indicates the current status of a request to extend the subscription renewal date to all eligible subscribers.
///
///[MassExtendRenewalDateStatusResponse](https://developer.apple.com/documentation/appstoreserverapi/massextendrenewaldatestatusresponse)
public struct MassExtendRenewalDateStatusResponse: Decodable, Encodable, Hashable, Sendable {

    private static let maximumRequestIdentifierLength = 128

    public enum ValidationError: Error {
        case requestIdentifierTooLong
    }

    public init(requestIdentifier: String? = nil, complete: Bool? = nil, completeDate: Date? = nil, failedCount: Int64? = nil, succeededCount: Int64? = nil) throws {
        if let requestIdentifier = requestIdentifier {
            guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
                throw ValidationError.requestIdentifierTooLong
            }
        }
        self.requestIdentifier = requestIdentifier
        self.complete = complete
        self.completeDate = completeDate
        self.failedCount = failedCount
        self.succeededCount = succeededCount
    }

    ///The UUID that represents your request for a subscription-renewal-date extension.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?

    ///A Boolean value that’s TRUE to indicate that the App Store completed your request to extend a subscription renewal date for all eligible subscribers.
    ///
    ///[complete](https://developer.apple.com/documentation/appstoreserverapi/complete)
    public var complete: Bool?

    ///The date that the App Store completes the request.
    ///
    ///[completeDate](https://developer.apple.com/documentation/appstoreserverapi/completedate)
    public var completeDate: Date?

    ///The final count of subscribers that fail to receive a subscription-renewal-date extension.
    ///
    ///[failedCount](https://developer.apple.com/documentation/appstoreserverapi/failedcount)
    public var failedCount: Int64?

    ///The final count of subscribers that successfully receive a subscription-renewal-date extension.
    ///
    ///[succeededCount](https://developer.apple.com/documentation/appstoreserverapi/succeededcount)
    public var succeededCount: Int64?

    public enum CodingKeys: CodingKey {
        case requestIdentifier
        case complete
        case completeDate
        case failedCount
        case succeededCount
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestIdentifier = try container.decodeIfPresent(String.self, forKey: .requestIdentifier)
        self.complete = try container.decodeIfPresent(Bool.self, forKey: .complete)
        self.completeDate = try container.decodeIfPresent(Double.self, forKey: .completeDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.failedCount = try container.decodeIfPresent(Int64.self, forKey: .failedCount)
        self.succeededCount = try container.decodeIfPresent(Int64.self, forKey: .succeededCount)
        if let requestIdentifier = requestIdentifier {
            guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
                throw ValidationError.requestIdentifierTooLong
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if let requestIdentifier = requestIdentifier {
            guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
                throw ValidationError.requestIdentifierTooLong
            }
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.requestIdentifier, forKey: .requestIdentifier)
        try container.encodeIfPresent(self.complete, forKey: .complete)
        try container.encodeIfPresent(self.completeDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .completeDate)
        try container.encodeIfPresent(self.failedCount, forKey: .failedCount)
        try container.encodeIfPresent(self.succeededCount, forKey: .succeededCount)
    }
}
