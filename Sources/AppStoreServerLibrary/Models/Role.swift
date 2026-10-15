// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A string that identifies a customer’s role for a product within a group.
///
///[role](https://developer.apple.com/documentation/appstoreserverapi/role)
public enum Role: String, Decodable, Encodable, Hashable, Sendable {
    ///The customer has a seat in the group but doesn’t administer it.
    case none = "NONE"

    ///The customer administers the group for the product.
    case admin = "ADMIN"
}
