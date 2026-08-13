// Copyright (c) 2024 Apple Inc. Licensed under MIT License.

///The payload data that contains an external purchase token.
///
///[externalPurchaseToken](https://developer.apple.com/documentation/appstoreservernotifications/externalpurchasetoken)
public struct ExternalPurchaseToken: Decodable, Encodable, Hashable, Sendable {
    
    public init(externalPurchaseId: String? = nil, tokenCreationDate: Int64? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, tokenType: TokenType? = nil) {
        self.init(externalPurchaseId: externalPurchaseId, tokenCreationDate: tokenCreationDate, appAppleId: appAppleId, bundleId: bundleId, rawTokenType: tokenType?.rawValue)
    }

    public init(externalPurchaseId: String? = nil, tokenCreationDate: Int64? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, rawTokenType: String? = nil) {
        self.externalPurchaseId = externalPurchaseId
        self.tokenCreationDate = tokenCreationDate
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.rawTokenType = rawTokenType
    }

    ///The field of an external purchase token that uniquely identifies the token.
    ///
    ///[externalPurchaseId](https://developer.apple.com/documentation/appstoreservernotifications/externalpurchaseid)
    public var externalPurchaseId: String?

    ///The field of an external purchase token that contains the UNIX date, in milliseconds, when the system created the token.
    ///
    ///[tokenCreationDate](https://developer.apple.com/documentation/appstoreservernotifications/tokencreationdate)
    public var tokenCreationDate: Int64?
    
    ///The unique identifier of an app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?
    
    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreservernotifications/bundleid)
    public var bundleId: String?

    ///The custom link token type.
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
        case tokenType
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.externalPurchaseId = try container.decodeIfPresent(String.self, forKey: .externalPurchaseId)
        self.tokenCreationDate = try container.decodeIfPresent(Int64.self, forKey: .tokenCreationDate)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.rawTokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.externalPurchaseId, forKey: .externalPurchaseId)
        try container.encodeIfPresent(self.tokenCreationDate, forKey: .tokenCreationDate)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.rawTokenType, forKey: .tokenType)
    }
}
