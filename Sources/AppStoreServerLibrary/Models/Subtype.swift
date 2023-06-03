// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A notification subtype value that App Store Server Notifications 2 uses.
///
///[notificationSubtype](https://developer.apple.com/documentation/appstoreserverapi/notificationsubtype)
public enum Subtype: String, Decodable, Encodable, Hashable {
    case initialBuy = "INITIAL_BUY"
    case resubscribe = "RESUBSCRIBE"
    case downgrade = "DOWNGRADE"
    case upgrade = "UPGRADE"
    case autoRenewEnabled = "AUTO_RENEW_ENABLED"
    case autoRenewDisabled = "AUTO_RENEW_DISABLED"
    case voluntary = "VOLUNTARY"
    case billingRetry = "BILLING_RETRY"
    case priceIncrease = "PRICE_INCREASE"
    case gracePeriod = "GRACE_PERIOD"
    case pending = "PENDING"
    case accepted = "ACCEPTED"
    case billingRecovery = "BILLING_RECOVERY"
    case productNotForSale = "PRODUCT_NOT_FOR_SALE"
    case summary = "SUMMARY"
    case failure = "FAILURE"
}
