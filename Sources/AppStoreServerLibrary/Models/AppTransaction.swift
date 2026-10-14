// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///A decoded payload that contains app transaction information.
///
///[AppTransaction](https://developer.apple.com/documentation/storekit/apptransaction)
///[JWSAppTransactionDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwsapptransactiondecodedpayload)
public struct AppTransaction: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {

    public init(appAppleId: Int64? = nil, appTransactionId: String? = nil, bundleId: String? = nil, originalApplicationVersion: String? = nil, originalPlatform: PurchasePlatform? = nil, originalPurchaseDate: Date? = nil, preorderDate: Date? = nil, receiptCreationDate: Date? = nil, receiptType: AppStoreEnvironment? = nil, storeType: StoreType? = nil, applicationVersion: String? = nil, versionExternalIdentifier: Int64? = nil, deviceVerification: String? = nil, deviceVerificationNonce: UUID? = nil) {
        self.init(appAppleId: appAppleId, appTransactionId: appTransactionId, bundleId: bundleId, originalApplicationVersion: originalApplicationVersion, rawOriginalPlatform: originalPlatform?.rawValue, originalPurchaseDate: originalPurchaseDate, preorderDate: preorderDate, receiptCreationDate: receiptCreationDate, rawReceiptType: receiptType?.rawValue, rawStoreType: storeType?.rawValue, applicationVersion: applicationVersion, versionExternalIdentifier: versionExternalIdentifier, deviceVerification: deviceVerification, deviceVerificationNonce: deviceVerificationNonce)
    }

    @_disfavoredOverload
    public init(appAppleId: Int64? = nil, appTransactionId: String? = nil, bundleId: String? = nil, originalApplicationVersion: String? = nil, rawOriginalPlatform: String? = nil, originalPurchaseDate: Date? = nil, preorderDate: Date? = nil, receiptCreationDate: Date? = nil, rawReceiptType: String? = nil, rawStoreType: String? = nil, applicationVersion: String? = nil, versionExternalIdentifier: Int64? = nil, deviceVerification: String? = nil, deviceVerificationNonce: UUID? = nil) {
        self.appAppleId = appAppleId
        self.appTransactionId = appTransactionId
        self.bundleId = bundleId
        self.originalApplicationVersion = originalApplicationVersion
        self.rawOriginalPlatform = rawOriginalPlatform
        self.originalPurchaseDate = originalPurchaseDate
        self.preorderDate = preorderDate
        self.receiptCreationDate = receiptCreationDate
        self.rawReceiptType = rawReceiptType
        self.rawStoreType = rawStoreType
        self.applicationVersion = applicationVersion
        self.versionExternalIdentifier = versionExternalIdentifier
        self.deviceVerification = deviceVerification
        self.deviceVerificationNonce = deviceVerificationNonce
    }

    ///The unique identifier the App Store uses to identify the app.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreserverapi/appappleid)
    public var appAppleId: Int64?

    ///The unique identifier of the app download transaction.
    ///
    ///[appTransactionId](https://developer.apple.com/documentation/appstoreserverapi/apptransactionid)
    public var appTransactionId: String?

    ///The bundle identifier that the app transaction applies to.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    ///The app version that the customer originally purchased from the App Store.
    ///
    ///[originalApplicationVersion](https://developer.apple.com/documentation/appstoreserverapi/originalapplicationversion)
    public var originalApplicationVersion: String?

    ///The platform on which the customer originally purchased the app.
    ///
    ///[originalPlatform](https://developer.apple.com/documentation/appstoreserverapi/originalplatform)
    public var originalPlatform: PurchasePlatform? {
        get {
            return rawOriginalPlatform.flatMap { PurchasePlatform(rawValue: $0) }
        }
        set {
            self.rawOriginalPlatform = newValue.map { $0.rawValue }
        }
    }

    ///See ``originalPlatform``
    public var rawOriginalPlatform: String?

    ///The date the customer originally purchased the app from the App Store.
    ///
    ///[originalPurchaseDate](https://developer.apple.com/documentation/appstoreserverapi/originalpurchasedate)
    public var originalPurchaseDate: Date?

    ///The date the customer placed an order for the app before it’s available in the App Store.
    ///
    ///[preorderDate](https://developer.apple.com/documentation/appstoreserverapi/preorderdate)
    public var preorderDate: Date?

    ///The date that the App Store signed the JWS app transaction.
    ///
    ///[receiptCreationDate](https://developer.apple.com/documentation/appstoreserverapi/receiptcreationdate)
    public var signedDateOptional: Date? {
        receiptCreationDate
    }

