// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The app metadata and the signed renewal and transaction information.
///
///[data](https://developer.apple.com/documentation/appstoreservernotifications/data)
public struct Data: Decodable, Encodable, Hashable {
    
    public init(environment: Environment? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, bundleVersion: String? = nil, signedTransactionInfo: String? = nil, signedRenewalInfo: String? = nil, status: Status? = nil) {
        self.environment = environment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.bundleVersion = bundleVersion
        self.signedTransactionInfo = signedTransactionInfo
        self.signedRenewalInfo = signedRenewalInfo
        self.status = status
    }
    
    public init(rawEnvironment: String? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, bundleVersion: String? = nil, signedTransactionInfo: String? = nil, signedRenewalInfo: String? = nil, rawStatus: Int32? = nil) {
        self.rawEnvironment = rawEnvironment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.bundleVersion = bundleVersion
        self.signedTransactionInfo = signedTransactionInfo
        self.signedRenewalInfo = signedRenewalInfo
        self.rawStatus = rawStatus
    }
    
    ///The server environment that the notification applies to, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreservernotifications/environment)
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
    
    ///The unique identifier of an app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?
    
    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?
    
    ///The version of the build that identifies an iteration of the bundle.
    ///
    ///[bundleVersion](https://developer.apple.com/documentation/appstoreservernotifications/bundleversion)
    public var bundleVersion: String?
    
    ///Transaction information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String?
    
    ///Subscription renewal information, signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    public var signedRenewalInfo: String?

    ///The status of an auto-renewable subscription as of the signedDate in the responseBodyV2DecodedPayload.
    ///
    ///[status](https://developer.apple.com/documentation/appstoreservernotifications/status)
    public var status: Status? {
        get {
            return rawStatus.flatMap { Status(rawValue: $0) }
        }
        set {
            self.rawStatus = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``status``
    public var rawStatus: Int32?
}
