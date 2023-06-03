// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///The request body for notification history.
///
///[NotificationHistoryRequest](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryrequest)
public struct NotificationHistoryRequest: Decodable, Encodable, Hashable {
    ///The start date of the timespan for the requested App Store Server Notification history records. The startDate needs to precede the endDate. Choose a startDate that’s within the past 180 days from the current date.
    ///
    ///[startDate](https://developer.apple.com/documentation/appstoreserverapi/startdate)
    public var startDate: Date?

    ///The end date of the timespan for the requested App Store Server Notification history records. Choose an endDate that’s later than the startDate. If you choose an endDate in the future, the endpoint automatically uses the current date as the endDate.
    ///
    ///[endDate](https://developer.apple.com/documentation/appstoreserverapi/enddate)
    public var endDate: Date?

    ///A notification type. Provide this field to limit the notification history records to those with this one notification type. For a list of notifications types, see notificationType.
    ///Include either the transactionId or the notificationType in your query, but not both.
    ///
    ///[notificationType](https://developer.apple.com/documentation/appstoreserverapi/notificationtype)
    public var notificationType: NotificationTypeV2?

    ///A notification subtype. Provide this field to limit the notification history records to those with this one notification subtype. For a list of subtypes, see subtype. If you specify a notificationSubtype, you need to also specify its related notificationType.
    ///
    ///[notificationSubtype](https://developer.apple.com/documentation/appstoreserverapi/notificationsubtype)
    public var notificationSubtype: Subtype?

    ///The transaction identifier, which may be an original transaction identifier, of any transaction belonging to the customer. Provide this field to limit the notification history request to this one customer.
    ///Include either the transactionId or the notificationType in your query, but not both.
    ///
    ///[transactionId](https://developer.apple.com/documentation/appstoreserverapi/transactionid)
    public var transactionId: String?

    ///A Boolean value you set to true to request only the notifications that haven’t reached your server successfully. The response also includes notifications that the App Store server is currently retrying to send to your server.
    ///
    ///[onlyFailures](https://developer.apple.com/documentation/appstoreserverapi/onlyfailures)
    public var onlyFailures: Bool?
}
