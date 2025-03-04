// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The app metadata and the signed renewal and transaction information.
///
///[data](https://developer.apple.com/documentation/appstoreservernotifications/data)
public struct NotificationData: Decodable, Encodable, Hashable, Sendable {
    
    public init(environment: AppStoreEnvironment? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, bundleVersion: String? = nil, signedTransactionInfo: String? = nil, signedRenewalInfo: String? = nil, status: Status? = nil, consumptionRequestReason: ConsumptionRequestReason? = nil) {
        self.environment = environment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.bundleVersion = bundleVersion
        self.signedTransactionInfo = signedTransactionInfo
        self.signedRenewalInfo = signedRenewalInfo
        self.status = status
        self.consumptionRequestReason = consumptionRequestReason
    }
    
    public init(rawEnvironment: String? = nil, appAppleId: Int64? = nil, bundleId: String? = nil, bundleVersion: String? = nil, signedTransactionInfo: String? = nil, signedRenewalInfo: String? = nil, rawStatus: Int32? = nil, rawConsumptionRequestReason: String? = nil) {
        self.rawEnvironment = rawEnvironment
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.bundleVersion = bundleVersion
        self.signedTransactionInfo = signedTransactionInfo
        self.signedRenewalInfo = signedRenewalInfo
        self.rawStatus = rawStatus
        self.rawConsumptionRequestReason = rawConsumptionRequestReason
    }
    
    ///The server environment that the notification applies to, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreservernotifications/environment)
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
    
    ///The unique identifier of an app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?
    
    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?
    
    ///The version of the build that identifies an iteration of the bundle.
    ///
    ///[bundleVersion](https://developer.apple.com/documentation/appstoreservernotifications/bundleversion)
    public var bundleVersion: String?
    
    ///Transaction information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String?
    
    ///Subscription renewal information, signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    public var signedRenewalInfo: String?

    ///The status of an auto-renewable subscription as of the signedDate in the responseBodyV2DecodedPayload.
    ///
    ///[status](https://developer.apple.com/documentation/appstoreservernotifications/status)
    public var status: Status? {
        get {
            return rawStatus.flatMap { Status(rawValue: $0) }
        }
        set {
            self.rawStatus = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``status``
    public var rawStatus: Int32?

    ///The reason the customer requested the refund.
    ///
    ///[consumptionRequestReason](https://developer.apple.com/documentation/appstoreservernotifications/consumptionrequestreason)
    public var consumptionRequestReason: ConsumptionRequestReason? {
        get {
            return rawConsumptionRequestReason.flatMap { ConsumptionRequestReason(rawValue: $0) }
        }
        set {
            self.rawConsumptionRequestReason = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``consumptionRequestReason``
    public var rawConsumptionRequestReason: String?
    
    public enum CodingKeys: CodingKey {
        case environment
        case appAppleId
        case bundleId
        case bundleVersion
        case signedTransactionInfo
        case signedRenewalInfo
        case status
        case consumptionRequestReason
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.bundleVersion = try container.decodeIfPresent(String.self, forKey: .bundleVersion)
        self.signedTransactionInfo = try container.decodeIfPresent(String.self, forKey: .signedTransactionInfo)
        self.signedRenewalInfo = try container.decodeIfPresent(String.self, forKey: .signedRenewalInfo)
        self.rawStatus = try container.decodeIfPresent(Int32.self, forKey: .status)
        self.rawConsumptionRequestReason = try container.decodeIfPresent(String.self, forKey: .consumptionRequestReason)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.bundleVersion, forKey: .bundleVersion)
        try container.encodeIfPresent(self.signedTransactionInfo, forKey: .signedTransactionInfo)
        try container.encodeIfPresent(self.signedRenewalInfo, forKey: .signedRenewalInfo)
        try container.encodeIfPresent(self.rawStatus, forKey: .status)
        try container.encodeIfPresent(self.rawConsumptionRequestReason, forKey: .consumptionRequestReason)
    }
}
