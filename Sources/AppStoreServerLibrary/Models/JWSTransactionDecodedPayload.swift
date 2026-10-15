// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///A decoded payload that contains transaction information.
///
///[JWSTransactionDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwstransactiondecodedpayload)
public struct JWSTransactionDecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {

    private static let minimumRevocationPercentage: Int32 = 0
    private static let maximumRevocationPercentage: Int32 = 100000

    public enum ValidationError: Error {
        case revocationPercentageOutOfRange
    }

    public init(appAccountToken: UUID? = nil, appTransactionId: String? = nil, bundleId: String? = nil, currency: String? = nil, environment: AppStoreEnvironment? = nil, expiresDate: Date? = nil, inAppOwnershipType: InAppOwnershipType? = nil, isUpgraded: Bool? = nil, offerDiscountType: OfferDiscountType? = nil, offerIdentifier: String? = nil, offerPeriod: String? = nil, offerType: OfferType? = nil, originalPurchaseDate: Date? = nil, originalTransactionId: String? = nil, price: Int64? = nil, productId: String? = nil, purchaseDate: Date? = nil, quantity: Int32? = nil, revocationDate: Date? = nil, revocationPercentage: Int32? = nil, revocationReason: RevocationReason? = nil, revocationType: RevocationType? = nil, signedDate: Date? = nil, storefront: String? = nil, storefrontId: String? = nil, subscriptionGroupIdentifier: String? = nil, transactionId: String? = nil, transactionReason: TransactionReason? = nil, type: ProductType? = nil, webOrderLineItemId: String? = nil, advancedCommerceInfo: AdvancedCommerceTransactionInfo? = nil, billingPlanType: BillingPlanType? = nil, commitmentInfo: TransactionCommitmentInfo? = nil, previousOriginalTransactionId: String? = nil) throws {
        try self.init(appAccountToken: appAccountToken, appTransactionId: appTransactionId, bundleId: bundleId, currency: currency, rawEnvironment: environment?.rawValue, expiresDate: expiresDate, rawInAppOwnershipType: inAppOwnershipType?.rawValue, isUpgraded: isUpgraded, rawOfferDiscountType: offerDiscountType?.rawValue, offerIdentifier: offerIdentifier, offerPeriod: offerPeriod, rawOfferType: offerType?.rawValue, originalPurchaseDate: originalPurchaseDate, originalTransactionId: originalTransactionId, price: price, productId: productId, purchaseDate: purchaseDate, quantity: quantity, revocationDate: revocationDate, revocationPercentage: revocationPercentage, rawRevocationReason: revocationReason?.rawValue, rawRevocationType: revocationType?.rawValue, signedDate: signedDate, storefront: storefront, storefrontId: storefrontId, subscriptionGroupIdentifier: subscriptionGroupIdentifier, transactionId: transactionId, rawTransactionReason: transactionReason?.rawValue, rawType: type?.rawValue, webOrderLineItemId: webOrderLineItemId, advancedCommerceInfo: advancedCommerceInfo, rawBillingPlanType: billingPlanType?.rawValue, commitmentInfo: commitmentInfo, previousOriginalTransactionId: previousOriginalTransactionId)
    }

    @_disfavoredOverload
    public init(appAccountToken: UUID? = nil, appTransactionId: String? = nil, bundleId: String? = nil, currency: String? = nil, rawEnvironment: String? = nil, expiresDate: Date? = nil, rawInAppOwnershipType: String? = nil, isUpgraded: Bool? = nil, rawOfferDiscountType: String? = nil, offerIdentifier: String? = nil, offerPeriod: String? = nil, rawOfferType: Int32? = nil, originalPurchaseDate: Date? = nil, originalTransactionId: String? = nil, price: Int64? = nil, productId: String? = nil, purchaseDate: Date? = nil, quantity: Int32? = nil, revocationDate: Date? = nil, revocationPercentage: Int32? = nil, rawRevocationReason: Int32? = nil, rawRevocationType: String? = nil, signedDate: Date? = nil, storefront: String? = nil, storefrontId: String? = nil, subscriptionGroupIdentifier: String? = nil, transactionId: String? = nil, rawTransactionReason: String? = nil, rawType: String? = nil, webOrderLineItemId: String? = nil, advancedCommerceInfo: AdvancedCommerceTransactionInfo? = nil, rawBillingPlanType: String? = nil, commitmentInfo: TransactionCommitmentInfo? = nil, previousOriginalTransactionId: String? = nil) throws {
        if let revocationPercentage = revocationPercentage {
            guard revocationPercentage >= Self.minimumRevocationPercentage && revocationPercentage <= Self.maximumRevocationPercentage else {
                throw ValidationError.revocationPercentageOutOfRange
            }
        }
        self.appAccountToken = appAccountToken
        self.appTransactionId = appTransactionId
        self.bundleId = bundleId
        self.currency = currency
        self.rawEnvironment = rawEnvironment
        self.expiresDate = expiresDate
        self.rawInAppOwnershipType = rawInAppOwnershipType
        self.isUpgraded = isUpgraded
        self.rawOfferDiscountType = rawOfferDiscountType
        self.offerIdentifier = offerIdentifier
        self.offerPeriod = offerPeriod
        self.rawOfferType = rawOfferType
        self.originalPurchaseDate = originalPurchaseDate
        self.originalTransactionId = originalTransactionId
        self.price = price
        self.productId = productId
        self.purchaseDate = purchaseDate
        self.quantity = quantity
        self.revocationDate = revocationDate
        self.revocationPercentage = revocationPercentage
        self.rawRevocationReason = rawRevocationReason
        self.rawRevocationType = rawRevocationType
        self.signedDate = signedDate
        self.storefront = storefront
        self.storefrontId = storefrontId
        self.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        self.transactionId = transactionId
        self.rawTransactionReason = rawTransactionReason
        self.rawType = rawType
        self.webOrderLineItemId = webOrderLineItemId
        self.advancedCommerceInfo = advancedCommerceInfo
        self.rawBillingPlanType = rawBillingPlanType
        self.commitmentInfo = commitmentInfo
        self.previousOriginalTransactionId = previousOriginalTransactionId
    }

