// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///The request body containing consumption information.
///
///[ConsumptionRequestV1](https://developer.apple.com/documentation/appstoreserverapi/consumptionrequestv1)
@available(*, deprecated, message: "Use ConsumptionRequest instead")
public struct ConsumptionRequestV1: Decodable, Encodable, Hashable, Sendable {

    public init(accountTenure: AccountTenure, appAccountToken: UUID?, consumptionStatus: ConsumptionStatus, customerConsented: Bool, deliveryStatus: DeliveryStatusV1, lifetimeDollarsPurchased: LifetimeDollarsPurchased, lifetimeDollarsRefunded: LifetimeDollarsRefunded, platform: Platform, playTime: PlayTime, sampleContentProvided: Bool, userStatus: UserStatus, refundPreference: RefundPreferenceV1? = nil) {
        self.init(rawAccountTenure: accountTenure.rawValue, appAccountToken: appAccountToken, rawConsumptionStatus: consumptionStatus.rawValue, customerConsented: customerConsented, rawDeliveryStatus: deliveryStatus.rawValue, rawLifetimeDollarsPurchased: lifetimeDollarsPurchased.rawValue, rawLifetimeDollarsRefunded: lifetimeDollarsRefunded.rawValue, rawPlatform: platform.rawValue, rawPlayTime: playTime.rawValue, sampleContentProvided: sampleContentProvided, rawUserStatus: userStatus.rawValue, rawRefundPreference: refundPreference?.rawValue)
    }

    public init(rawAccountTenure: Int32, appAccountToken: UUID?, rawConsumptionStatus: Int32, customerConsented: Bool, rawDeliveryStatus: Int32, rawLifetimeDollarsPurchased: Int32, rawLifetimeDollarsRefunded: Int32, rawPlatform: Int32, rawPlayTime: Int32, sampleContentProvided: Bool, rawUserStatus: Int32, rawRefundPreference: Int32? = nil) {
        self.rawAccountTenure = rawAccountTenure
        self.rawConsumptionStatus = rawConsumptionStatus
        self.customerConsented = customerConsented
        self.rawDeliveryStatus = rawDeliveryStatus
        self.rawLifetimeDollarsPurchased = rawLifetimeDollarsPurchased
        self.rawLifetimeDollarsRefunded = rawLifetimeDollarsRefunded
        self.rawPlatform = rawPlatform
        self.rawPlayTime = rawPlayTime
        self.sampleContentProvided = sampleContentProvided
        self.rawUserStatus = rawUserStatus
        self.rawRefundPreference = rawRefundPreference
        self.appAccountToken = appAccountToken
    }

    ///The age of the customer’s account.
    ///
    ///[accountTenure](https://developer.apple.com/documentation/appstoreserverapi/accounttenure)
    public var accountTenure: AccountTenure? {
        get {
            return AccountTenure(rawValue: rawAccountTenure)
        }
        set {
            self.rawAccountTenure = newValue.map { $0.rawValue } ?? rawAccountTenure
        }
    }

    ///See ``accountTenure``
    public var rawAccountTenure: Int32

