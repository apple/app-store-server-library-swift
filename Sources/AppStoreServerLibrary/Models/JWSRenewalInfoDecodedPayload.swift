// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A decoded payload containing subscription renewal information for an auto-renewable subscription.
///
///[JWSRenewalInfoDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfodecodedpayload)
public struct JWSRenewalInfoDecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {
    
    public init(expirationIntent: ExpirationIntent? = nil, originalTransactionId: String? = nil, autoRenewProductId: String? = nil, productId: String? = nil, autoRenewStatus: AutoRenewStatus? = nil, isInBillingRetryPeriod: Bool? = nil, priceIncreaseStatus: PriceIncreaseStatus? = nil, gracePeriodExpiresDate: Date? = nil, offerType: OfferType? = nil, offerIdentifier: String? = nil, signedDate: Date? = nil, environment: Environment? = nil, recentSubscriptionStartDate: Date? = nil, renewalDate: Date? = nil, currency: String? = nil, renewalPrice: Int64? = nil, offerDiscountType: OfferDiscountType? = nil, eligibleWinBackOfferIds: [String]? = nil) {
        self.expirationIntent = expirationIntent
        self.originalTransactionId = originalTransactionId
        self.autoRenewProductId = autoRenewProductId
        self.productId = productId
        self.autoRenewStatus = autoRenewStatus
        self.isInBillingRetryPeriod = isInBillingRetryPeriod
        self.priceIncreaseStatus = priceIncreaseStatus
        self.gracePeriodExpiresDate = gracePeriodExpiresDate
        self.offerType = offerType
        self.offerIdentifier = offerIdentifier
        self.signedDate = signedDate
        self.environment = environment
        self.recentSubscriptionStartDate = recentSubscriptionStartDate
        self.renewalDate = renewalDate
        self.currency = currency
        self.renewalPrice = renewalPrice
        self.offerDiscountType = offerDiscountType
        self.eligibleWinBackOfferIds = eligibleWinBackOfferIds
    }
    
    public init(rawExpirationIntent: Int32? = nil, originalTransactionId: String? = nil, autoRenewProductId: String? = nil, productId: String? = nil, rawAutoRenewStatus: Int32? = nil, isInBillingRetryPeriod: Bool? = nil, rawPriceIncreaseStatus: Int32? = nil, gracePeriodExpiresDate: Date? = nil, rawOfferType: Int32? = nil, offerIdentifier: String? = nil, signedDate: Date? = nil, rawEnvironment: String? = nil, recentSubscriptionStartDate: Date? = nil, renewalDate: Date? = nil, currency: String? = nil, renewalPrice: Int64? = nil, offerDiscountType: OfferDiscountType? = nil, eligibleWinBackOfferIds: [String]? = nil) {
        self.rawExpirationIntent = rawExpirationIntent
        self.originalTransactionId = originalTransactionId
        self.autoRenewProductId = autoRenewProductId
        self.productId = productId
        self.rawAutoRenewStatus = rawAutoRenewStatus
        self.isInBillingRetryPeriod = isInBillingRetryPeriod
        self.rawPriceIncreaseStatus = rawPriceIncreaseStatus
        self.gracePeriodExpiresDate = gracePeriodExpiresDate
        self.rawOfferType = rawOfferType
        self.offerIdentifier = offerIdentifier
        self.signedDate = signedDate
        self.rawEnvironment = rawEnvironment
        self.recentSubscriptionStartDate = recentSubscriptionStartDate
        self.renewalDate = renewalDate
        self.currency = currency
        self.renewalPrice = renewalPrice
        self.offerDiscountType = offerDiscountType
        self.eligibleWinBackOfferIds = eligibleWinBackOfferIds
    }
    
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
    
    ///The original transaction identifier of a purchase.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?
    
    ///The product identifier of the product that will renew at the next billing period.
    ///
    ///[autoRenewProductId](https://developer.apple.com/documentation/appstoreserverapi/autorenewproductid)
    public var autoRenewProductId: String?
                         
    ///The unique identifier for the product, that you create in App Store Connect.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?
                
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
                      
    ///A Boolean value that indicates whether the App Store is attempting to automatically renew an expired subscription.
    ///
    ///[isInBillingRetryPeriod](https://developer.apple.com/documentation/appstoreserverapi/isinbillingretryperiod)
    public var isInBillingRetryPeriod: Bool?
                             
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
                          
    ///The time when the billing grace period for subscription renewals expires.
    ///
    ///[gracePeriodExpiresDate](https://developer.apple.com/documentation/appstoreserverapi/graceperiodexpiresdate)
    public var gracePeriodExpiresDate: Date?
                             
