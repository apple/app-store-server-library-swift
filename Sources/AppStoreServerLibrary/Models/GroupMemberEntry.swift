// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A customer that belongs to a group.
///
///[GroupMemberEntry](https://developer.apple.com/documentation/appstoreserverapi/groupmemberentry)
public struct GroupMemberEntry: Decodable, Encodable, Hashable, Sendable {

    public init(appTransactionId: String? = nil) {
        self.appTransactionId = appTransactionId
    }

    ///The unique identifier of the member’s app download transaction.
    ///
    ///[appTransactionId](https://developer.apple.com/documentation/appstoreserverapi/apptransactionid)
    public var appTransactionId: String?
}
