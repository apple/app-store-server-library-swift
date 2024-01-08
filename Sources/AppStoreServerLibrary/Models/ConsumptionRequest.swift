// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///The request body containing consumption information.
///
///[ConsumptionRequest](https://developer.apple.com/documentation/appstoreserverapi/consumptionrequest)
public struct ConsumptionRequest: Decodable, Encodable, Hashable {
    
    public init(customerConsented: Bool? = nil, consumptionStatus: ConsumptionStatus? = nil, platform: Platform? = nil, sampleContentProvided: Bool? = nil, deliveryStatus: DeliveryStatus? = nil, appAccountToken: UUID? = nil, accountTenure: AccountTenure? = nil, playTime: PlayTime? = nil, lifetimeDollarsRefunded: LifetimeDollarsRefunded? = nil, lifetimeDollarsPurchased: LifetimeDollarsPurchased? = nil, userStatus: UserStatus? = nil) {
        self.customerConsented = customerConsented
        self.consumptionStatus = consumptionStatus
        self.platform = platform
        self.sampleContentProvided = sampleContentProvided
        self.deliveryStatus = deliveryStatus
        self.appAccountToken = appAccountToken
        self.accountTenure = accountTenure
        self.playTime = playTime
        self.lifetimeDollarsRefunded = lifetimeDollarsRefunded
        self.lifetimeDollarsPurchased = lifetimeDollarsPurchased
        self.userStatus = userStatus
    }
    
    public init(customerConsented: Bool? = nil, rawConsumptionStatus: Int32? = nil, rawPlatform: Int32? = nil, sampleContentProvided: Bool? = nil, rawDeliveryStatus: Int32? = nil, appAccountToken: UUID? = nil, rawAccountTenure: Int32? = nil, rawPlayTime: Int32? = nil, rawLifetimeDollarsRefunded: Int32? = nil, rawLifetimeDollarsPurchased: Int32? = nil, rawUserStatus: Int32? = nil) {
        self.customerConsented = customerConsented
        self.rawConsumptionStatus = rawConsumptionStatus
        self.rawPlatform = rawPlatform
        self.sampleContentProvided = sampleContentProvided
        self.rawDeliveryStatus = rawDeliveryStatus
        self.appAccountToken = appAccountToken
        self.rawAccountTenure = rawAccountTenure
        self.rawPlayTime = rawPlayTime
        self.rawLifetimeDollarsRefunded = rawLifetimeDollarsRefunded
        self.rawLifetimeDollarsPurchased = rawLifetimeDollarsPurchased
        self.rawUserStatus = rawUserStatus
    }
    
    ///A Boolean value that indicates whether the customer consented to provide consumption data to the App Store.
    ///
    ///[customerConsented](https://developer.apple.com/documentation/appstoreserverapi/customerconsented)
    public var customerConsented: Bool?
    
    ///A value that indicates the extent to which the customer consumed the in-app purchase.
    ///
    ///[consumptionStatus](https://developer.apple.com/documentation/appstoreserverapi/consumptionstatus)
    public var consumptionStatus: ConsumptionStatus? {
        get {
            return rawConsumptionStatus.flatMap { ConsumptionStatus(rawValue: $0) }
        }
        set {
            self.rawConsumptionStatus = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``consumptionStatus``
    public var rawConsumptionStatus: Int32?
    
    ///A value that indicates the platform on which the customer consumed the in-app purchase.
    ///
    ///[platform](https://developer.apple.com/documentation/appstoreserverapi/platform)
    public var platform: Platform? {
        get {
            return rawPlatform.flatMap { Platform(rawValue: $0) }
        }
        set {
            self.rawPlatform = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``platform``
    public var rawPlatform: Int32?
    
    ///A Boolean value that indicates whether you provided, prior to its purchase, a free sample or trial of the content, or information about its functionality.
    
    ///[sampleContentProvided](https://developer.apple.com/documentation/appstoreserverapi/samplecontentprovided)
    public var sampleContentProvided: Bool?
    
    ///A value that indicates whether the app successfully delivered an in-app purchase that works properly.
    ///
    ///[deliveryStatus](https://developer.apple.com/documentation/appstoreserverapi/deliverystatus)
    public var deliveryStatus: DeliveryStatus? {
        get {
            return rawDeliveryStatus.flatMap { DeliveryStatus(rawValue: $0) }
        }
        set {
            self.rawDeliveryStatus = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``deliveryStatus``
    public var rawDeliveryStatus: Int32?
    
    ///The UUID that an app optionally generates to map a customer’s in-app purchase with its resulting App Store transaction.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID?

    ///The age of the customer’s account.
    ///
    ///[accountTenure](https://developer.apple.com/documentation/appstoreserverapi/accounttenure)
    public var accountTenure: AccountTenure? {
        get {
            return rawAccountTenure.flatMap { AccountTenure(rawValue: $0) }
        }
        set {
            self.rawAccountTenure = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``accountTenure``
    public var rawAccountTenure: Int32?
    
    ///A value that indicates the amount of time that the customer used the app.
    ///
    ///[ConsumptionRequest](https://developer.apple.com/documentation/appstoreserverapi/consumptionrequest)
    public var playTime: PlayTime? {
        get {
            return rawPlayTime.flatMap { PlayTime(rawValue: $0) }
        }
        set {
            self.rawPlayTime = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``playTime``
    public var rawPlayTime: Int32?
    
    ///A value that indicates the total amount, in USD, of refunds the customer has received, in your app, across all platforms.
    ///
    ///[lifetimeDollarsRefunded](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarsrefunded)
    public var lifetimeDollarsRefunded: LifetimeDollarsRefunded? {
        get {
            return rawLifetimeDollarsRefunded.flatMap { LifetimeDollarsRefunded(rawValue: $0) }
        }
        set {
            self.rawLifetimeDollarsRefunded = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``lifetimeDollarsRefunded``
    public var rawLifetimeDollarsRefunded: Int32?
    
    ///A value that indicates the total amount, in USD, of in-app purchases the customer has made in your app, across all platforms.
    ///
    ///[lifetimeDollarsPurchased](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarspurchased)
    public var lifetimeDollarsPurchased: LifetimeDollarsPurchased? {
        get {
            return rawLifetimeDollarsPurchased.flatMap { LifetimeDollarsPurchased(rawValue: $0) }
        }
        set {
            self.rawLifetimeDollarsPurchased = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``lifetimeDollarsPurchased``
    public var rawLifetimeDollarsPurchased: Int32?
    
    ///The status of the customer’s account.
    ///
    ///[userStatus](https://developer.apple.com/documentation/appstoreserverapi/userstatus)
    public var userStatus: UserStatus? {
        get {
            return rawUserStatus.flatMap { UserStatus(rawValue: $0) }
        }
        set {
            self.rawUserStatus = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``userStatus``
    public var rawUserStatus: Int32?
    
}
