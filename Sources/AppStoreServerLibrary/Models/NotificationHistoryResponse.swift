// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains the App Store Server Notifications history for your app.
///
///[NotificationHistoryResponse](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryresponse)
public struct NotificationHistoryResponse: Decodable, Encodable, Hashable, Sendable {

    public init(paginationToken: String? = nil, hasMore: Bool? = nil, notificationHistory: [NotificationHistoryResponseItem]? = nil) {
        self.paginationToken = paginationToken
        self.hasMore = hasMore
        self.notificationHistory = notificationHistory
    }

    ///A pagination token that you return to the endpoint on a subsequent call to receive the next set of results.
    ///
    ///[paginationToken](https://developer.apple.com/documentation/appstoreserverapi/paginationtoken)
    public var paginationToken: String?

    ///A Boolean value indicating whether the App Store has more transaction data.
    ///
    ///[hasMore](https://developer.apple.com/documentation/appstoreserverapi/hasmore)
    public var hasMore: Bool?

    ///An array of App Store server notification history records.
    ///
    ///[notificationHistoryResponseItem](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryresponseitem)
    public var notificationHistory: [NotificationHistoryResponseItem]?
}
