// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A decoded payload containing the version 2 notification data.
///
///[responseBodyV2DecodedPayload](https://developer.apple.com/documentation/appstoreservernotifications/responsebodyv2decodedpayload)
public struct ResponseBodyV2DecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {

    public init(notificationType: NotificationTypeV2? = nil, subtype: Subtype? = nil, notificationUUID: String? = nil, data: Data? = nil, version: String? = nil, signedDate: Date? = nil, summary: Summary? = nil, externalPurchaseToken: ExternalPurchaseToken? = nil) {
        self.notificationType = notificationType
        self.subtype = subtype
        self.notificationUUID = notificationUUID
        self.data = data
        self.version = version
        self.signedDate = signedDate
        self.summary = summary
        self.externalPurchaseToken = externalPurchaseToken
    }
    
    public init(rawNotificationType: String? = nil, rawSubtype: String? = nil, notificationUUID: String? = nil, data: Data? = nil, version: String? = nil, signedDate: Date? = nil, summary: Summary? = nil, externalPurchaseToken: ExternalPurchaseToken? = nil) {
        self.rawNotificationType = rawNotificationType
        self.rawSubtype = rawSubtype
        self.notificationUUID = notificationUUID
        self.data = data
        self.version = version
        self.signedDate = signedDate
        self.summary = summary
        self.externalPurchaseToken = externalPurchaseToken
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

    ///Additional information that identifies the notification event. The subtype field is present only for specific version 2 notifications.
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

    ///A unique identifier for the notification.
    ///
    ///[notificationUUID](https://developer.apple.com/documentation/appstoreservernotifications/notificationuuid)
    public var notificationUUID: String?

    ///The object that contains the app metadata and signed renewal and transaction information.
    ///The data, summary, and externalPurchaseToken fields are mutually exclusive. The payload contains only one of these fields.
    ///
    ///[data](https://developer.apple.com/documentation/appstoreservernotifications/data)
    public var data: Data?

    ///A string that indicates the notification’s App Store Server Notifications version number.
    ///
    ///[version](https://developer.apple.com/documentation/appstoreservernotifications/version)
    public var version: String?

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreserverapi/signeddate)
    public var signedDate: Date?

    ///The summary data that appears when the App Store server completes your request to extend a subscription renewal date for eligible subscribers.
    ///The data, summary, and externalPurchaseToken fields are mutually exclusive. The payload contains only one of these fields.
    ///
    ///[summary](https://developer.apple.com/documentation/appstoreservernotifications/summary)
    public var summary: Summary?

    ///This field appears when the notificationType is EXTERNAL_PURCHASE_TOKEN.
    ///The data, summary, and externalPurchaseToken fields are mutually exclusive. The payload contains only one of these fields.
    ///
    ///[externalPurchaseToken](https://developer.apple.com/documentation/appstoreservernotifications/externalpurchasetoken)
    public var externalPurchaseToken: ExternalPurchaseToken?
    
    enum CodingKeys: CodingKey {
        case notificationType
        case subtype
        case notificationUUID
        case data
        case version
        case signedDate
        case summary
        case externalPurchaseToken
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawNotificationType = try container.decodeIfPresent(String.self, forKey: .notificationType)
        self.rawSubtype = try container.decodeIfPresent(String.self, forKey: .subtype)
        self.notificationUUID = try container.decodeIfPresent(String.self, forKey: .notificationUUID)
        self.data = try container.decodeIfPresent(Data.self, forKey: .data)
        self.version = try container.decodeIfPresent(String.self, forKey: .version)
        self.signedDate = try container.decodeIfPresent(Date.self, forKey: .signedDate)
        self.summary = try container.decodeIfPresent(Summary.self, forKey: .summary)
        self.externalPurchaseToken = try container.decodeIfPresent(ExternalPurchaseToken.self, forKey: .externalPurchaseToken)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawNotificationType, forKey: .notificationType)
        try container.encodeIfPresent(self.rawSubtype, forKey: .subtype)
        try container.encodeIfPresent(self.notificationUUID, forKey: .notificationUUID)
        try container.encodeIfPresent(self.data, forKey: .data)
        try container.encodeIfPresent(self.version, forKey: .version)
        try container.encodeIfPresent(self.signedDate, forKey: .signedDate)
        try container.encodeIfPresent(self.summary, forKey: .summary)
        try container.encodeIfPresent(self.externalPurchaseToken, forKey: .externalPurchaseToken)
    }
}
