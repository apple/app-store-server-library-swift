// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///A decoded payload containing subscription renewal information for an auto-renewable subscription.
///
///[JWSRenewalInfoDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfodecodedpayload)
public struct JWSRenewalInfoDecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {

    public init(appAccountToken: UUID? = nil, appTransactionId: String? = nil, autoRenewProductId: String? = nil, autoRenewStatus: AutoRenewStatus? = nil, currency: String? = nil, eligibleWinBackOfferIds: [String]? = nil, environment: AppStoreEnvironment? = nil, expirationIntent: ExpirationIntent? = nil, gracePeriodExpiresDate: Date? = nil, isInBillingRetryPeriod: Bool? = nil, offerDiscountType: OfferDiscountType? = nil, offerIdentifier: String? = nil, offerPeriod: String? = nil, offerType: OfferType? = nil, originalTransactionId: String? = nil, priceIncreaseStatus: PriceIncreaseStatus? = nil, productId: String? = nil, recentSubscriptionStartDate: Date? = nil, renewalDate: Date? = nil, renewalPrice: Int64? = nil, signedDate: Date? = nil, advancedCommerceInfo: AdvancedCommerceRenewalInfo? = nil, commitmentInfo: RenewalCommitmentInfo? = nil, renewalBillingPlanType: RenewalBillingPlanType? = nil) {
        self.init(appAccountToken: appAccountToken, appTransactionId: appTransactionId, autoRenewProductId: autoRenewProductId, rawAutoRenewStatus: autoRenewStatus?.rawValue, currency: currency, eligibleWinBackOfferIds: eligibleWinBackOfferIds, rawEnvironment: environment?.rawValue, rawExpirationIntent: expirationIntent?.rawValue, gracePeriodExpiresDate: gracePeriodExpiresDate, isInBillingRetryPeriod: isInBillingRetryPeriod, rawOfferDiscountType: offerDiscountType?.rawValue, offerIdentifier: offerIdentifier, offerPeriod: offerPeriod, rawOfferType: offerType?.rawValue, originalTransactionId: originalTransactionId, rawPriceIncreaseStatus: priceIncreaseStatus?.rawValue, productId: productId, recentSubscriptionStartDate: recentSubscriptionStartDate, renewalDate: renewalDate, renewalPrice: renewalPrice, signedDate: signedDate, advancedCommerceInfo: advancedCommerceInfo, commitmentInfo: commitmentInfo, rawRenewalBillingPlanType: renewalBillingPlanType?.rawValue)
    }

    @_disfavoredOverload
    public init(appAccountToken: UUID? = nil, appTransactionId: String? = nil, autoRenewProductId: String? = nil, rawAutoRenewStatus: Int32? = nil, currency: String? = nil, eligibleWinBackOfferIds: [String]? = nil, rawEnvironment: String? = nil, rawExpirationIntent: Int32? = nil, gracePeriodExpiresDate: Date? = nil, isInBillingRetryPeriod: Bool? = nil, rawOfferDiscountType: String? = nil, offerIdentifier: String? = nil, offerPeriod: String? = nil, rawOfferType: Int32? = nil, originalTransactionId: String? = nil, rawPriceIncreaseStatus: Int32? = nil, productId: String? = nil, recentSubscriptionStartDate: Date? = nil, renewalDate: Date? = nil, renewalPrice: Int64? = nil, signedDate: Date? = nil, advancedCommerceInfo: AdvancedCommerceRenewalInfo? = nil, commitmentInfo: RenewalCommitmentInfo? = nil, rawRenewalBillingPlanType: String? = nil) {
        self.appAccountToken = appAccountToken
        self.appTransactionId = appTransactionId
        self.autoRenewProductId = autoRenewProductId
        self.rawAutoRenewStatus = rawAutoRenewStatus
        self.currency = currency
        self.eligibleWinBackOfferIds = eligibleWinBackOfferIds
        self.rawEnvironment = rawEnvironment
        self.rawExpirationIntent = rawExpirationIntent
        self.gracePeriodExpiresDate = gracePeriodExpiresDate
        self.isInBillingRetryPeriod = isInBillingRetryPeriod
        self.rawOfferDiscountType = rawOfferDiscountType
        self.offerIdentifier = offerIdentifier
        self.offerPeriod = offerPeriod
        self.rawOfferType = rawOfferType
        self.originalTransactionId = originalTransactionId
        self.rawPriceIncreaseStatus = rawPriceIncreaseStatus
        self.productId = productId
        self.recentSubscriptionStartDate = recentSubscriptionStartDate
        self.renewalDate = renewalDate
        self.renewalPrice = renewalPrice
        self.signedDate = signedDate
        self.advancedCommerceInfo = advancedCommerceInfo
        self.commitmentInfo = commitmentInfo
        self.rawRenewalBillingPlanType = rawRenewalBillingPlanType
    }

    ///A UUID you create at the time of purchase that associates the transaction with a customer on your own service.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID?

    ///The unique identifier of the app download transaction.
    ///
    ///[appTransactionId](https://developer.apple.com/documentation/appstoreserverapi/apptransactionid)
    public var appTransactionId: String?

