// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains the customer’s transaction history for an app.
///
///[HistoryResponse](https://developer.apple.com/documentation/appstoreserverapi/historyresponse)
public struct HistoryResponse: Decodable, Encodable, Hashable, Sendable {
    
    public init(revision: String? = nil, hasMore: Bool? = nil, bundleId: String? = nil, appAppleId: Int64? = nil, environment: Environment? = nil, signedTransactions: [String]? = nil) {
        self.revision = revision
        self.hasMore = hasMore
        self.bundleId = bundleId
        self.appAppleId = appAppleId
        self.environment = environment
        self.signedTransactions = signedTransactions
    }
    
    public init(revision: String? = nil, hasMore: Bool? = nil, bundleId: String? = nil, appAppleId: Int64? = nil, rawEnvironment: String? = nil, signedTransactions: [String]? = nil) {
        self.revision = revision
        self.hasMore = hasMore
        self.bundleId = bundleId
        self.appAppleId = appAppleId
        self.rawEnvironment = rawEnvironment
        self.signedTransactions = signedTransactions
    }
    
    ///A token you use in a query to request the next set of transactions for the customer.
    ///
    ///[revision](https://developer.apple.com/documentation/appstoreserverapi/revision)
    public var revision: String?
    
    ///A Boolean value indicating whether the App Store has more transaction data.
    ///
    ///[hasMore](https://developer.apple.com/documentation/appstoreserverapi/hasmore)
    public var hasMore: Bool?
    
    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?
    
    ///The unique identifier of an app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?
    
    ///The server environment in which you’re making the request, whether sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
    public var environment: Environment? {
        get {
            return rawEnvironment.flatMap { Environment(rawValue: $0) }
        }
        set {
            self.rawEnvironment = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``environment``
    public var rawEnvironment: String?
    
    ///An array of in-app purchase transactions for the customer, signed by Apple, in JSON Web Signature format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactions: [String]?
    
    public enum CodingKeys: CodingKey {
        case revision
        case hasMore
        case bundleId
        case appAppleId
        case environment
        case signedTransactions
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.revision = try container.decodeIfPresent(String.self, forKey: .revision)
        self.hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.signedTransactions = try container.decodeIfPresent([String].self, forKey: .signedTransactions)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.revision, forKey: .revision)
        try container.encodeIfPresent(self.hasMore, forKey: .hasMore)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.signedTransactions, forKey: .signedTransactions)
    }
}
