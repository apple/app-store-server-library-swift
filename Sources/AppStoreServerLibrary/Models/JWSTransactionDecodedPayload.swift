// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A decoded payload containing transaction information.
///
///[JWSTransactionDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwstransactiondecodedpayload)
public struct JWSTransactionDecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {
    
    public init(originalTransactionId: String? = nil, transactionId: String? = nil, webOrderLineItemId: String? = nil, bundleId: String? = nil, productId: String? = nil, subscriptionGroupIdentifier: String? = nil, purchaseDate: Date? = nil, originalPurchaseDate: Date? = nil, expiresDate: Date? = nil, quantity: Int32? = nil, type: ProductType? = nil, appAccountToken: UUID? = nil, inAppOwnershipType: InAppOwnershipType? = nil, signedDate: Date? = nil, revocationReason: RevocationReason? = nil, revocationDate: Date? = nil, isUpgraded: Bool? = nil, offerType: OfferType? = nil, offerIdentifier: String? = nil, environment: Environment? = nil, storefront: String? = nil, storefrontId: String? = nil, transactionReason: TransactionReason? = nil, currency: String? = nil, price: Int64? = nil, offerDiscountType: OfferDiscountType? = nil) {
        self.originalTransactionId = originalTransactionId
        self.transactionId = transactionId
        self.webOrderLineItemId = webOrderLineItemId
        self.bundleId = bundleId
        self.productId = productId
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.purchaseDate = purchaseDate
        self.originalPurchaseDate = originalPurchaseDate
        self.expiresDate = expiresDate
        self.quantity = quantity
        self.type = type
        self.appAccountToken = appAccountToken
        self.inAppOwnershipType = inAppOwnershipType
        self.signedDate = signedDate
        self.revocationReason = revocationReason
        self.revocationDate = revocationDate
        self.isUpgraded = isUpgraded
        self.offerType = offerType
        self.offerIdentifier = offerIdentifier
        self.environment = environment
        self.storefront = storefront
        self.storefrontId = storefrontId
        self.transactionReason = transactionReason
        self.currency = currency
        self.price = price
        self.offerDiscountType = offerDiscountType
    }
    
    public init(originalTransactionId: String? = nil, transactionId: String? = nil, webOrderLineItemId: String? = nil, bundleId: String? = nil, productId: String? = nil, subscriptionGroupIdentifier: String? = nil, purchaseDate: Date? = nil, originalPurchaseDate: Date? = nil, expiresDate: Date? = nil, quantity: Int32? = nil, rawType: String? = nil, appAccountToken: UUID? = nil, rawInAppOwnershipType: String? = nil, signedDate: Date? = nil, rawRevocationReason: Int32? = nil, revocationDate: Date? = nil, isUpgraded: Bool? = nil, rawOfferType: Int32? = nil, offerIdentifier: String? = nil, rawEnvironment: String? = nil, storefront: String? = nil, storefrontId: String? = nil, rawTransactionReason: String? = nil, currency: String? = nil, price: Int64? = nil, rawOfferDiscountType: String? = nil) {
        self.originalTransactionId = originalTransactionId
        self.transactionId = transactionId
        self.webOrderLineItemId = webOrderLineItemId
        self.bundleId = bundleId
        self.productId = productId
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.purchaseDate = purchaseDate
        self.originalPurchaseDate = originalPurchaseDate
        self.expiresDate = expiresDate
        self.quantity = quantity
        self.rawType = rawType
        self.appAccountToken = appAccountToken
        self.rawInAppOwnershipType = rawInAppOwnershipType
        self.signedDate = signedDate
        self.rawRevocationReason = rawRevocationReason
        self.revocationDate = revocationDate
        self.isUpgraded = isUpgraded
        self.rawOfferType = rawOfferType
        self.offerIdentifier = offerIdentifier
        self.rawEnvironment = rawEnvironment
        self.storefront = storefront
        self.storefrontId = storefrontId
        self.rawTransactionReason = rawTransactionReason
        self.currency = currency
        self.price = price
        self.rawOfferDiscountType = rawOfferDiscountType
    }
    
    ///The original transaction identifier of a purchase.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?
    
    ///The unique identifier for a transaction such as an in-app purchase, restored in-app purchase, or subscription renewal.
    ///
    ///[transactionId](https://developer.apple.com/documentation/appstoreserverapi/transactionid)
    public var transactionId: String?
                    
    ///The unique identifier of subscription-purchase events across devices, including renewals.
    ///
    ///[webOrderLineItemId](https://developer.apple.com/documentation/appstoreserverapi/weborderlineitemid)
    public var webOrderLineItemId: String?

    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    ///The unique identifier for the product, that you create in App Store Connect.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?

    ///The identifier of the subscription group that the subscription belongs to.
    ///
    ///[subscriptionGroupIdentifier](https://developer.apple.com/documentation/appstoreserverapi/subscriptiongroupidentifier)
    public var subscriptionGroupIdentifier: String?

