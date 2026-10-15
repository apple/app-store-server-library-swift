// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///The payload data for a subscription-renewal-date extension notification.
///
///[summary](https://developer.apple.com/documentation/appstoreservernotifications/summary)
public struct Summary: Decodable, Encodable, Hashable, Sendable {

    private static let maximumStorefrontCountryCodeLength = 3

    public enum ValidationError: Error {
        case storefrontCountryCodeTooLong
    }

    public init(requestIdentifier: UUID? = nil, environment: AppStoreEnvironment? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, productId: String? = nil, storefrontCountryCodes: [String]? = nil, failedCount: Int64? = nil, succeededCount: Int64? = nil) throws {
        try self.init(requestIdentifier: requestIdentifier, rawEnvironment: environment?.rawValue, appAppleId: appAppleId, bundleId: bundleId, productId: productId, storefrontCountryCodes: storefrontCountryCodes, failedCount: failedCount, succeededCount: succeededCount)
    }

    @_disfavoredOverload
    public init(requestIdentifier: UUID? = nil, rawEnvironment: String? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, productId: String? = nil, storefrontCountryCodes: [String]? = nil, failedCount: Int64? = nil, succeededCount: Int64? = nil) throws {
        if let storefrontCountryCodes = storefrontCountryCodes {
            for storefrontCountryCode in storefrontCountryCodes {
                guard storefrontCountryCode.unicodeScalars.count <= Self.maximumStorefrontCountryCodeLength else {
                    throw ValidationError.storefrontCountryCodeTooLong
                }
            }
        }
        self.requestIdentifier = requestIdentifier
        self.rawEnvironment = rawEnvironment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.productId = productId
        self.storefrontCountryCodes = storefrontCountryCodes
        self.failedCount = failedCount
        self.succeededCount = succeededCount
    }

    ///The UUID that represents a specific request to extend a subscription renewal date.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreservernotifications/requestidentifier)
    public var requestIdentifier: UUID?

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

    ///The unique identifier of the app that the notification applies to.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?

    ///The bundle identifier of the app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreservernotifications/bundleid)
    public var bundleId: String?

    ///The product identifier of the auto-renewable subscription that the subscription-renewal-date extension applies to.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreservernotifications/productid)
    public var productId: String?

    ///A list of country codes that limits the App Store’s attempt to apply the subscription-renewal-date extension.
    ///
    ///[storefrontCountryCodes](https://developer.apple.com/documentation/appstoreservernotifications/storefrontcountrycodes)
    public var storefrontCountryCodes: [String]?

    ///The final count of subscriptions that fail to receive a subscription-renewal-date extension.
    ///
    ///[failedCount](https://developer.apple.com/documentation/appstoreservernotifications/failedcount)
    public var failedCount: Int64?

    ///The final count of subscriptions that successfully receive a subscription-renewal-date extension.
    ///
    ///[succeededCount](https://developer.apple.com/documentation/appstoreservernotifications/succeededcount)
    public var succeededCount: Int64?

    public enum CodingKeys: CodingKey {
        case requestIdentifier
        case environment
        case appAppleId
        case bundleId
        case productId
        case storefrontCountryCodes
        case failedCount
        case succeededCount
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestIdentifier = try container.decodeIfPresent(UUID.self, forKey: .requestIdentifier)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.storefrontCountryCodes = try container.decodeIfPresent([String].self, forKey: .storefrontCountryCodes)
        self.failedCount = try container.decodeIfPresent(Int64.self, forKey: .failedCount)
        self.succeededCount = try container.decodeIfPresent(Int64.self, forKey: .succeededCount)
        if let storefrontCountryCodes = storefrontCountryCodes {
            for storefrontCountryCode in storefrontCountryCodes {
                guard storefrontCountryCode.unicodeScalars.count <= Self.maximumStorefrontCountryCodeLength else {
                    throw ValidationError.storefrontCountryCodeTooLong
                }
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if let storefrontCountryCodes = storefrontCountryCodes {
            for storefrontCountryCode in storefrontCountryCodes {
                guard storefrontCountryCode.unicodeScalars.count <= Self.maximumStorefrontCountryCodeLength else {
                    throw ValidationError.storefrontCountryCodeTooLong
                }
            }
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.requestIdentifier?.uuidString.lowercased(), forKey: .requestIdentifier)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.storefrontCountryCodes, forKey: .storefrontCountryCodes)
        try container.encodeIfPresent(self.failedCount, forKey: .failedCount)
        try container.encodeIfPresent(self.succeededCount, forKey: .succeededCount)
    }
}
