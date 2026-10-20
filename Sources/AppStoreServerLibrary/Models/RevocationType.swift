// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///The type of the refund or revocation that applies to the transaction.
///
///[revocationType](https://developer.apple.com/documentation/appstoreserverapi/revocationtype)
public enum RevocationType: String, Decodable, Encodable, Hashable, Sendable {
    ///The transaction has a full refund.
    case refundFull = "REFUND_FULL"

    ///The transaction has a prorated refund.
    case refundProrated = "REFUND_PRORATED"

    ///The transaction is revoked from Family Sharing.
    case familyRevoke = "FAMILY_REVOKE"

    ///The organization or group purchaser removed the subscription from the customer.
    case assignmentRevoke = "ASSIGNMENT_REVOKE"
}
