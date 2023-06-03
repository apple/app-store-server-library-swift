// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation


///Information that represents the customer’s purchase of the app, cryptographically signed by the App Store.
///
///[AppTransaction](https://developer.apple.com/documentation/storekit/apptransaction)
public struct AppTransaction: DecodedSignedData, Decodable, Encodable, Hashable {
    
    ///The server environment that signs the app transaction.
    ///
    ///[environment](https://developer.apple.com/documentation/storekit/apptransaction/3963901-environment)
    public var receiptType: Environment?
    
    ///The unique identifier the App Store uses to identify the app.
    ///
    ///[appId](https://developer.apple.com/documentation/storekit/apptransaction/3954436-appid)
    public var appAppleId: Int64?
    
    ///The bundle identifier that the app transaction applies to.
    ///
    ///[bundleId](https://developer.apple.com/documentation/storekit/apptransaction/3954439-bundleid)
    public var bundleId: String?
    
    ///The app version that the app transaction applies to.
    ///
    ///[appVersion](https://developer.apple.com/documentation/storekit/apptransaction/3954437-appversion)
     public var applicationVersion: String?
    
    ///The version external identifier of the app
    ///
    ///[appVersionID](https://developer.apple.com/documentation/storekit/apptransaction/3954438-appversionid)
     public var versionExternalIdentifier: Int64?
    
    ///The date that the App Store signed the JWS app transaction.
    ///
    ///[signedDate](https://developer.apple.com/documentation/storekit/apptransaction/3954449-signeddate)
     public var receiptCreationDate: Date?
    
    ///The date the user originally purchased the app from the App Store.
    ///
    ///[originalPurchaseDate](https://developer.apple.com/documentation/storekit/apptransaction/3954448-originalpurchasedate)
     public var originalPurchaseDate: Date?
    
    ///The app version that the user originally purchased from the App Store.
    ///
    ///[originalAppVersion](https://developer.apple.com/documentation/storekit/apptransaction/3954447-originalappversion)
     public var originalApplicationVersion: String?
    
    ///The Base64 device verification value to use to verify whether the app transaction belongs to the device.
    ///
    ///[deviceVerification](https://developer.apple.com/documentation/storekit/apptransaction/3954441-deviceverification)
    public var deviceVerification: String?
    
    ///The UUID used to compute the device verification value.
    ///
    ///[deviceVerificationNonce](https://developer.apple.com/documentation/storekit/apptransaction/3954442-deviceverificationnonce)
    public var deviceVerificationNonce: UUID?
    
    ///The date the customer placed an order for the app before it’s available in the App Store.
    ///
    ///[preorderDate](https://developer.apple.com/documentation/storekit/apptransaction/4013175-preorderdate)
    public var preorderDate: Date?
    

    ///The date that the App Store signed the JWS app transaction.
    ///
    ///[signedDate](https://developer.apple.com/documentation/storekit/apptransaction/3954449-signeddate)
    public var signedDate: Date? {
        receiptCreationDate
    }
}
