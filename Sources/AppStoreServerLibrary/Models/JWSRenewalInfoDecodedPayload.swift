// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A decoded payload containing subscription renewal information for an auto-renewable subscription.
///
///[JWSRenewalInfoDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfodecodedpayload)
public struct JWSRenewalInfoDecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable {
    
    init(expirationIntent: ExpirationIntent? = nil, originalTransactionId: String? = nil, autoRenewProductId: String? = nil, productId: String? = nil, autoRenewStatus: AutoRenewStatus? = nil, isInBillingRetryPeriod: Bool? = nil, priceIncreaseStatus: PriceIncreaseStatus? = nil, gracePeriodExpiresDate: Date? = nil, offerType: OfferType? = nil, offerIdentifier: String? = nil, signedDate: Date? = nil, environment: Environment? = nil, recentSubscriptionStartDate: Date? = nil, renewalDate: Date? = nil) {
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
    }
    
    init(rawExpirationIntent: Int32? = nil, originalTransactionId: String? = nil, autoRenewProductId: String? = nil, productId: String? = nil, rawAutoRenewStatus: Int32? = nil, isInBillingRetryPeriod: Bool? = nil, rawPriceIncreaseStatus: Int32? = nil, gracePeriodExpiresDate: Date? = nil, rawOfferType: Int32? = nil, offerIdentifier: String? = nil, signedDate: Date? = nil, rawEnvironment: String? = nil, recentSubscriptionStartDate: Date? = nil, renewalDate: Date? = nil) {
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
}
