// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The relationship of the user with the family-shared purchase to which they have access.
///
///[inAppOwnershipType](https://developer.apple.com/documentation/appstoreserverapi/inappownershiptype)
public enum InAppOwnershipType: String, Decodable, Encodable, Hashable, Sendable {
    case familyShared = "FAMILY_SHARED"
    case purchased = "PURCHASED"
}
