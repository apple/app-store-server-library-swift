// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The identifier, type, and per-product roles for a group that a customer belongs to.
///
///[GroupEntry](https://developer.apple.com/documentation/appstoreserverapi/groupentry)
public struct GroupEntry: Decodable, Encodable, Hashable, Sendable {

    public init(groupId: String? = nil, groupType: GroupType? = nil, roles: [RoleEntry]? = nil) {
        self.init(groupId: groupId, rawGroupType: groupType?.rawValue, roles: roles)
    }

    @_disfavoredOverload
    public init(groupId: String? = nil, rawGroupType: String? = nil, roles: [RoleEntry]? = nil) {
        self.groupId = groupId
        self.rawGroupType = rawGroupType
        self.roles = roles
    }

    ///The identifier of the group.
    ///
    ///[groupId](https://developer.apple.com/documentation/appstoreserverapi/groupid)
    public var groupId: String?

    ///The type of the group.
    ///
    ///[groupType](https://developer.apple.com/documentation/appstoreserverapi/grouptype)
    public var groupType: GroupType? {
        get {
            return rawGroupType.flatMap { GroupType(rawValue: $0) }
        }
        set {
            self.rawGroupType = newValue.map { $0.rawValue }
        }
    }

    ///See ``groupType``
    public var rawGroupType: String?

    ///An optional array of the customer’s roles in this group, one for each of your products that the group provides access to.
    ///
    ///[RoleEntry](https://developer.apple.com/documentation/appstoreserverapi/roleentry)
    public var roles: [RoleEntry]?

    public enum CodingKeys: CodingKey {
        case groupId
        case groupType
        case roles
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupId = try container.decodeIfPresent(String.self, forKey: .groupId)
        self.rawGroupType = try container.decodeIfPresent(String.self, forKey: .groupType)
        self.roles = try container.decodeIfPresent([RoleEntry].self, forKey: .roles)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.groupId, forKey: .groupId)
        try container.encodeIfPresent(self.rawGroupType, forKey: .groupType)
        try container.encodeIfPresent(self.roles, forKey: .roles)
    }
}
