// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The reason for a refunded transaction.
///
///[revocationReason](https://developer.apple.com/documentation/appstoreserverapi/revocationreason)
public enum RevocationReason: Int32, Decodable, Encodable, Hashable, Sendable {
    case refundedDueToIssue = 1
    case refundedForOtherReason = 0
}
