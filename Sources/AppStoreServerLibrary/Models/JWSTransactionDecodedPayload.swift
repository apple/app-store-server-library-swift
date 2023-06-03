// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A decoded payload containing transaction information.
///
///[JWSTransactionDecodedPayload](https://developer.apple.com/documentation/appstoreserverapi/jwstransactiondecodedpayload)
public struct JWSTransactionDecodedPayload: DecodedSignedData, Decodable, Encodable, Hashable {
    ///The original transaction identifier of a purchase.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?
    
    ///The unique identifier for a transaction such as an in-app purchase, restored in-app purchase, or subscription renewal.
    ///
    ///[transactionId](https://developer.apple.com/documentation/appstoreserverapi/transactionid)
    public var transactionId: String?
                    
    ///The unique identifier of subscription-purchase events across devices, including renewals.
    ///
    ///[webOrderLineItemId](https://developer.apple.com/documentation/appstoreserverapi/weborderlineitemid)
    public var webOrderLineItemId: String?

    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    ///The unique identifier for the product, that you create in App Store Connect.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?

    ///The identifier of the subscription group that the subscription belongs to.
    ///
    ///[subscriptionGroupIdentifier](https://developer.apple.com/documentation/appstoreserverapi/subscriptiongroupidentifier)
    public var subscriptionGroupIdentifier: String?

    ///The time that the App Store charged the user’s account for an in-app purchase, a restored in-app purchase, a subscription, or a subscription renewal after a lapse.
    ///
    ///[purchaseDate](https://developer.apple.com/documentation/appstoreserverapi/purchasedate)
    public var purchaseDate: Date?

    ///The purchase date of the transaction associated with the original transaction identifier.
    ///
    ///[originalPurchaseDate](https://developer.apple.com/documentation/appstoreserverapi/originalpurchasedate)
    public var originalPurchaseDate: Date?

    ///The UNIX time, in milliseconds, an auto-renewable subscription expires or renews.
    ///
    ///[expiresDate](https://developer.apple.com/documentation/appstoreserverapi/expiresdate)
    public var expiresDate: Date?

    ///The number of consumable products purchased.
    ///
    ///[quantity](https://developer.apple.com/documentation/appstoreserverapi/quantity)
    public var quantity: Int32?

    ///The type of the in-app purchase.
    ///
    /// [type](https://developer.apple.com/documentation/appstoreserverapi/type)
    public var type: ProductType?

    ///The UUID that an app optionally generates to map a customer’s in-app purchase with its resulting App Store transaction.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID?

    ///A string that describes whether the transaction was purchased by the user, or is available to them through Family Sharing.
    ///
    ///[inAppOwnershipType](https://developer.apple.com/documentation/appstoreserverapi/inappownershiptype)
    public var inAppOwnershipType: InAppOwnershipType?

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/appstoreserverapi/signeddate)
    public var signedDate: Date?

    ///The reason that the App Store refunded the transaction or revoked it from family sharing.
    ///
    ///[revocationReason](https://developer.apple.com/documentation/appstoreserverapi/revocationreason)
    public var revocationReason: RevocationReason?

    ///The UNIX time, in milliseconds, that Apple Support refunded a transaction.
    ///
    /// [revocationDate](https://developer.apple.com/documentation/appstoreserverapi/revocationdate)
    public var revocationDate: Date?

    ///The Boolean value that indicates whether the user upgraded to another subscription.
    ///
    ///[isUpgraded](https://developer.apple.com/documentation/appstoreserverapi/isupgraded)
    public var isUpgraded: Bool?

    ///A value that represents the promotional offer type.
    ///
    ///[offerType](https://developer.apple.com/documentation/appstoreserverapi/offertype)
    public var offerType: OfferType?

    ///The identifier that contains the promo code or the promotional offer identifier.
    ///
    ///[offerIdentifier](https://developer.apple.com/documentation/appstoreserverapi/offeridentifier)
    public var offerIdentifier: String?

    ///The server environment, either sandbox or production.
    ///
    /// [environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
    public var environment: Environment?

    ///The three-letter code that represents the country or region associated with the App Store storefront for the purchase.
    ///
    ///[storefront](https://developer.apple.com/documentation/appstoreserverapi/storefront)
    public var storefront: String?

    ///An Apple-defined value that uniquely identifies the App Store storefront associated with the purchase.
    ///
    ///[storefrontId](https://developer.apple.com/documentation/appstoreserverapi/storefrontid)
    public var storefrontId: String?

    ///The reason for the purchase transaction, which indicates whether it’s a customer’s purchase or a renewal for an auto-renewable subscription that the system initates.
    ///
    ///[transactionReason](https://developer.apple.com/documentation/appstoreserverapi/transactionreason)
    public var transactionReason: TransactionReason?
}