    ///The time that the App Store charged the user’s account for an in-app purchase, a restored in-app purchase, a subscription, or a subscription renewal after a lapse.
    ///
    ///[purchaseDate](https://developer.apple.com/documentation/appstoreserverapi/purchasedate)
    public var purchaseDate: Date?

    ///The purchase date of the transaction associated with the original transaction identifier.
    ///
    ///[originalPurchaseDate](https://developer.apple.com/documentation/appstoreserverapi/originalpurchasedate)
    public var originalPurchaseDate: Date?

    ///The UNIX time, in milliseconds, an auto-renewable subscription expires or renews.
    ///
    ///[expiresDate](https://developer.apple.com/documentation/appstoreserverapi/expiresdate)
    public var expiresDate: Date?

    ///The number of consumable products purchased.
    ///
    ///[quantity](https://developer.apple.com/documentation/appstoreserverapi/quantity)
    public var quantity: Int32?

    ///The type of the in-app purchase.
    ///
    /// [type](https://developer.apple.com/documentation/appstoreserverapi/type)
    public var type: ProductType? {
        get {
            return rawType.flatMap { ProductType(rawValue: $0) }
        }
        set {
            self.rawType = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``type``
    public var rawType: String?

    ///The UUID that an app optionally generates to map a customer’s in-app purchase with its resulting App Store transaction.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID?

    ///A string that describes whether the transaction was purchased by the user, or is available to them through Family Sharing.
    ///
    ///[inAppOwnershipType](https://developer.apple.com/documentation/appstoreserverapi/inappownershiptype)
    public var inAppOwnershipType: InAppOwnershipType? {
        get {
            return rawInAppOwnershipType.flatMap { InAppOwnershipType(rawValue: $0) }
        }
        set {
            self.rawInAppOwnershipType = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``inAppOwnershipType``
    public var rawInAppOwnershipType: String?

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreserverapi/signeddate)
    public var signedDate: Date?

    ///The reason that the App Store refunded the transaction or revoked it from family sharing.
    ///
    ///[revocationReason](https://developer.apple.com/documentation/appstoreserverapi/revocationreason)
    public var revocationReason: RevocationReason? {
        get {
            return rawRevocationReason.flatMap { RevocationReason(rawValue: $0) }
        }
        set {
            self.rawRevocationReason = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``revocationReason``
    public var rawRevocationReason: Int32?

    ///The UNIX time, in milliseconds, that Apple Support refunded a transaction.
    ///
    /// [revocationDate](https://developer.apple.com/documentation/appstoreserverapi/revocationdate)
    public var revocationDate: Date?

    ///The Boolean value that indicates whether the user upgraded to another subscription.
    ///
    ///[isUpgraded](https://developer.apple.com/documentation/appstoreserverapi/isupgraded)
    public var isUpgraded: Bool?

    ///A value that represents the promotional offer type.
    ///
    ///[offerType](https://developer.apple.com/documentation/appstoreserverapi/offertype)
    public var offerType: OfferType? {
        get {
            return rawOfferType.flatMap { OfferType(rawValue: $0) }
        }
        set {
            self.rawOfferType = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``offerType``
    public var rawOfferType: Int32?

    ///The identifier that contains the promo code or the promotional offer identifier.
    ///
    ///[offerIdentifier](https://developer.apple.com/documentation/appstoreserverapi/offeridentifier)
    public var offerIdentifier: String?

    ///The server environment, either sandbox or production.
    ///
    /// [environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
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

    ///The three-letter code that represents the country or region associated with the App Store storefront for the purchase.
    ///
    ///[storefront](https://developer.apple.com/documentation/appstoreserverapi/storefront)
    public var storefront: String?

    ///An Apple-defined value that uniquely identifies the App Store storefront associated with the purchase.
    ///
    ///[storefrontId](https://developer.apple.com/documentation/appstoreserverapi/storefrontid)
    public var storefrontId: String?

    ///The reason for the purchase transaction, which indicates whether it’s a customer’s purchase or a renewal for an auto-renewable subscription that the system initiates.
    ///
    ///[transactionReason](https://developer.apple.com/documentation/appstoreserverapi/transactionreason)
    public var transactionReason: TransactionReason? {
        get {
            return rawTransactionReason.flatMap { TransactionReason(rawValue: $0) }
        }
        set {
            self.rawTransactionReason = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``transactionReason``
    public var rawTransactionReason: String?

    ///The three-letter ISO 4217 currency code for the price of the product.
    ///
    ///[currency](https://developer.apple.com/documentation/appstoreserverapi/currency)
    public var currency: String?

    ///The price, in milliunits, of the in-app purchase or subscription offer that you configured in App Store Connect.
    ///
    ///[price](https://developer.apple.com/documentation/appstoreserverapi/price)
    public var price: Int64?

    ///The payment mode you configure for an introductory offer, promotional offer, or offer code on an auto-renewable subscription.
    ///
    ///[offerDiscountType](https://developer.apple.com/documentation/appstoreserverapi/offerdiscounttype)
    public var offerDiscountType: OfferDiscountType? {
        get {
            return rawOfferDiscountType.flatMap { OfferDiscountType(rawValue: $0) }
        }
        set {
            self.rawOfferDiscountType = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``offerDiscountType``
    public var rawOfferDiscountType: String?
    
    public enum CodingKeys: CodingKey {
        case originalTransactionId
        case transactionId
        case webOrderLineItemId
        case bundleId
        case productId
        case subscriptionGroupIdentifier
        case purchaseDate
        case originalPurchaseDate
        case expiresDate
        case quantity
        case type
        case appAccountToken
        case inAppOwnershipType
        case signedDate
        case revocationReason
        case revocationDate
        case isUpgraded
        case offerType
        case offerIdentifier
        case environment
        case storefront
        case storefrontId
        case transactionReason
        case currency
        case price
        case offerDiscountType
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.originalTransactionId = try container.decodeIfPresent(String.self, forKey: .originalTransactionId)
        self.transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
        self.webOrderLineItemId = try container.decodeIfPresent(String.self, forKey: .webOrderLineItemId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.subscriptionGroupIdentifier = try container.decodeIfPresent(String.self, forKey: .subscriptionGroupIdentifier)
        self.purchaseDate = try container.decodeIfPresent(Date.self, forKey: .purchaseDate)
        self.originalPurchaseDate = try container.decodeIfPresent(Date.self, forKey: .originalPurchaseDate)
        self.expiresDate = try container.decodeIfPresent(Date.self, forKey: .expiresDate)
        self.quantity = try container.decodeIfPresent(Int32.self, forKey: .quantity)
        self.rawType = try container.decodeIfPresent(String.self, forKey: .type)
        self.appAccountToken = try container.decodeIfPresent(UUID.self, forKey: .appAccountToken)
        self.rawInAppOwnershipType = try container.decodeIfPresent(String.self, forKey: .inAppOwnershipType)
        self.signedDate = try container.decodeIfPresent(Date.self, forKey: .signedDate)
        self.rawRevocationReason = try container.decodeIfPresent(Int32.self, forKey: .revocationReason)
        self.revocationDate = try container.decodeIfPresent(Date.self, forKey: .revocationDate)
        self.isUpgraded = try container.decodeIfPresent(Bool.self, forKey: .isUpgraded)
        self.rawOfferType = try container.decodeIfPresent(Int32.self, forKey: .offerType)
        self.offerIdentifier = try container.decodeIfPresent(String.self, forKey: .offerIdentifier)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.storefrontId = try container.decodeIfPresent(String.self, forKey: .storefrontId)
        self.rawTransactionReason = try container.decodeIfPresent(String.self, forKey: .transactionReason)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.price = try container.decodeIfPresent(Int64.self, forKey: .price)
        self.rawOfferDiscountType = try container.decodeIfPresent(String.self, forKey: .offerDiscountType)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encodeIfPresent(self.transactionId, forKey: .transactionId)
        try container.encodeIfPresent(self.webOrderLineItemId, forKey: .webOrderLineItemId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.subscriptionGroupIdentifier, forKey: .subscriptionGroupIdentifier)
        try container.encodeIfPresent(self.purchaseDate, forKey: .purchaseDate)
        try container.encodeIfPresent(self.originalPurchaseDate, forKey: .originalPurchaseDate)
        try container.encodeIfPresent(self.expiresDate, forKey: .expiresDate)
        try container.encodeIfPresent(self.quantity, forKey: .quantity)
        try container.encodeIfPresent(self.rawType, forKey: .type)
        try container.encodeIfPresent(self.appAccountToken, forKey: .appAccountToken)
        try container.encodeIfPresent(self.rawInAppOwnershipType, forKey: .inAppOwnershipType)
        try container.encodeIfPresent(self.signedDate, forKey: .signedDate)
        try container.encodeIfPresent(self.rawRevocationReason, forKey: .revocationReason)
        try container.encodeIfPresent(self.revocationDate, forKey: .revocationDate)
        try container.encodeIfPresent(self.isUpgraded, forKey: .isUpgraded)
        try container.encodeIfPresent(self.rawOfferType, forKey: .offerType)
        try container.encodeIfPresent(self.offerIdentifier, forKey: .offerIdentifier)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encodeIfPresent(self.storefrontId, forKey: .storefrontId)
        try container.encodeIfPresent(self.rawTransactionReason, forKey: .transactionReason)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.rawOfferDiscountType, forKey: .offerDiscountType)
    }
}
