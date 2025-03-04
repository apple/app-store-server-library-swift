// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains status information for all of a customer’s auto-renewable subscriptions in your app.
///
///[StatusResponse](https://developer.apple.com/documentation/appstoreserverapi/statusresponse)
public struct StatusResponse: Decodable, Encodable, Hashable, Sendable {
    
    public init(environment: AppStoreEnvironment? = nil, bundleId: String? = nil, appAppleId: Int64? = nil, data: [SubscriptionGroupIdentifierItem]? = nil) {
        self.environment = environment
        self.bundleId = bundleId
        self.appAppleId = appAppleId
        self.data = data
    }
    
    public init(rawEnvironment: String? = nil, bundleId: String? = nil, appAppleId: Int64? = nil, data: [SubscriptionGroupIdentifierItem]? = nil) {
        self.rawEnvironment = rawEnvironment
        self.bundleId = bundleId
        self.appAppleId = appAppleId
        self.data = data
    }
    
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
    
    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?
               
    ///The unique identifier of an app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?
                 
    ///An array of information for auto-renewable subscriptions, including App Store-signed transaction information and App Store-signed renewal information.
    public var data: [SubscriptionGroupIdentifierItem]?

    public enum CodingKeys: CodingKey {
        case environment
        case bundleId
        case appAppleId
        case data
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.data = try container.decodeIfPresent([SubscriptionGroupIdentifierItem].self, forKey: .data)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.data, forKey: .data)
    }
}
