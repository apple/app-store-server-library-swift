// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///The request body containing consumption information.
///
///[ConsumptionRequestV1](https://developer.apple.com/documentation/appstoreserverapi/consumptionrequestv1)
@available(*, deprecated, renamed: "ConsumptionRequest")
public struct ConsumptionRequestV1: Decodable, Encodable, Hashable, Sendable {

    public init(customerConsented: Bool? = nil, consumptionStatus: ConsumptionStatus? = nil, platform: Platform? = nil, sampleContentProvided: Bool? = nil, deliveryStatus: DeliveryStatusV1? = nil, appAccountToken: UUID? = nil, accountTenure: AccountTenure? = nil, playTime: PlayTime? = nil, lifetimeDollarsRefunded: LifetimeDollarsRefunded? = nil, lifetimeDollarsPurchased: LifetimeDollarsPurchased? = nil, userStatus: UserStatus? = nil, refundPreference: RefundPreferenceV1? = nil) {
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
        self.refundPreference = refundPreference
    }
    
    public init(customerConsented: Bool? = nil, rawConsumptionStatus: Int32? = nil, rawPlatform: Int32? = nil, sampleContentProvided: Bool? = nil, rawDeliveryStatus: Int32? = nil, appAccountToken: UUID? = nil, rawAccountTenure: Int32? = nil, rawPlayTime: Int32? = nil, rawLifetimeDollarsRefunded: Int32? = nil, rawLifetimeDollarsPurchased: Int32? = nil, rawUserStatus: Int32? = nil, rawRefundPreference: Int32? = nil) {
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
        self.rawRefundPreference = rawRefundPreference
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
    public var deliveryStatus: DeliveryStatusV1? {
        get {
            return rawDeliveryStatus.flatMap { DeliveryStatusV1(rawValue: $0) }
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
    public var appAccountToken: UUID? {
        get {
            return rawAppAccountToken != "" ? UUID(uuidString: rawAppAccountToken) : nil
        }
        set {
            self.rawAppAccountToken = newValue.map { $0.uuidString } ?? ""
        }
    }
    
    private var rawAppAccountToken: String = ""

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

    ///A value that indicates your preference, based on your operational logic, as to whether Apple should grant the refund.
    ///
    ///[refundPreference](https://developer.apple.com/documentation/appstoreserverapi/refundpreference)
    public var refundPreference: RefundPreferenceV1? {
        get {
            return rawRefundPreference.flatMap { RefundPreferenceV1(rawValue: $0) }
        }
        set {
            self.rawRefundPreference = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``refundPreference``
    public var rawRefundPreference: Int32?
    
    public enum CodingKeys: CodingKey {
        case customerConsented
        case consumptionStatus
        case platform
        case sampleContentProvided
        case deliveryStatus
        case appAccountToken
        case accountTenure
        case playTime
        case lifetimeDollarsRefunded
        case lifetimeDollarsPurchased
        case userStatus
        case refundPreference
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.customerConsented = try container.decodeIfPresent(Bool.self, forKey: .customerConsented)
        self.rawConsumptionStatus = try container.decodeIfPresent(Int32.self, forKey: .consumptionStatus)
        self.rawPlatform = try container.decodeIfPresent(Int32.self, forKey: .platform)
        self.sampleContentProvided = try container.decodeIfPresent(Bool.self, forKey: .sampleContentProvided)
        self.rawDeliveryStatus = try container.decodeIfPresent(Int32.self, forKey: .deliveryStatus)
        self.rawAppAccountToken = try container.decode(String.self, forKey: .appAccountToken)
        self.rawAccountTenure = try container.decodeIfPresent(Int32.self, forKey: .accountTenure)
        self.rawPlayTime = try container.decodeIfPresent(Int32.self, forKey: .playTime)
        self.rawLifetimeDollarsRefunded = try container.decodeIfPresent(Int32.self, forKey: .lifetimeDollarsRefunded)
        self.rawLifetimeDollarsPurchased = try container.decodeIfPresent(Int32.self, forKey: .lifetimeDollarsPurchased)
        self.rawUserStatus = try container.decodeIfPresent(Int32.self, forKey: .userStatus)
        self.rawRefundPreference = try container.decodeIfPresent(Int32.self, forKey: .refundPreference)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.customerConsented, forKey: .customerConsented)
        try container.encodeIfPresent(self.rawConsumptionStatus, forKey: .consumptionStatus)
        try container.encodeIfPresent(self.rawPlatform, forKey: .platform)
        try container.encodeIfPresent(self.sampleContentProvided, forKey: .sampleContentProvided)
        try container.encodeIfPresent(self.rawDeliveryStatus, forKey: .deliveryStatus)
        try container.encode(self.rawAppAccountToken, forKey: .appAccountToken)
        try container.encodeIfPresent(self.rawAccountTenure, forKey: .accountTenure)
        try container.encodeIfPresent(self.rawPlayTime, forKey: .playTime)
        try container.encodeIfPresent(self.rawLifetimeDollarsRefunded, forKey: .lifetimeDollarsRefunded)
        try container.encodeIfPresent(self.rawLifetimeDollarsPurchased, forKey: .lifetimeDollarsPurchased)
        try container.encodeIfPresent(self.rawUserStatus, forKey: .userStatus)
        try container.encodeIfPresent(self.rawRefundPreference, forKey: .refundPreference)
    }
}
