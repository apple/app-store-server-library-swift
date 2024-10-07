// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation


///Information that represents the customer’s purchase of the app, cryptographically signed by the App Store.
///
///[AppTransaction](https://developer.apple.com/documentation/storekit/apptransaction)
public struct AppTransaction: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {
    
    public init(receiptType: Environment? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, applicationVersion: String? = nil, versionExternalIdentifier: Int64? = nil, receiptCreationDate: Date? = nil, originalPurchaseDate: Date? = nil, originalApplicationVersion: String? = nil, deviceVerification: String? = nil, deviceVerificationNonce: UUID? = nil, preorderDate: Date? = nil) {
        self.receiptType = receiptType
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.applicationVersion = applicationVersion
        self.versionExternalIdentifier = versionExternalIdentifier
        self.receiptCreationDate = receiptCreationDate
        self.originalPurchaseDate = originalPurchaseDate
        self.originalApplicationVersion = originalApplicationVersion
        self.deviceVerification = deviceVerification
        self.deviceVerificationNonce = deviceVerificationNonce
        self.preorderDate = preorderDate
    }
    
    public init(rawReceiptType: String? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, applicationVersion: String? = nil, versionExternalIdentifier: Int64? = nil, receiptCreationDate: Date? = nil, originalPurchaseDate: Date? = nil, originalApplicationVersion: String? = nil, deviceVerification: String? = nil, deviceVerificationNonce: UUID? = nil, preorderDate: Date? = nil) {
        self.rawReceiptType = rawReceiptType
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.applicationVersion = applicationVersion
        self.versionExternalIdentifier = versionExternalIdentifier
        self.receiptCreationDate = receiptCreationDate
        self.originalPurchaseDate = originalPurchaseDate
        self.originalApplicationVersion = originalApplicationVersion
        self.deviceVerification = deviceVerification
        self.deviceVerificationNonce = deviceVerificationNonce
        self.preorderDate = preorderDate
    }
    
    ///The server environment that signs the app transaction.
    ///
    ///[environment](https://developer.apple.com/documentation/storekit/apptransaction/3963901-environment)
    public var receiptType: Environment?  {
        get {
            return rawReceiptType.flatMap { Environment(rawValue: $0) }
        }
        set {
            self.rawReceiptType = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``receiptType``
    public var rawReceiptType: String?
    
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
    
    
    public enum CodingKeys: CodingKey {
        case receiptType
        case appAppleId
        case bundleId
        case applicationVersion
        case versionExternalIdentifier
        case receiptCreationDate
        case originalPurchaseDate
        case originalApplicationVersion
        case deviceVerification
        case deviceVerificationNonce
        case preorderDate
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawReceiptType = try container.decodeIfPresent(String.self, forKey: .receiptType)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.applicationVersion = try container.decodeIfPresent(String.self, forKey: .applicationVersion)
        self.versionExternalIdentifier = try container.decodeIfPresent(Int64.self, forKey: .versionExternalIdentifier)
        self.receiptCreationDate = try container.decodeIfPresent(Date.self, forKey: .receiptCreationDate)
        self.originalPurchaseDate = try container.decodeIfPresent(Date.self, forKey: .originalPurchaseDate)
        self.originalApplicationVersion = try container.decodeIfPresent(String.self, forKey: .originalApplicationVersion)
        self.deviceVerification = try container.decodeIfPresent(String.self, forKey: .deviceVerification)
        self.deviceVerificationNonce = try container.decodeIfPresent(UUID.self, forKey: .deviceVerificationNonce)
        self.preorderDate = try container.decodeIfPresent(Date.self, forKey: .preorderDate)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawReceiptType, forKey: .receiptType)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.applicationVersion, forKey: .applicationVersion)
        try container.encodeIfPresent(self.versionExternalIdentifier, forKey: .versionExternalIdentifier)
        try container.encodeIfPresent(self.receiptCreationDate, forKey: .receiptCreationDate)
        try container.encodeIfPresent(self.originalPurchaseDate, forKey: .originalPurchaseDate)
        try container.encodeIfPresent(self.originalApplicationVersion, forKey: .originalApplicationVersion)
        try container.encodeIfPresent(self.deviceVerification, forKey: .deviceVerification)
        try container.encodeIfPresent(self.deviceVerificationNonce, forKey: .deviceVerificationNonce)
        try container.encodeIfPresent(self.preorderDate, forKey: .preorderDate)
    }
}
