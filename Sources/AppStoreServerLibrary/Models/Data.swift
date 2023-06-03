// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The app metadata and the signed renewal and transaction information.
///
///[data](https://developer.apple.com/documentation/appstoreservernotifications/data)
public struct Data: Decodable, Encodable, Hashable {
    
    ///The server environment that the notification applies to, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreservernotifications/environment)
    public var environment: Environment?
    
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
}
