// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The object that contains the app metadata and signed app transaction information.
///
///[appData](https://developer.apple.com/documentation/appstoreservernotifications/appdata)
public struct AppData: Decodable, Encodable, Hashable, Sendable {

    public init(appAppleId: Int64? = nil, bundleId: String? = nil, environment: AppStoreEnvironment? = nil, signedAppTransactionInfo: String? = nil) {
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.environment = environment
        self.signedAppTransactionInfo = signedAppTransactionInfo
    }

    public init(appAppleId: Int64? = nil, bundleId: String? = nil, rawEnvironment: String? = nil, signedAppTransactionInfo: String? = nil) {
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.rawEnvironment = rawEnvironment
        self.signedAppTransactionInfo = signedAppTransactionInfo
    }

    ///The unique identifier of the app that the notification applies to.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?

    ///The bundle identifier of the app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreservernotifications/bundleid)
    public var bundleId: String?

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

    ///App transaction information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSAppTransaction](https://developer.apple.com/documentation/appstoreservernotifications/jwsapptransaction)
    public var signedAppTransactionInfo: String?

    public enum CodingKeys: CodingKey {
        case appAppleId
        case bundleId
        case environment
        case signedAppTransactionInfo
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.signedAppTransactionInfo = try container.decodeIfPresent(String.self, forKey: .signedAppTransactionInfo)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.signedAppTransactionInfo, forKey: .signedAppTransactionInfo)
    }
}
