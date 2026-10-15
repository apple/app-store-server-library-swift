// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The payload data that contains app metadata and the signed renewal and transaction information.
///
///[data](https://developer.apple.com/documentation/appstoreservernotifications/data)
public struct NotificationData: Decodable, Encodable, Hashable, Sendable {

    public init(appAppleId: Int64? = nil, bundleId: String? = nil, bundleVersion: String? = nil, consumptionRequestReason: ConsumptionRequestReason? = nil, environment: AppStoreEnvironment? = nil, signedRenewalInfo: String? = nil, signedTransactionInfo: String? = nil, status: Status? = nil) {
        self.init(appAppleId: appAppleId, bundleId: bundleId, bundleVersion: bundleVersion, rawConsumptionRequestReason: consumptionRequestReason?.rawValue, rawEnvironment: environment?.rawValue, signedRenewalInfo: signedRenewalInfo, signedTransactionInfo: signedTransactionInfo, rawStatus: status?.rawValue)
    }

    @_disfavoredOverload
    public init(appAppleId: Int64? = nil, bundleId: String? = nil, bundleVersion: String? = nil, rawConsumptionRequestReason: String? = nil, rawEnvironment: String? = nil, signedRenewalInfo: String? = nil, signedTransactionInfo: String? = nil, rawStatus: Int32? = nil) {
        self.appAppleId = appAppleId
        self.bundleId = bundleId
        self.bundleVersion = bundleVersion
        self.rawConsumptionRequestReason = rawConsumptionRequestReason
        self.rawEnvironment = rawEnvironment
        self.signedRenewalInfo = signedRenewalInfo
        self.signedTransactionInfo = signedTransactionInfo
        self.rawStatus = rawStatus
    }

    ///The unique identifier of the app that the notification applies to.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?

    ///The bundle identifier of the app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreservernotifications/bundleid)
    public var bundleId: String?

    ///The version of the build that identifies an iteration of the bundle.
    ///
    ///[bundleVersion](https://developer.apple.com/documentation/appstoreservernotifications/bundleversion)
    public var bundleVersion: String?

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

    ///Subscription renewal information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreservernotifications/jwsrenewalinfo)
    public var signedRenewalInfo: String?

    ///Transaction information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreservernotifications/jwstransaction)
    public var signedTransactionInfo: String?

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

    public enum CodingKeys: CodingKey {
        case appAppleId
        case bundleId
        case bundleVersion
        case consumptionRequestReason
        case environment
        case signedRenewalInfo
        case signedTransactionInfo
        case status
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appAppleId = try container.decodeIfPresent(Int64.self, forKey: .appAppleId)
        self.bundleId = try container.decodeIfPresent(String.self, forKey: .bundleId)
        self.bundleVersion = try container.decodeIfPresent(String.self, forKey: .bundleVersion)
        self.rawConsumptionRequestReason = try container.decodeIfPresent(String.self, forKey: .consumptionRequestReason)
        self.rawEnvironment = try container.decodeIfPresent(String.self, forKey: .environment)
        self.signedRenewalInfo = try container.decodeIfPresent(String.self, forKey: .signedRenewalInfo)
        self.signedTransactionInfo = try container.decodeIfPresent(String.self, forKey: .signedTransactionInfo)
        self.rawStatus = try container.decodeIfPresent(Int32.self, forKey: .status)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.appAppleId, forKey: .appAppleId)
        try container.encodeIfPresent(self.bundleId, forKey: .bundleId)
        try container.encodeIfPresent(self.bundleVersion, forKey: .bundleVersion)
        try container.encodeIfPresent(self.rawConsumptionRequestReason, forKey: .consumptionRequestReason)
        try container.encodeIfPresent(self.rawEnvironment, forKey: .environment)
        try container.encodeIfPresent(self.signedRenewalInfo, forKey: .signedRenewalInfo)
        try container.encodeIfPresent(self.signedTransactionInfo, forKey: .signedTransactionInfo)
        try container.encodeIfPresent(self.rawStatus, forKey: .status)
    }
}