    ///A UUID you create at the time of purchase that associates the transaction with a customer on your own service.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID?

    ///The unique identifier of the app download transaction.
    ///
    ///[appTransactionId](https://developer.apple.com/documentation/appstoreserverapi/apptransactionid)
    public var appTransactionId: String?

    ///The bundle identifier of the app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    ///The three-letter ISO 4217 currency code associated with the price parameter.
    ///
    ///[currency](https://developer.apple.com/documentation/appstoreserverapi/currency)
    public var currency: String?

    ///The server environment, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
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

    ///The UNIX time, in milliseconds, that the subscription expires or renews.
    ///
    ///[expiresDate](https://developer.apple.com/documentation/appstoreserverapi/expiresdate)
    public var expiresDate: Date?

    ///A string that describes whether the transaction was purchased by the customer, or is available to them through Family Sharing, an organization, or a group.
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

    ///A Boolean value that indicates whether the customer upgraded to another subscription.
    ///
    ///[isUpgraded](https://developer.apple.com/documentation/appstoreserverapi/isupgraded)
    public var isUpgraded: Bool?

    ///The payment mode you configure for the offer.
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

    ///The identifier that contains the offer code or the promotional offer identifier.
    ///
    ///[offerIdentifier](https://developer.apple.com/documentation/appstoreserverapi/offeridentifier)
    public var offerIdentifier: String?

    ///The duration of the offer applied to the transaction.
    ///
    ///[offerPeriod](https://developer.apple.com/documentation/appstoreserverapi/offerperiod)
    public var offerPeriod: String?

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

    ///The UNIX time, in milliseconds, that represents the purchase date of the original transaction identifier.
    ///
    ///[originalPurchaseDate](https://developer.apple.com/documentation/appstoreserverapi/originalpurchasedate)
    public var originalPurchaseDate: Date?

    ///The transaction identifier of the original purchase.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?

    ///An integer value that represents the price multiplied by 1000 of the in-app purchase or subscription offer you configured in App Store Connect and that the system records at the time of the purchase.
    ///
    ///[price](https://developer.apple.com/documentation/appstoreserverapi/price)
    public var price: Int64?

    ///The unique identifier of the product.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?

    ///The UNIX time, in milliseconds, that the App Store charged the customer’s account for a purchase, restored product, subscription, or subscription renewal after a lapse.
    ///
    ///[purchaseDate](https://developer.apple.com/documentation/appstoreserverapi/purchasedate)
    public var purchaseDate: Date?

    ///The number of products or seats the customer purchased.
    ///
    ///[quantity](https://developer.apple.com/documentation/appstoreserverapi/quantity)
    public var quantity: Int32?

    ///The UNIX time, in milliseconds, that the App Store refunded the transaction or revoked it from Family Sharing.
    ///
    ///[revocationDate](https://developer.apple.com/documentation/appstoreserverapi/revocationdate)
    public var revocationDate: Date?

    ///The percentage, in milliunits, of the transaction that the App Store has refunded or revoked.
    ///
    ///[revocationPercentage](https://developer.apple.com/documentation/appstoreserverapi/revocationpercentage)
    public var revocationPercentage: Int32?

    ///The reason that the App Store refunded the transaction or revoked it from Family Sharing.
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

