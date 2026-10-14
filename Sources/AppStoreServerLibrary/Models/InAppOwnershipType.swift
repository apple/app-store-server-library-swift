// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A string that describes whether the transaction was purchased by the customer, or is available to them through Family Sharing, an organization, or a group.
///
///[inAppOwnershipType](https://developer.apple.com/documentation/appstoreserverapi/inappownershiptype)
public enum InAppOwnershipType: String, Decodable, Encodable, Hashable, Sendable {
    ///The transaction belongs to a family member who benefits from service.
    case familyShared = "FAMILY_SHARED"

    ///The transaction belongs to the purchaser.
    case purchased = "PURCHASED"

    ///The transaction belongs to a customer who has access through an organization or group.
    case assigned = "ASSIGNED"
}
