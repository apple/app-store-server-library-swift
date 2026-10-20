// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A response that contains the groups a customer belongs to, and their role in each group.
///
///[GetCustomerGroupsResponse](https://developer.apple.com/documentation/appstoreserverapi/getcustomergroupsresponse)
public struct GetCustomerGroupsResponse: Decodable, Encodable, Hashable, Sendable {

    public init(groups: [GroupEntry]? = nil) {
        self.groups = groups
    }

    ///An array of groups that the customer belongs to.
    ///
    ///[GroupEntry](https://developer.apple.com/documentation/appstoreserverapi/groupentry)
    public var groups: [GroupEntry]?
}