    ///The type of the refund or revocation that applies to the transaction.
    ///
    ///[revocationType](https://developer.apple.com/documentation/appstoreserverapi/revocationtype)
    public var revocationType: RevocationType? {
        get {
            return rawRevocationType.flatMap { RevocationType(rawValue: $0) }
        }
        set {
            self.rawRevocationType = newValue.map { $0.rawValue }
        }
    }

    ///See ``revocationType``
    public var rawRevocationType: String?

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature (JWS) data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreserverapi/signeddate)
    public var signedDate: Date?

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature (JWS) data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreserverapi/signeddate)
    public var signedDateOptional: Date? {
        signedDate
    }

    ///The three-letter code that represents the country or region associated with the App Store storefront for the purchase.
    ///
    ///[storefront](https://developer.apple.com/documentation/appstoreserverapi/storefront)
    public var storefront: String?

    ///An Apple-defined value that uniquely identifies the App Store storefront associated with the purchase.
    ///
    ///[storefrontId](https://developer.apple.com/documentation/appstoreserverapi/storefrontid)
    public var storefrontId: String?

    ///The identifier of the subscription group to which the subscription belongs.
    ///
    ///[subscriptionGroupIdentifier](https://developer.apple.com/documentation/appstoreserverapi/subscriptiongroupidentifier)
    public var subscriptionGroupIdentifier: String?

    ///The unique identifier of the transaction.
    ///
    ///[transactionId](https://developer.apple.com/documentation/appstoreserverapi/transactionid)
    public var transactionId: String?

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

    ///The type of the in-app purchase.
    ///
    ///[type](https://developer.apple.com/documentation/appstoreserverapi/type)
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

    ///The unique identifier of subscription purchase events across devices, including subscription renewals.
    ///
    ///[webOrderLineItemId](https://developer.apple.com/documentation/appstoreserverapi/weborderlineitemid)
    public var webOrderLineItemId: String?

    ///Transaction information that is present only for Advanced Commerce SKUs.
    ///
    ///[advancedCommerceTransactionInfo](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetransactioninfo)
    public var advancedCommerceInfo: AdvancedCommerceTransactionInfo?

    ///[billingPlanType](https://developer.apple.com/documentation/appstoreserverapi/billingplantype)
    public var billingPlanType: BillingPlanType? {
        get {
            return rawBillingPlanType.flatMap { BillingPlanType(rawValue: $0) }
        }
        set {
            self.rawBillingPlanType = newValue.map { $0.rawValue }
        }
    }

    ///See ``billingPlanType``
    public var rawBillingPlanType: String?

    ///[TransactionCommitmentInfo](https://developer.apple.com/documentation/appstoreserverapi/transactioncommitmentinfo)
    public var commitmentInfo: TransactionCommitmentInfo?

    ///The subscription’s original transaction identifier, before you migrated the subscription.
    ///
    ///[previousOriginalTransactionId](https://developer.apple.com/documentation/appstoreservernotifications/previousoriginaltransactionid)
    public var previousOriginalTransactionId: String?

    public enum CodingKeys: CodingKey {
        case appAccountToken
        case appTransactionId
        case bundleId
        case currency
        case environment
        case expiresDate
        case inAppOwnershipType
        case isUpgraded
        case offerDiscountType
        case offerIdentifier
        case offerPeriod
        case offerType
        case originalPurchaseDate
        case originalTransactionId
        case price
        case productId
        case purchaseDate
        case quantity
        case revocationDate
        case revocationPercentage
        case revocationReason
        case revocationType
        case signedDate
        case storefront
        case storefrontId
        case subscriptionGroupIdentifier
        case transactionId
        case transactionReason
        case type
        case webOrderLineItemId
        case advancedCommerceInfo
        case billingPlanType
        case commitmentInfo
        case previousOriginalTransactionId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appAccountToken = try container.decodeIfPresent(UUID.self, forKey: .appAccountToken)
        self.appTransactionId = try container.decodeIfPresent(String.self, forKey: .appTransactionId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.expiresDate = try container.decodeIfPresent(Double.self, forKey: .expiresDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.rawInAppOwnershipType = try container.decodeIfPresent(String.self, forKey: .inAppOwnershipType)
        self.isUpgraded = try container.decodeIfPresent(Bool.self, forKey: .isUpgraded)
        self.rawOfferDiscountType = try container.decodeIfPresent(String.self, forKey: .offerDiscountType)
        self.offerIdentifier = try container.decodeIfPresent(String.self, forKey: .offerIdentifier)
        self.offerPeriod = try container.decodeIfPresent(String.self, forKey: .offerPeriod)
        self.rawOfferType = try container.decodeIfPresent(Int32.self, forKey: .offerType)
        self.originalPurchaseDate = try container.decodeIfPresent(Double.self, forKey: .originalPurchaseDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.originalTransactionId = try container.decodeIfPresent(String.self, forKey: .originalTransactionId)
        self.price = try container.decodeIfPresent(Int64.self, forKey: .price)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.purchaseDate = try container.decodeIfPresent(Double.self, forKey: .purchaseDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.quantity = try container.decodeIfPresent(Int32.self, forKey: .quantity)
        self.revocationDate = try container.decodeIfPresent(Double.self, forKey: .revocationDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.revocationPercentage = try container.decodeIfPresent(Int32.self, forKey: .revocationPercentage)
        self.rawRevocationReason = try container.decodeIfPresent(Int32.self, forKey: .revocationReason)
        self.rawRevocationType = try container.decodeIfPresent(String.self, forKey: .revocationType)
        self.signedDate = try container.decodeIfPresent(Double.self, forKey: .signedDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.storefrontId = try container.decodeIfPresent(String.self, forKey: .storefrontId)
        self.subscriptionGroupIdentifier = try container.decodeIfPresent(String.self, forKey: .subscriptionGroupIdentifier)
        self.transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
        self.rawTransactionReason = try container.decodeIfPresent(String.self, forKey: .transactionReason)
        self.rawType = try container.decodeIfPresent(String.self, forKey: .type)
        self.webOrderLineItemId = try container.decodeIfPresent(String.self, forKey: .webOrderLineItemId)
        self.advancedCommerceInfo = try container.decodeIfPresent(AdvancedCommerceTransactionInfo.self, forKey: .advancedCommerceInfo)
        self.rawBillingPlanType = try container.decodeIfPresent(String.self, forKey: .billingPlanType)
        self.commitmentInfo = try container.decodeIfPresent(TransactionCommitmentInfo.self, forKey: .commitmentInfo)
        self.previousOriginalTransactionId = try container.decodeIfPresent(String.self, forKey: .previousOriginalTransactionId)
        if let revocationPercentage = revocationPercentage {
            guard revocationPercentage >= Self.minimumRevocationPercentage && revocationPercentage <= Self.maximumRevocationPercentage else {
                throw ValidationError.revocationPercentageOutOfRange
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if let revocationPercentage = revocationPercentage {
            guard revocationPercentage >= Self.minimumRevocationPercentage && revocationPercentage <= Self.maximumRevocationPercentage else {
                throw ValidationError.revocationPercentageOutOfRange
            }
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.appAccountToken?.uuidString.lowercased(), forKey: .appAccountToken)
        try container.encodeIfPresent(self.appTransactionId, forKey: .appTransactionId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.expiresDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .expiresDate)
        try container.encodeIfPresent(self.rawInAppOwnershipType, forKey: .inAppOwnershipType)
        try container.encodeIfPresent(self.isUpgraded, forKey: .isUpgraded)
        try container.encodeIfPresent(self.rawOfferDiscountType, forKey: .offerDiscountType)
        try container.encodeIfPresent(self.offerIdentifier, forKey: .offerIdentifier)
        try container.encodeIfPresent(self.offerPeriod, forKey: .offerPeriod)
        try container.encodeIfPresent(self.rawOfferType, forKey: .offerType)
        try container.encodeIfPresent(self.originalPurchaseDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .originalPurchaseDate)
        try container.encodeIfPresent(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.purchaseDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .purchaseDate)
        try container.encodeIfPresent(self.quantity, forKey: .quantity)
        try container.encodeIfPresent(self.revocationDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .revocationDate)
        try container.encodeIfPresent(self.revocationPercentage, forKey: .revocationPercentage)
        try container.encodeIfPresent(self.rawRevocationReason, forKey: .revocationReason)
        try container.encodeIfPresent(self.rawRevocationType, forKey: .revocationType)
        try container.encodeIfPresent(self.signedDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .signedDate)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encodeIfPresent(self.storefrontId, forKey: .storefrontId)
        try container.encodeIfPresent(self.subscriptionGroupIdentifier, forKey: .subscriptionGroupIdentifier)
        try container.encodeIfPresent(self.transactionId, forKey: .transactionId)
        try container.encodeIfPresent(self.rawTransactionReason, forKey: .transactionReason)
        try container.encodeIfPresent(self.rawType, forKey: .type)
        try container.encodeIfPresent(self.webOrderLineItemId, forKey: .webOrderLineItemId)
        try container.encodeIfPresent(self.advancedCommerceInfo, forKey: .advancedCommerceInfo)
        try container.encodeIfPresent(self.rawBillingPlanType, forKey: .billingPlanType)
        try container.encodeIfPresent(self.commitmentInfo, forKey: .commitmentInfo)
        try container.encodeIfPresent(self.previousOriginalTransactionId, forKey: .previousOriginalTransactionId)
    }
}
