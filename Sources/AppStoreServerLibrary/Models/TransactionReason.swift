// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The cause of a purchase transaction, which indicates whether it’s a customer’s purchase or a renewal for an auto-renewable subscription that the system initiates.
///
///[transactionReason](https://developer.apple.com/documentation/appstoreserverapi/transactionreason)
public enum TransactionReason: String, Decodable, Encodable, Hashable, Sendable {
    case purchase = "PURCHASE"
    case renewal = "RENEWAL"
}