    ///The type of the subscription offer.
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
                      
    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreserverapi/signeddate)
    public var signedDate: Date?
                 
    ///The server environment, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
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
                  
    /// The earliest start date of a subscription in a series of auto-renewable subscription purchases that ignores all lapses of paid service shorter than 60 days.
    ///
    ///[recentSubscriptionStartDate](https://developer.apple.com/documentation/appstoreserverapi/recentsubscriptionstartdate)
    public var recentSubscriptionStartDate: Date?
                                  
    ///The UNIX time, in milliseconds, when the most recent auto-renewable subscription purchase expires.
    ///
    ///[renewalDate](https://developer.apple.com/documentation/appstoreserverapi/renewaldate)
    public var renewalDate: Date?

    ///The currency code for the renewalPrice of the subscription.
    ///
    ///[currency](https://developer.apple.com/documentation/appstoreserverapi/currency)
    public var currency: String?

    ///The renewal price, in milliunits, of the auto-renewable subscription that renews at the next billing period.
    ///
    ///[renewalPrice](https://developer.apple.com/documentation/appstoreserverapi/renewalprice)
    public var renewalPrice: Int64?

    ///The payment mode of the discount offer.
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

    ///An array of win-back offer identifiers that a customer is eligible to redeem, which sorts the identifiers to present the better offers first.
    ///
    ///[eligibleWinBackOfferIds](https://developer.apple.com/documentation/appstoreserverapi/eligiblewinbackofferids)
    public var eligibleWinBackOfferIds: [String]?
    
    public enum CodingKeys: CodingKey {
        case expirationIntent
        case originalTransactionId
        case autoRenewProductId
        case productId
        case autoRenewStatus
        case isInBillingRetryPeriod
        case priceIncreaseStatus
        case gracePeriodExpiresDate
        case offerType
        case offerIdentifier
        case signedDate
        case environment
        case recentSubscriptionStartDate
        case renewalDate
        case currency
        case renewalPrice
        case offerDiscountType
        case eligibleWinBackOfferIds
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawExpirationIntent = try container.decodeIfPresent(Int32.self, forKey: .expirationIntent)
        self.originalTransactionId = try container.decodeIfPresent(String.self, forKey: .originalTransactionId)
        self.autoRenewProductId = try container.decodeIfPresent(String.self, forKey: .autoRenewProductId)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.rawAutoRenewStatus = try container.decodeIfPresent(Int32.self, forKey: .autoRenewStatus)
        self.isInBillingRetryPeriod = try container.decodeIfPresent(Bool.self, forKey: .isInBillingRetryPeriod)
        self.rawPriceIncreaseStatus = try container.decodeIfPresent(Int32.self, forKey: .priceIncreaseStatus)
        self.gracePeriodExpiresDate = try container.decodeIfPresent(Date.self, forKey: .gracePeriodExpiresDate)
        self.rawOfferType = try container.decodeIfPresent(Int32.self, forKey: .offerType)
        self.offerIdentifier = try container.decodeIfPresent(String.self, forKey: .offerIdentifier)
        self.signedDate = try container.decodeIfPresent(Date.self, forKey: .signedDate)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.recentSubscriptionStartDate = try container.decodeIfPresent(Date.self, forKey: .recentSubscriptionStartDate)
        self.renewalDate = try container.decodeIfPresent(Date.self, forKey: .renewalDate)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.renewalPrice = try container.decodeIfPresent(Int64.self, forKey: .renewalPrice)
        self.rawOfferDiscountType = try container.decodeIfPresent(String.self, forKey: .offerDiscountType)
        self.eligibleWinBackOfferIds = try container.decodeIfPresent([String].self, forKey: .eligibleWinBackOfferIds)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawExpirationIntent, forKey: .expirationIntent)
        try container.encodeIfPresent(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encodeIfPresent(self.autoRenewProductId, forKey: .autoRenewProductId)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.rawAutoRenewStatus, forKey: .autoRenewStatus)
        try container.encodeIfPresent(self.isInBillingRetryPeriod, forKey: .isInBillingRetryPeriod)
        try container.encodeIfPresent(self.rawPriceIncreaseStatus, forKey: .priceIncreaseStatus)
        try container.encodeIfPresent(self.gracePeriodExpiresDate, forKey: .gracePeriodExpiresDate)
        try container.encodeIfPresent(self.rawOfferType, forKey: .offerType)
        try container.encodeIfPresent(self.offerIdentifier, forKey: .offerIdentifier)
        try container.encodeIfPresent(self.signedDate, forKey: .signedDate)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.recentSubscriptionStartDate, forKey: .recentSubscriptionStartDate)
        try container.encodeIfPresent(self.renewalDate, forKey: .renewalDate)
        try container.encodeIfPresent(self.currency, forKey: .currency)
        try container.encodeIfPresent(self.renewalPrice, forKey: .renewalPrice)
        try container.encodeIfPresent(self.rawOfferDiscountType, forKey: .offerDiscountType)
        try container.encodeIfPresent(self.eligibleWinBackOfferIds, forKey: .eligibleWinBackOfferIds)
    }
}
