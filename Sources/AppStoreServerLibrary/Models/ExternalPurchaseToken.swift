// Copyright (c) 2024 Apple Inc. Licensed under MIT License.

///The payload data that contains an external purchase token.
///
///[externalPurchaseToken](https://developer.apple.com/documentation/appstoreservernotifications/externalpurchasetoken)
public struct ExternalPurchaseToken: Decodable, Encodable, Hashable {
    
    public init(externalPurchaseId: String? = nil, tokenCreationDate: Int64? = nil, appAppleId: Int64? = nil, bundleId: String? = nil) {
        self.externalPurchaseId = externalPurchaseId
        self.tokenCreationDate = tokenCreationDate
        self.appAppleId = appAppleId
        self.bundleId = bundleId
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
}
