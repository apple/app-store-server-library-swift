// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///A decoded legacy App Store receipt (the PKCS#7 app receipt).
///
///[receipt](https://developer.apple.com/documentation/appstorereceipts/responsebody/receipt)
public struct AppReceipt: Hashable, Sendable {

    public init(receiptType: String? = nil, bundleId: String? = nil, bundleIdBytes: Data? = nil, applicationVersion: String? = nil, opaqueValue: Data? = nil, sha1Hash: Data? = nil, receiptCreationDate: Date? = nil, originalPurchaseDate: Date? = nil, originalApplicationVersion: String? = nil, expirationDate: Date? = nil, inAppPurchases: [InAppPurchaseReceipt] = [], unknownAttributes: [Int64: [Data]] = [:]) {
        self.receiptType = receiptType
        self.bundleId = bundleId
        self.bundleIdBytes = bundleIdBytes
        self.applicationVersion = applicationVersion
        self.opaqueValue = opaqueValue
        self.sha1Hash = sha1Hash
        self.receiptCreationDate = receiptCreationDate
        self.originalPurchaseDate = originalPurchaseDate
        self.originalApplicationVersion = originalApplicationVersion
        self.expirationDate = expirationDate
        self.inAppPurchases = inAppPurchases
        self.unknownAttributes = unknownAttributes
    }

    ///The raw receipt type, e.g. `Production`, `ProductionVPP`, `ProductionSandbox`, `ProductionVPPSandbox` or `Xcode`.
    public var receiptType: String?

    ///The bundle identifier of the app the receipt belongs to.
    public var bundleId: String?

    ///The raw ASN.1 bytes of the bundle identifier attribute, needed together with ``opaqueValue`` and ``sha1Hash``
    ///to compute the device-hash binding described in Apple's receipt validation guide.
    public var bundleIdBytes: Data?

    ///The app's version number.
    public var applicationVersion: String?

    ///An opaque value used, with other data, to compute the device hash.
    public var opaqueValue: Data?

    ///The SHA-1 device-hash attribute of the receipt.
    public var sha1Hash: Data?

    ///The time the App Store generated the receipt.
    public var receiptCreationDate: Date?

    ///The time of the original app purchase.
    public var originalPurchaseDate: Date?

    ///The version of the app that the user originally purchased.
    public var originalApplicationVersion: String?

    ///The expiration date of the receipt. Present for apps purchased through the Volume Purchase Program.
    public var expirationDate: Date?

    ///The decoded in-app purchase attributes contained in the receipt.
    public var inAppPurchases: [InAppPurchaseReceipt]

    ///Attribute types this library does not model, keyed by type, with the verified-but-undecoded value bytes,
    ///so fields Apple adds later remain accessible without a library update.
    public var unknownAttributes: [Int64: [Data]]
}
