// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A string that describes the kind of multiseat purchase a customer’s access comes from.
///
///[groupType](https://developer.apple.com/documentation/appstoreserverapi/grouptype)
public enum GroupType: String, Decodable, Encodable, Hashable, Sendable {
    ///An organization bought seats through Volume Purchasing and assigned one to the customer.
    case organization = "ORGANIZATION"

    ///A subscriber bought seats through Group Purchases and invited the customer to join.
    case consumer = "CONSUMER"
}
