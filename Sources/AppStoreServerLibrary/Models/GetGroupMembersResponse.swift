// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A response that contains a page of the customers that belong to a group.
///
///[GetGroupMembersResponse](https://developer.apple.com/documentation/appstoreserverapi/getgroupmembersresponse)
public struct GetGroupMembersResponse: Decodable, Encodable, Hashable, Sendable {

    public init(members: [GroupMemberEntry]? = nil, paginationToken: String? = nil, hasMore: Bool? = nil) {
        self.members = members
        self.paginationToken = paginationToken
        self.hasMore = hasMore
    }

    ///An array of the customers that belong to the group.
    ///
    ///[GroupMemberEntry](https://developer.apple.com/documentation/appstoreserverapi/groupmemberentry)
    public var members: [GroupMemberEntry]?

    ///A token you send in a subsequent request to get the next set of members.
    ///
    ///[paginationToken](https://developer.apple.com/documentation/appstoreserverapi/paginationtoken)
    public var paginationToken: String?

    ///A Boolean value that indicates whether the group has more members than the response contains.
    ///
    ///[hasMore](https://developer.apple.com/documentation/appstoreserverapi/hasmore)
    public var hasMore: Bool?
}
