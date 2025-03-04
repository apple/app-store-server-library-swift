// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The payload data for a subscription-renewal-date extension notification.
///
///[summary](https://developer.apple.com/documentation/appstoreservernotifications/summary)
public struct Summary: Decodable, Encodable, Hashable, Sendable {
    
    public init(environment: AppStoreEnvironment? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, productId: String? = nil, requestIdentifier: String? = nil, storefrontCountryCodes: [String]? = nil, succeededCount: Int64? = nil, failedCount: Int64? = nil) {
        self.environment = environment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.productId = productId
        self.requestIdentifier = requestIdentifier
        self.storefrontCountryCodes = storefrontCountryCodes
        self.succeededCount = succeededCount
        self.failedCount = failedCount
    }
    
    public init(rawEnvironment: String? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, productId: String? = nil, requestIdentifier: String? = nil, storefrontCountryCodes: [String]? = nil, succeededCount: Int64? = nil, failedCount: Int64? = nil) {
        self.rawEnvironment = rawEnvironment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.productId = productId
        self.requestIdentifier = requestIdentifier
        self.storefrontCountryCodes = storefrontCountryCodes
        self.succeededCount = succeededCount
        self.failedCount = failedCount
    }
    
    ///The server environment that the notification applies to, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreservernotifications/environment)
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

    ///The unique identifier of an app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?

    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    ///The unique identifier for the product, that you create in App Store Connect.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?

    ///A string that contains a unique identifier you provide to track each subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?

    ///A list of storefront country codes you provide to limit the storefronts for a subscription-renewal-date extension.
    ///
    ///[storefrontCountryCodes](https://developer.apple.com/documentation/appstoreserverapi/storefrontcountrycodes)
    public var storefrontCountryCodes: [String]?

    ///The count of subscriptions that successfully receive a subscription-renewal-date extension.
    ///
    ///[succeededCount](https://developer.apple.com/documentation/appstoreserverapi/succeededcount)
    public var succeededCount: Int64?

    ///The count of subscriptions that fail to receive a subscription-renewal-date extension.
    ///
    ///[failedCount](https://developer.apple.com/documentation/appstoreserverapi/failedcount)
    public var failedCount: Int64?
    
    public enum CodingKeys: CodingKey {
        case environment
        case appAppleId
        case bundleId
        case productId
        case requestIdentifier
        case storefrontCountryCodes
        case succeededCount
        case failedCount
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.requestIdentifier = try container.decodeIfPresent(String.self, forKey: .requestIdentifier)
        self.storefrontCountryCodes = try container.decodeIfPresent([String].self, forKey: .storefrontCountryCodes)
        self.succeededCount = try container.decodeIfPresent(Int64.self, forKey: .succeededCount)
        self.failedCount = try container.decodeIfPresent(Int64.self, forKey: .failedCount)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.requestIdentifier, forKey: .requestIdentifier)
        try container.encodeIfPresent(self.storefrontCountryCodes, forKey: .storefrontCountryCodes)
        try container.encodeIfPresent(self.succeededCount, forKey: .succeededCount)
        try container.encodeIfPresent(self.failedCount, forKey: .failedCount)
    }
}
