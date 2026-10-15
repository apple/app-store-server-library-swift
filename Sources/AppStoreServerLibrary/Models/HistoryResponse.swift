// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains the customer’s transaction history for an app.
///
///[HistoryResponse](https://developer.apple.com/documentation/appstoreserverapi/historyresponse)
public struct HistoryResponse: Decodable, Encodable, Hashable, Sendable {

    public init(appAppleId: Int64? = nil, bundleId: String? = nil, environment: AppStoreEnvironment? = nil, hasMore: Bool? = nil, revision: String? = nil, signedTransactions: [String]? = nil) {
        self.init(appAppleId: appAppleId, bundleId: bundleId, rawEnvironment: environment?.rawValue, hasMore: hasMore, revision: revision, signedTransactions: signedTransactions)
    }

    @_disfavoredOverload
    public init(appAppleId: Int64? = nil, bundleId: String? = nil, rawEnvironment: String? = nil, hasMore: Bool? = nil, revision: String? = nil, signedTransactions: [String]? = nil) {
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.rawEnvironment = rawEnvironment
        self.hasMore = hasMore
        self.revision = revision
        self.signedTransactions = signedTransactions
    }

    ///The app’s identifier in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreserverapi/appappleid)
    public var appAppleId: Int64?

    ///The bundle identifier of the app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    ///The server environment in which you’re making the request, whether sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
    public var environment: AppStoreEnvironment? {
        get {
            return rawEnvironment.flatMap { AppStoreEnvironment(rawValue: $0) }
        }
        set {
            self.rawEnvironment = newValue.map { $0.rawValue }
        }
    }

    ///See ``environment``
    public var rawEnvironment: String?

    ///A Boolean value that indicates whether the App Store has more transactions than it returns in this response.
    ///
    ///[hasMore](https://developer.apple.com/documentation/appstoreserverapi/hasmore)
    public var hasMore: Bool?

    ///A token you use in a query to request the next set of transactions from the endpoint.
    ///
    ///[revision](https://developer.apple.com/documentation/appstoreserverapi/revision)
    public var revision: String?

    ///An array of in-app purchase transactions for the customer, signed by Apple, in JSON Web Signature (JWS) format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactions: [String]?

    public enum CodingKeys: CodingKey {
        case appAppleId
        case bundleId
        case environment
        case hasMore
        case revision
        case signedTransactions
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.hasMore = try container.decodeIfPresent(Bool.self, forKey: .hasMore)
        self.revision = try container.decodeIfPresent(String.self, forKey: .revision)
        self.signedTransactions = try container.decodeIfPresent([String].self, forKey: .signedTransactions)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.hasMore, forKey: .hasMore)
        try container.encodeIfPresent(self.revision, forKey: .revision)
        try container.encodeIfPresent(self.signedTransactions, forKey: .signedTransactions)
    }
}
