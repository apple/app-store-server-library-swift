// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains the App Store Server Notifications history for your app.
///
///[NotificationHistoryResponse](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryresponse)
public struct NotificationHistoryResponse: Decodable, Encodable, Hashable, Sendable {

    public init(notificationHistory: [NotificationHistoryResponseItem]? = nil, hasMore: Bool? = nil, paginationToken: String? = nil) {
        self.notificationHistory = notificationHistory
        self.hasMore = hasMore
        self.paginationToken = paginationToken
    }

    ///An array of App Store Server Notifications history records.
    ///
    ///[notificationHistoryResponseItem](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryresponseitem)
    public var notificationHistory: [NotificationHistoryResponseItem]?

    ///A Boolean value that indicates whether the App Store has more notification history records to send.
    ///
    ///[hasMore](https://developer.apple.com/documentation/appstoreserverapi/hasmore)
    public var hasMore: Bool?

    ///A pagination token that you provide to Get Notification History on a subsequent request to get the next page of responses.
    ///
    ///[paginationToken](https://developer.apple.com/documentation/appstoreserverapi/paginationtoken)
    public var paginationToken: String?
}