    ///The date that the App Store signed the JWS app transaction.
    ///
    ///[receiptCreationDate](https://developer.apple.com/documentation/appstoreserverapi/receiptcreationdate)
    public var receiptCreationDate: Date?

    ///The server environment, production or sandbox, that signed the app transaction.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
    public var receiptType: AppStoreEnvironment? {
        get {
            return rawReceiptType.flatMap { AppStoreEnvironment(rawValue: $0) }
        }
        set {
            self.rawReceiptType = newValue.map { $0.rawValue }
        }
    }

    ///See ``receiptType``
    public var rawReceiptType: String?

    ///The store the customer obtained the app from.
    ///
    ///[storeType](https://developer.apple.com/documentation/appstoreserverapi/storetype)
    public var storeType: StoreType? {
        get {
            return rawStoreType.flatMap { StoreType(rawValue: $0) }
        }
        set {
            self.rawStoreType = newValue.map { $0.rawValue }
        }
    }

    ///See ``storeType``
    public var rawStoreType: String?

    ///The app version that the app transaction applies to.
    ///
    ///[appVersion](https://developer.apple.com/documentation/storekit/apptransaction/appversion)
    public var applicationVersion: String?

    ///The number that the App Store uses to uniquely identify the version of the app.
    ///
    ///[appVersionID](https://developer.apple.com/documentation/storekit/apptransaction/appversionid)
    public var versionExternalIdentifier: Int64?

    ///The device verification value to use to verify whether the app transaction belongs to the device.
    ///
    ///[deviceVerification](https://developer.apple.com/documentation/storekit/apptransaction/deviceverification)
    public var deviceVerification: String?

    ///The UUID used to compute the device verification value.
    ///
    ///[deviceVerificationNonce](https://developer.apple.com/documentation/storekit/apptransaction/deviceverificationnonce)
    public var deviceVerificationNonce: UUID?

    public enum CodingKeys: CodingKey {
        case appAppleId
        case appTransactionId
        case bundleId
        case originalApplicationVersion
        case originalPlatform
        case originalPurchaseDate
        case preorderDate
        case receiptCreationDate
        case receiptType
        case storeType
        case applicationVersion
        case versionExternalIdentifier
        case deviceVerification
        case deviceVerificationNonce
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.appTransactionId = try container.decodeIfPresent(String.self, forKey: .appTransactionId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.originalApplicationVersion = try container.decodeIfPresent(String.self, forKey: .originalApplicationVersion)
        self.rawOriginalPlatform = try container.decodeIfPresent(String.self, forKey: .originalPlatform)
        self.originalPurchaseDate = try container.decodeIfPresent(Double.self, forKey: .originalPurchaseDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.preorderDate = try container.decodeIfPresent(Double.self, forKey: .preorderDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.receiptCreationDate = try container.decodeIfPresent(Double.self, forKey: .receiptCreationDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.rawReceiptType = try container.decodeIfPresent(String.self, forKey: .receiptType)
        self.rawStoreType = try container.decodeIfPresent(String.self, forKey: .storeType)
        self.applicationVersion = try container.decodeIfPresent(String.self, forKey: .applicationVersion)
        self.versionExternalIdentifier = try container.decodeIfPresent(Int64.self, forKey: .versionExternalIdentifier)
        self.deviceVerification = try container.decodeIfPresent(String.self, forKey: .deviceVerification)
        self.deviceVerificationNonce = try container.decodeIfPresent(UUID.self, forKey: .deviceVerificationNonce)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.appTransactionId, forKey: .appTransactionId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.originalApplicationVersion, forKey: .originalApplicationVersion)
        try container.encodeIfPresent(self.rawOriginalPlatform, forKey: .originalPlatform)
        try container.encodeIfPresent(self.originalPurchaseDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .originalPurchaseDate)
        try container.encodeIfPresent(self.preorderDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .preorderDate)
        try container.encodeIfPresent(self.receiptCreationDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .receiptCreationDate)
        try container.encodeIfPresent(self.rawReceiptType, forKey: .receiptType)
        try container.encodeIfPresent(self.rawStoreType, forKey: .storeType)
        try container.encodeIfPresent(self.applicationVersion, forKey: .applicationVersion)
        try container.encodeIfPresent(self.versionExternalIdentifier, forKey: .versionExternalIdentifier)
        try container.encodeIfPresent(self.deviceVerification, forKey: .deviceVerification)
        try container.encodeIfPresent(self.deviceVerificationNonce?.uuidString.lowercased(), forKey: .deviceVerificationNonce)
    }
}