    ///The identifier of the product that renews at the next billing period.
    ///
    ///[autoRenewProductId](https://developer.apple.com/documentation/appstoreserverapi/autorenewproductid)
    public var autoRenewProductId: String?

    ///The renewal status of the auto-renewable subscription.
    ///
    ///[autoRenewStatus](https://developer.apple.com/documentation/appstoreserverapi/autorenewstatus)
    public var autoRenewStatus: AutoRenewStatus? {
        get {
            return rawAutoRenewStatus.flatMap { AutoRenewStatus(rawValue: $0) }
        }
        set {
            self.rawAutoRenewStatus = newValue.map { $0.rawValue }
        }
    }

    ///See ``autoRenewStatus``
    public var rawAutoRenewStatus: Int32?

    ///The currency code for the renewalPrice of the subscription.
    ///
    ///[currency](https://developer.apple.com/documentation/appstoreserverapi/currency)
    public var currency: String?

    ///The list of win-back offer IDs that the customer is eligible for.
    ///
    ///[eligibleWinBackOfferIds](https://developer.apple.com/documentation/appstoreserverapi/eligiblewinbackofferids)
    public var eligibleWinBackOfferIds: [String]?

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

    ///The reason the subscription expired.
    ///
    ///[expirationIntent](https://developer.apple.com/documentation/appstoreserverapi/expirationintent)
    public var expirationIntent: ExpirationIntent? {
        get {
            return rawExpirationIntent.flatMap { ExpirationIntent(rawValue: $0) }
        }
        set {
            self.rawExpirationIntent = newValue.map { $0.rawValue }
        }
    }

    ///See ``expirationIntent``
    public var rawExpirationIntent: Int32?

    ///The time when the Billing Grace Period for subscription renewals expires.
    ///
    ///[gracePeriodExpiresDate](https://developer.apple.com/documentation/appstoreserverapi/graceperiodexpiresdate)
    public var gracePeriodExpiresDate: Date?

    ///A Boolean value that indicates whether the App Store is attempting to automatically renew the expired subscription.
    ///
    ///[isInBillingRetryPeriod](https://developer.apple.com/documentation/appstoreserverapi/isinbillingretryperiod)
    public var isInBillingRetryPeriod: Bool?

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

    ///The offer code or the promotional offer identifier.
    ///
    ///[offerIdentifier](https://developer.apple.com/documentation/appstoreserverapi/offeridentifier)
    public var offerIdentifier: String?

    ///The duration of the offer.
    ///
    ///[offerPeriod](https://developer.apple.com/documentation/appstoreserverapi/offerperiod)
    public var offerPeriod: String?

    ///The type of subscription offer.
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

    ///The transaction identifier of the original purchase associated with this transaction.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?

    ///The status that indicates whether the auto-renewable subscription is subject to a price increase.
    ///
    ///[priceIncreaseStatus](https://developer.apple.com/documentation/appstoreserverapi/priceincreasestatus)
    public var priceIncreaseStatus: PriceIncreaseStatus? {
        get {
            return rawPriceIncreaseStatus.flatMap { PriceIncreaseStatus(rawValue: $0) }
        }
        set {
            self.rawPriceIncreaseStatus = newValue.map { $0.rawValue }
        }
    }

    ///See ``priceIncreaseStatus``
    public var rawPriceIncreaseStatus: Int32?

    ///The product identifier of the In-App Purchase.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?

    ///The earliest start date of the auto-renewable subscription in a series of subscription purchases that ignores all lapses of paid service that are 60 days or fewer.
    ///
    ///[recentSubscriptionStartDate](https://developer.apple.com/documentation/appstoreserverapi/recentsubscriptionstartdate)
    public var recentSubscriptionStartDate: Date?

    ///The UNIX time, in milliseconds, when the most recent auto-renewable subscription purchase expires.
    ///
    ///[renewalDate](https://developer.apple.com/documentation/appstoreserverapi/renewaldate)
    public var renewalDate: Date?

    ///The renewal price, in milliunits, of the auto-renewable subscription that renews at the next billing period.
    ///
    ///[renewalPrice](https://developer.apple.com/documentation/appstoreserverapi/renewalprice)
    public var renewalPrice: Int64?

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

    ///Renewal information that is present only for Advanced Commerce SKUs.
    ///
    ///[advancedCommerceRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerenewalinfo)
    public var advancedCommerceInfo: AdvancedCommerceRenewalInfo?

    ///[RenewalCommitmentInfo](https://developer.apple.com/documentation/appstoreserverapi/renewalcommitmentinfo)
    public var commitmentInfo: RenewalCommitmentInfo?

    ///[renewalBillingPlanType](https://developer.apple.com/documentation/appstoreserverapi/renewalbillingplantype)
    public var renewalBillingPlanType: RenewalBillingPlanType? {
        get {
            return rawRenewalBillingPlanType.flatMap { RenewalBillingPlanType(rawValue: $0) }
        }
        set {
            self.rawRenewalBillingPlanType = newValue.map { $0.rawValue }
        }
    }