    ///The UUID of the in-app user account that completed the in-app purchase transaction.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID? {
        get {
            return rawAppAccountToken != "" ? UUID(uuidString: rawAppAccountToken) : nil
        }
        set {
            self.rawAppAccountToken = newValue.map { $0.uuidString.lowercased() } ?? ""
        }
    }

    private var rawAppAccountToken: String = ""

    ///A value that indicates the extent to which the customer consumed the in-app purchase.
    ///
    ///[consumptionStatus](https://developer.apple.com/documentation/appstoreserverapi/consumptionstatus)
    public var consumptionStatus: ConsumptionStatus? {
        get {
            return ConsumptionStatus(rawValue: rawConsumptionStatus)
        }
        set {
            self.rawConsumptionStatus = newValue.map { $0.rawValue } ?? rawConsumptionStatus
        }
    }

    ///See ``consumptionStatus``
    public var rawConsumptionStatus: Int32

    ///A Boolean value of true or false that indicates whether the customer consented to provide consumption data.
    ///
    ///[customerConsented](https://developer.apple.com/documentation/appstoreserverapi/customerconsented)
    public var customerConsented: Bool

    ///A value that indicates whether the app successfully delivered an in-app purchase that works properly.
    ///
    ///[deliveryStatusV1](https://developer.apple.com/documentation/appstoreserverapi/deliverystatusv1)
    public var deliveryStatus: DeliveryStatusV1? {
        get {
            return DeliveryStatusV1(rawValue: rawDeliveryStatus)
        }
        set {
            self.rawDeliveryStatus = newValue.map { $0.rawValue } ?? rawDeliveryStatus
        }
    }

    ///See ``deliveryStatus``
    public var rawDeliveryStatus: Int32

    ///A value that indicates the total amount, in USD, of in-app purchases the customer has made in your app, across all platforms.
    ///
    ///[lifetimeDollarsPurchased](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarspurchased)
    public var lifetimeDollarsPurchased: LifetimeDollarsPurchased? {
        get {
            return LifetimeDollarsPurchased(rawValue: rawLifetimeDollarsPurchased)
        }
        set {
            self.rawLifetimeDollarsPurchased = newValue.map { $0.rawValue } ?? rawLifetimeDollarsPurchased
        }
    }

    ///See ``lifetimeDollarsPurchased``
    public var rawLifetimeDollarsPurchased: Int32

    ///A value that indicates the total amount, in USD, of refunds the customer has received, in your app, across all platforms.
    ///
    ///[lifetimeDollarsRefunded](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarsrefunded)
    public var lifetimeDollarsRefunded: LifetimeDollarsRefunded? {
        get {
            return LifetimeDollarsRefunded(rawValue: rawLifetimeDollarsRefunded)
        }
        set {
            self.rawLifetimeDollarsRefunded = newValue.map { $0.rawValue } ?? rawLifetimeDollarsRefunded
        }
    }

    ///See ``lifetimeDollarsRefunded``
    public var rawLifetimeDollarsRefunded: Int32

    ///A value that indicates the platform on which the customer consumed the in-app purchase.
    ///
    ///[platform](https://developer.apple.com/documentation/appstoreserverapi/platform)
    public var platform: Platform? {
        get {
            return Platform(rawValue: rawPlatform)
        }
        set {
            self.rawPlatform = newValue.map { $0.rawValue } ?? rawPlatform
        }
    }

    ///See ``platform``
    public var rawPlatform: Int32

    ///A value that indicates the amount of time that the customer used the app.
    ///
    ///[playTime](https://developer.apple.com/documentation/appstoreserverapi/playtime)
    public var playTime: PlayTime? {
        get {
            return PlayTime(rawValue: rawPlayTime)
        }
        set {
            self.rawPlayTime = newValue.map { $0.rawValue } ?? rawPlayTime
        }
    }

    ///See ``playTime``
    public var rawPlayTime: Int32

    ///A value that indicates your preference, based on your operational logic, as to whether Apple should grant the refund.
    ///
    ///[refundPreferenceV1](https://developer.apple.com/documentation/appstoreserverapi/refundpreferencev1)
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

    ///A Boolean value of true or false that indicates whether you provided, prior to its purchase, a free sample or trial of the content, or information about its functionality.
    ///
    ///[sampleContentProvided](https://developer.apple.com/documentation/appstoreserverapi/samplecontentprovided)
    public var sampleContentProvided: Bool

    ///The status of the customer’s account.
    ///
    ///[userStatus](https://developer.apple.com/documentation/appstoreserverapi/userstatus)
    public var userStatus: UserStatus? {
        get {
            return UserStatus(rawValue: rawUserStatus)
        }
        set {
            self.rawUserStatus = newValue.map { $0.rawValue } ?? rawUserStatus
        }
    }

    ///See ``userStatus``
    public var rawUserStatus: Int32

    public enum CodingKeys: CodingKey {
        case accountTenure
        case appAccountToken
        case consumptionStatus
        case customerConsented
        case deliveryStatus
        case lifetimeDollarsPurchased
        case lifetimeDollarsRefunded
        case platform
        case playTime
        case refundPreference
        case sampleContentProvided
        case userStatus
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawAccountTenure = try container.decode(Int32.self, forKey: .accountTenure)
        self.rawAppAccountToken = try container.decode(String.self, forKey: .appAccountToken)
        self.rawConsumptionStatus = try container.decode(Int32.self, forKey: .consumptionStatus)
        self.customerConsented = try container.decode(Bool.self, forKey: .customerConsented)
        self.rawDeliveryStatus = try container.decode(Int32.self, forKey: .deliveryStatus)
        self.rawLifetimeDollarsPurchased = try container.decode(Int32.self, forKey: .lifetimeDollarsPurchased)
        self.rawLifetimeDollarsRefunded = try container.decode(Int32.self, forKey: .lifetimeDollarsRefunded)
        self.rawPlatform = try container.decode(Int32.self, forKey: .platform)
        self.rawPlayTime = try container.decode(Int32.self, forKey: .playTime)
        self.rawRefundPreference = try container.decodeIfPresent(Int32.self, forKey: .refundPreference)
        self.sampleContentProvided = try container.decode(Bool.self, forKey: .sampleContentProvided)
        self.rawUserStatus = try container.decode(Int32.self, forKey: .userStatus)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawAccountTenure, forKey: .accountTenure)
        try container.encode(self.rawAppAccountToken, forKey: .appAccountToken)
        try container.encode(self.rawConsumptionStatus, forKey: .consumptionStatus)
        try container.encode(self.customerConsented, forKey: .customerConsented)
        try container.encode(self.rawDeliveryStatus, forKey: .deliveryStatus)
        try container.encode(self.rawLifetimeDollarsPurchased, forKey: .lifetimeDollarsPurchased)
        try container.encode(self.rawLifetimeDollarsRefunded, forKey: .lifetimeDollarsRefunded)
        try container.encode(self.rawPlatform, forKey: .platform)
        try container.encode(self.rawPlayTime, forKey: .playTime)
        try container.encodeIfPresent(self.rawRefundPreference, forKey: .refundPreference)
        try container.encode(self.sampleContentProvided, forKey: .sampleContentProvided)
        try container.encode(self.rawUserStatus, forKey: .userStatus)
    }
}
