// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The reason for a refunded transaction.
///
///[revocationReason](https://developer.apple.com/documentation/appstoreserverapi/revocationreason)
public enum RevocationReason: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The App Store refunded the transaction on behalf of the customer due to an actual or perceived issue within your app.
    case refundedDueToIssue = 1

    ///The App Store refunded the transaction on behalf of the customer for other reasons, for example, an accidental purchase.
    case refundedForOtherReason = 0
}
