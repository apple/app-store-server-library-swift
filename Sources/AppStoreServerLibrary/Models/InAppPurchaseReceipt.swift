// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///A decoded in-app purchase attribute from a legacy App Store receipt.
///
///[in_app](https://developer.apple.com/documentation/appstorereceipts/responsebody/receipt/in_app)
public struct InAppPurchaseReceipt: Hashable, Sendable {

    public init(quantity: Int64? = nil, productId: String? = nil, transactionId: String? = nil, originalTransactionId: String? = nil, purchaseDate: Date? = nil, originalPurchaseDate: Date? = nil, expiresDate: Date? = nil, cancellationDate: Date? = nil, webOrderLineItemId: Int64? = nil, isInIntroOfferPeriod: Bool? = nil, unknownAttributes: [Int64: [Data]] = [:]) {
        self.quantity = quantity
        self.productId = productId
        self.transactionId = transactionId
        self.originalTransactionId = originalTransactionId
        self.purchaseDate = purchaseDate
        self.originalPurchaseDate = originalPurchaseDate
        self.expiresDate = expiresDate
        self.cancellationDate = cancellationDate
        self.webOrderLineItemId = webOrderLineItemId
        self.isInIntroOfferPeriod = isInIntroOfferPeriod
        self.unknownAttributes = unknownAttributes
    }

    ///The number of items purchased.
    public var quantity: Int64?

    ///The unique identifier of the product purchased.
    public var productId: String?

    ///The unique identifier of the transaction.
    public var transactionId: String?

    ///The unique identifier of the original transaction.
    public var originalTransactionId: String?

    ///The time of the purchase.
    public var purchaseDate: Date?

    ///The time of the original purchase.
    public var originalPurchaseDate: Date?

    ///The expiration time of the subscription.
    public var expiresDate: Date?

    ///The time Apple customer support canceled the transaction or the subscription was upgraded.
    public var cancellationDate: Date?

    ///The unique identifier of subscription purchase events across devices, including subscription renewals.
    public var webOrderLineItemId: Int64?

    ///Whether the subscription is in an introductory offer period.
    public var isInIntroOfferPeriod: Bool?

    ///Attribute types this library does not model, keyed by type, with the verified-but-undecoded value bytes,
    ///so fields Apple adds later remain accessible without a library update.
    public var unknownAttributes: [Int64: [Data]]
}
