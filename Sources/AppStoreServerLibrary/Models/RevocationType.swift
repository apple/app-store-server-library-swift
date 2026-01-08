// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The type of the refund or revocation that applies to the transaction.
///
///[revocationType](https://developer.apple.com/documentation/appstoreservernotifications/revocationtype)
public enum RevocationType: String, Decodable, Encodable, Hashable, Sendable {
    case refundFull = "REFUND_FULL"
    case refundProrated = "REFUND_PRORATED"
    case familyRevoke = "FAMILY_REVOKE"
}
