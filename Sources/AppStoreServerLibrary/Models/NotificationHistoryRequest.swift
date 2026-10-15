// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///The request body for notification history.
///
///[NotificationHistoryRequest](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryrequest)
public struct NotificationHistoryRequest: Decodable, Encodable, Hashable, Sendable {

    public init(startDate: Date, endDate: Date, notificationType: NotificationTypeV2? = nil, notificationSubtype: Subtype? = nil, onlyFailures: Bool? = nil, transactionId: String? = nil) {
        self.init(startDate: startDate, endDate: endDate, rawNotificationType: notificationType?.rawValue, rawNotificationSubtype: notificationSubtype?.rawValue, onlyFailures: onlyFailures, transactionId: transactionId)
    }

    @_disfavoredOverload
    public init(startDate: Date, endDate: Date, rawNotificationType: String? = nil, rawNotificationSubtype: String? = nil, onlyFailures: Bool? = nil, transactionId: String? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.rawNotificationType = rawNotificationType
        self.rawNotificationSubtype = rawNotificationSubtype
        self.onlyFailures = onlyFailures
        self.transactionId = transactionId
    }

    ///The start date of the timespan for the requested App Store Server Notification history records.
    ///
    ///[startDate](https://developer.apple.com/documentation/appstoreserverapi/startdate)
    public var startDate: Date

    ///The end date of the timespan for the requested App Store Server Notification history records.
    ///
    ///[endDate](https://developer.apple.com/documentation/appstoreserverapi/enddate)
    public var endDate: Date

    ///A notification type.
    ///
    ///[notificationType](https://developer.apple.com/documentation/appstoreserverapi/notificationtype)
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

    ///A notification subtype.
    ///
    ///[notificationSubtype](https://developer.apple.com/documentation/appstoreserverapi/notificationsubtype)
    public var notificationSubtype: Subtype? {
        get {
            return rawNotificationSubtype.flatMap { Subtype(rawValue: $0) }
        }
        set {
            self.rawNotificationSubtype = newValue.map { $0.rawValue }
        }
    }

    ///See ``notificationSubtype``
    public var rawNotificationSubtype: String?

    ///A Boolean value you set to true to request only the notifications that haven’t reached your server successfully.
    ///
    ///[onlyFailures](https://developer.apple.com/documentation/appstoreserverapi/onlyfailures)
    public var onlyFailures: Bool?

    ///The transaction identifier, which may be an original transaction identifier, of any transaction belonging to the customer.
    ///
    ///[transactionId](https://developer.apple.com/documentation/appstoreserverapi/transactionid)
    public var transactionId: String?

    public enum CodingKeys: CodingKey {
        case startDate
        case endDate
        case notificationType
        case notificationSubtype
        case onlyFailures
        case transactionId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startDate = try Date(timeIntervalSince1970: container.decode(Double.self, forKey: .startDate) / 1000.0)
        self.endDate = try Date(timeIntervalSince1970: container.decode(Double.self, forKey: .endDate) / 1000.0)
        self.rawNotificationType = try container.decodeIfPresent(String.self, forKey: .notificationType)
        self.rawNotificationSubtype = try container.decodeIfPresent(String.self, forKey: .notificationSubtype)
        self.onlyFailures = try container.decodeIfPresent(Bool.self, forKey: .onlyFailures)
        self.transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode((self.startDate.timeIntervalSince1970 * 1000.0).rounded(.towardZero), forKey: .startDate)
        try container.encode((self.endDate.timeIntervalSince1970 * 1000.0).rounded(.towardZero), forKey: .endDate)
        try container.encodeIfPresent(self.rawNotificationType, forKey: .notificationType)
        try container.encodeIfPresent(self.rawNotificationSubtype, forKey: .notificationSubtype)
        try container.encodeIfPresent(self.onlyFailures, forKey: .onlyFailures)
        try container.encodeIfPresent(self.transactionId, forKey: .transactionId)
    }
}
