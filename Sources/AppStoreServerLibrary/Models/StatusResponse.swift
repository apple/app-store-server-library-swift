// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains status information for all of a customer’s auto-renewable subscriptions in your app.
///
///[StatusResponse](https://developer.apple.com/documentation/appstoreserverapi/statusresponse)
public struct StatusResponse: Decodable, Encodable, Hashable, Sendable {

    public init(data: [SubscriptionGroupIdentifierItem]? = nil, environment: AppStoreEnvironment? = nil, appAppleId: Int64? = nil, bundleId: String? = nil) {
        self.init(data: data, rawEnvironment: environment?.rawValue, appAppleId: appAppleId, bundleId: bundleId)
    }

    @_disfavoredOverload
    public init(data: [SubscriptionGroupIdentifierItem]? = nil, rawEnvironment: String? = nil, appAppleId: Int64? = nil, bundleId: String? = nil) {
        self.data = data
        self.rawEnvironment = rawEnvironment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
    }

    ///An array of information for auto-renewable subscriptions, including App Store-signed transaction information and App Store-signed renewal information.
    ///
    ///[SubscriptionGroupIdentifierItem](https://developer.apple.com/documentation/appstoreserverapi/subscriptiongroupidentifieritem)
    public var data: [SubscriptionGroupIdentifierItem]?

    ///The server environment, sandbox or production, in which the App Store generated the response.
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

    ///Your app’s App Store identifier.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreserverapi/appappleid)
    public var appAppleId: Int64?

    ///Your app’s bundle identifier.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    public enum CodingKeys: CodingKey {
        case data
        case environment
        case appAppleId
        case bundleId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([SubscriptionGroupIdentifierItem].self, forKey: .data)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.data, forKey: .data)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
    }
}
