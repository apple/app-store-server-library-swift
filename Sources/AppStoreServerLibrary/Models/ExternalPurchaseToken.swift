// Copyright (c) 2024 Apple Inc. Licensed under MIT License.

import Foundation

///The payload data that contains an external purchase token.
///
///[externalPurchaseToken](https://developer.apple.com/documentation/appstoreservernotifications/externalpurchasetoken)
public struct ExternalPurchaseToken: Decodable, Encodable, Hashable, Sendable {

    public init(externalPurchaseId: String, tokenCreationDate: Date, appAppleId: Int64, bundleId: String, tokenExpirationDate: Date? = nil, tokenType: TokenType? = nil) {
        self.init(externalPurchaseId: externalPurchaseId, tokenCreationDate: tokenCreationDate, appAppleId: appAppleId, bundleId: bundleId, tokenExpirationDate: tokenExpirationDate, rawTokenType: tokenType?.rawValue)
    }

    @_disfavoredOverload
    public init(externalPurchaseId: String, tokenCreationDate: Date, appAppleId: Int64, bundleId: String, tokenExpirationDate: Date? = nil, rawTokenType: String? = nil) {
        self.externalPurchaseId = externalPurchaseId
        self.tokenCreationDate = tokenCreationDate
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.tokenExpirationDate = tokenExpirationDate
        self.rawTokenType = rawTokenType
    }

    ///The unique identifier of the token.
    ///
    ///[externalPurchaseId](https://developer.apple.com/documentation/appstoreservernotifications/externalpurchaseid)
    public var externalPurchaseId: String

    ///The UNIX time, in milliseconds, when the system created the token.
    ///
    ///[tokenCreationDate](https://developer.apple.com/documentation/appstoreservernotifications/tokencreationdate)
    public var tokenCreationDate: Date

    ///The app Apple ID for which the system generated the token.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64

    ///The bundle ID of the app for which the system generated the token.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreservernotifications/bundleid)
    public var bundleId: String

    ///The UNIX time, in milliseconds, when a token expires.
    ///
    ///[tokenExpirationDate](https://developer.apple.com/documentation/appstoreservernotifications/tokenexpirationdate)
    public var tokenExpirationDate: Date?

    ///The custom link token type, either SERVICES or ACQUISITION.
    ///
    ///[tokenType](https://developer.apple.com/documentation/appstoreservernotifications/tokentype)
    public var tokenType: TokenType? {
        get {
            return rawTokenType.flatMap { TokenType(rawValue: $0) }
        }
        set {
            self.rawTokenType = newValue.map { $0.rawValue }
        }
    }

    ///See ``tokenType``
    public var rawTokenType: String?

    public enum CodingKeys: CodingKey {
        case externalPurchaseId
        case tokenCreationDate
        case appAppleId
        case bundleId
        case tokenExpirationDate
        case tokenType
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.externalPurchaseId = try container.decode(String.self, forKey: .externalPurchaseId)
        self.tokenCreationDate = try Date(timeIntervalSince1970: container.decode(Double.self, forKey: .tokenCreationDate) / 1000.0)
        self.appAppleId = try container.decode(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decode(String.self, forKey: .bundleId)
        self.tokenExpirationDate = try container.decodeIfPresent(Double.self, forKey: .tokenExpirationDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.rawTokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.externalPurchaseId, forKey: .externalPurchaseId)
        try container.encode((self.tokenCreationDate.timeIntervalSince1970 * 1000.0).rounded(.towardZero), forKey: .tokenCreationDate)
        try container.encode(self.appAppleId, forKey: .appAppleId)
        try container.encode(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.tokenExpirationDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .tokenExpirationDate)
        try container.encodeIfPresent(self.rawTokenType, forKey: .tokenType)
    }
}
