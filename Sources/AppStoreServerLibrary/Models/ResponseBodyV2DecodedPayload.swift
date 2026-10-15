// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///A decoded payload that contains the version 2 notification data.
///
///[responseBodyV2DecodedPayload](https://developer.apple.com/documentation/appstoreservernotifications/responsebodyv2decodedpayload)
public struct ResponseBodyV2DecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {

    public init(notificationType: NotificationTypeV2? = nil, subtype: Subtype? = nil, data: NotificationData? = nil, summary: Summary? = nil, externalPurchaseToken: ExternalPurchaseToken? = nil, appData: AppData? = nil, version: String? = nil, signedDate: Date? = nil, notificationUUID: String? = nil) {
        self.init(rawNotificationType: notificationType?.rawValue, rawSubtype: subtype?.rawValue, data: data, summary: summary, externalPurchaseToken: externalPurchaseToken, appData: appData, version: version, signedDate: signedDate, notificationUUID: notificationUUID)
    }

    @_disfavoredOverload
    public init(rawNotificationType: String? = nil, rawSubtype: String? = nil, data: NotificationData? = nil, summary: Summary? = nil, externalPurchaseToken: ExternalPurchaseToken? = nil, appData: AppData? = nil, version: String? = nil, signedDate: Date? = nil, notificationUUID: String? = nil) {
        self.rawNotificationType = rawNotificationType
        self.rawSubtype = rawSubtype
        self.data = data
        self.summary = summary
        self.externalPurchaseToken = externalPurchaseToken
        self.appData = appData
        self.version = version
        self.signedDate = signedDate
        self.notificationUUID = notificationUUID
    }

    ///The in-app purchase event for which the App Store sends this version 2 notification.
    ///
    ///[notificationType](https://developer.apple.com/documentation/appstoreservernotifications/notificationtype)
    public var notificationType: NotificationTypeV2? {
        get {
            return rawNotificationType.flatMap { NotificationTypeV2(rawValue: $0) }
        }
        set {
            self.rawNotificationType = newValue.map { $0.rawValue }
        }
    }

    ///See ``notificationType``
    public var rawNotificationType: String?

    ///Additional information that identifies the notification event.
    ///
    ///[subtype](https://developer.apple.com/documentation/appstoreservernotifications/subtype)
    public var subtype: Subtype? {
        get {
            return rawSubtype.flatMap { Subtype(rawValue: $0) }
        }
        set {
            self.rawSubtype = newValue.map { $0.rawValue }
        }
    }

    ///See ``subtype``
    public var rawSubtype: String?

    ///The object that contains the app metadata and signed renewal and transaction information.
    ///
    ///[data](https://developer.apple.com/documentation/appstoreservernotifications/data)
    public var data: NotificationData?

    ///The summary data that appears when the App Store server completes your request to extend a subscription renewal date for eligible subscribers.
    ///
    ///[summary](https://developer.apple.com/documentation/appstoreservernotifications/summary)
    public var summary: Summary?

    ///This field appears when the notificationType is EXTERNAL_PURCHASE_TOKEN.
    ///
    ///[externalPurchaseToken](https://developer.apple.com/documentation/appstoreservernotifications/externalpurchasetoken)
    public var externalPurchaseToken: ExternalPurchaseToken?

    ///The object that contains the app metadata and signed app transaction information.
    ///
    ///[appData](https://developer.apple.com/documentation/appstoreservernotifications/appdata)
    public var appData: AppData?

    ///The App Store Server Notification version number, "2.0".
    ///
    ///[version](https://developer.apple.com/documentation/appstoreservernotifications/version)
    public var version: String?

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreservernotifications/signeddate)
    public var signedDate: Date?

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreservernotifications/signeddate)
    public var signedDateOptional: Date? {
        signedDate
    }

    ///A unique identifier for the notification.
    ///
    ///[notificationUUID](https://developer.apple.com/documentation/appstoreservernotifications/notificationuuid)
    public var notificationUUID: String?

    public enum CodingKeys: CodingKey {
        case notificationType
        case subtype
        case data
        case summary
        case externalPurchaseToken
        case appData
        case version
        case signedDate
        case notificationUUID
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawNotificationType = try container.decodeIfPresent(String.self, forKey: .notificationType)
        self.rawSubtype = try container.decodeIfPresent(String.self, forKey: .subtype)
        self.data = try container.decodeIfPresent(NotificationData.self, forKey: .data)
        self.summary = try container.decodeIfPresent(Summary.self, forKey: .summary)
        self.externalPurchaseToken = try container.decodeIfPresent(ExternalPurchaseToken.self, forKey: .externalPurchaseToken)
        self.appData = try container.decodeIfPresent(AppData.self, forKey: .appData)
        self.version = try container.decodeIfPresent(String.self, forKey: .version)
        self.signedDate = try container.decodeIfPresent(Double.self, forKey: .signedDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.notificationUUID = try container.decodeIfPresent(String.self, forKey: .notificationUUID)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawNotificationType, forKey: .notificationType)
        try container.encodeIfPresent(self.rawSubtype, forKey: .subtype)
        try container.encodeIfPresent(self.data, forKey: .data)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.externalPurchaseToken, forKey: .externalPurchaseToken)
        try container.encodeIfPresent(self.appData, forKey: .appData)
        try container.encodeIfPresent(self.version, forKey: .version)
        try container.encodeIfPresent(self.signedDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .signedDate)
        try container.encodeIfPresent(self.notificationUUID, forKey: .notificationUUID)
    }
}
