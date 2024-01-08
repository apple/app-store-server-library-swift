// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A decoded payload containing the version 2 notification data.
///
///[responseBodyV2DecodedPayload](https://developer.apple.com/documentation/appstoreservernotifications/responsebodyv2decodedpayload)
public struct ResponseBodyV2DecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable {
    
    public init(notificationType: NotificationTypeV2? = nil, subtype: Subtype? = nil, notificationUUID: String? = nil, data: Data? = nil, version: String? = nil, signedDate: Date? = nil, summary: Summary? = nil) {
        self.notificationType = notificationType
        self.subtype = subtype
        self.notificationUUID = notificationUUID
        self.data = data
        self.version = version
        self.signedDate = signedDate
        self.summary = summary
    }
    
    public init(rawNotificationType: String? = nil, rawSubtype: String? = nil, notificationUUID: String? = nil, data: Data? = nil, version: String? = nil, signedDate: Date? = nil, summary: Summary? = nil) {
        self.rawNotificationType = rawNotificationType
        self.rawSubtype = rawSubtype
        self.notificationUUID = notificationUUID
        self.data = data
        self.version = version
        self.signedDate = signedDate
        self.summary = summary
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
    ///The data and summary fields are mutually exclusive. The payload contains one of the fields, but not both.
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
    ///The data and summary fields are mutually exclusive. The payload contains one of the fields, but not both.
    ///
    ///[summary](https://developer.apple.com/documentation/appstoreservernotifications/summary)
    public var summary: Summary?
}