    ///See ``renewalBillingPlanType``
    public var rawRenewalBillingPlanType: String?

    public enum CodingKeys: CodingKey {
        case appAccountToken
        case appTransactionId
        case autoRenewProductId
        case autoRenewStatus
        case currency
        case eligibleWinBackOfferIds
        case environment
        case expirationIntent
        case gracePeriodExpiresDate
        case isInBillingRetryPeriod
        case offerDiscountType
        case offerIdentifier
        case offerPeriod
        case offerType
        case originalTransactionId
        case priceIncreaseStatus
        case productId
        case recentSubscriptionStartDate
        case renewalDate
        case renewalPrice
        case signedDate
        case advancedCommerceInfo
        case commitmentInfo
        case renewalBillingPlanType
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appAccountToken = try container.decodeIfPresent(UUID.self, forKey: .appAccountToken)
        self.appTransactionId = try container.decodeIfPresent(String.self, forKey: .appTransactionId)
        self.autoRenewProductId = try container.decodeIfPresent(String.self, forKey: .autoRenewProductId)
        self.rawAutoRenewStatus = try container.decodeIfPresent(Int32.self, forKey: .autoRenewStatus)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.eligibleWinBackOfferIds = try container.decodeIfPresent([String].self, forKey: .eligibleWinBackOfferIds)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.rawExpirationIntent = try container.decodeIfPresent(Int32.self, forKey: .expirationIntent)
        self.gracePeriodExpiresDate = try container.decodeIfPresent(Double.self, forKey: .gracePeriodExpiresDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.isInBillingRetryPeriod = try container.decodeIfPresent(Bool.self, forKey: .isInBillingRetryPeriod)
        self.rawOfferDiscountType = try container.decodeIfPresent(String.self, forKey: .offerDiscountType)
        self.offerIdentifier = try container.decodeIfPresent(String.self, forKey: .offerIdentifier)
        self.offerPeriod = try container.decodeIfPresent(String.self, forKey: .offerPeriod)
        self.rawOfferType = try container.decodeIfPresent(Int32.self, forKey: .offerType)
        self.originalTransactionId = try container.decodeIfPresent(String.self, forKey: .originalTransactionId)
        self.rawPriceIncreaseStatus = try container.decodeIfPresent(Int32.self, forKey: .priceIncreaseStatus)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.recentSubscriptionStartDate = try container.decodeIfPresent(Double.self, forKey: .recentSubscriptionStartDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.renewalDate = try container.decodeIfPresent(Double.self, forKey: .renewalDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.renewalPrice = try container.decodeIfPresent(Int64.self, forKey: .renewalPrice)
        self.signedDate = try container.decodeIfPresent(Double.self, forKey: .signedDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.advancedCommerceInfo = try container.decodeIfPresent(AdvancedCommerceRenewalInfo.self, forKey: .advancedCommerceInfo)
        self.commitmentInfo = try container.decodeIfPresent(RenewalCommitmentInfo.self, forKey: .commitmentInfo)
        self.rawRenewalBillingPlanType = try container.decodeIfPresent(String.self, forKey: .renewalBillingPlanType)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.appAccountToken?.uuidString.lowercased(), forKey: .appAccountToken)
        try container.encodeIfPresent(self.appTransactionId, forKey: .appTransactionId)
        try container.encodeIfPresent(self.autoRenewProductId, forKey: .autoRenewProductId)
        try container.encodeIfPresent(self.rawAutoRenewStatus, forKey: .autoRenewStatus)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encodeIfPresent(self.eligibleWinBackOfferIds, forKey: .eligibleWinBackOfferIds)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.rawExpirationIntent, forKey: .expirationIntent)
        try container.encodeIfPresent(self.gracePeriodExpiresDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .gracePeriodExpiresDate)
        try container.encodeIfPresent(self.isInBillingRetryPeriod, forKey: .isInBillingRetryPeriod)
        try container.encodeIfPresent(self.rawOfferDiscountType, forKey: .offerDiscountType)
        try container.encodeIfPresent(self.offerIdentifier, forKey: .offerIdentifier)
        try container.encodeIfPresent(self.offerPeriod, forKey: .offerPeriod)
        try container.encodeIfPresent(self.rawOfferType, forKey: .offerType)
        try container.encodeIfPresent(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encodeIfPresent(self.rawPriceIncreaseStatus, forKey: .priceIncreaseStatus)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.recentSubscriptionStartDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .recentSubscriptionStartDate)
        try container.encodeIfPresent(self.renewalDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .renewalDate)
        try container.encodeIfPresent(self.renewalPrice, forKey: .renewalPrice)
        try container.encodeIfPresent(self.signedDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .signedDate)
        try container.encodeIfPresent(self.advancedCommerceInfo, forKey: .advancedCommerceInfo)
        try container.encodeIfPresent(self.commitmentInfo, forKey: .commitmentInfo)
        try container.encodeIfPresent(self.rawRenewalBillingPlanType, forKey: .renewalBillingPlanType)
    }
}
