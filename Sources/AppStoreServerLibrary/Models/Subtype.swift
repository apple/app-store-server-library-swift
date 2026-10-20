// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A string that provides details about select notification types in version 2.
///
///[subtype](https://developer.apple.com/documentation/appstoreservernotifications/subtype)
public enum Subtype: String, Decodable, Encodable, Hashable, Sendable {
    ///Applies to the SUBSCRIBED notificationType.
    case initialBuy = "INITIAL_BUY"

    ///Applies to the SUBSCRIBED notificationType.
    case resubscribe = "RESUBSCRIBE"

    ///Applies to the DID_CHANGE_RENEWAL_PREF and OFFER_REDEEMED notificationType.
    case downgrade = "DOWNGRADE"

    ///Applies to the DID_CHANGE_RENEWAL_PREF and OFFER_REDEEMED notificationType.
    case upgrade = "UPGRADE"

    ///Applies to the DID_CHANGE_RENEWAL_STATUS notificationType.
    case autoRenewEnabled = "AUTO_RENEW_ENABLED"

    ///Applies to the DID_CHANGE_RENEWAL_STATUS notificationType.
    case autoRenewDisabled = "AUTO_RENEW_DISABLED"

    ///Applies to the EXPIRED notificationType.
    case voluntary = "VOLUNTARY"

    ///Applies to the EXPIRED notificationType.
    case billingRetry = "BILLING_RETRY"

    ///Applies to the EXPIRED notificationType.
    case priceIncrease = "PRICE_INCREASE"

    ///Applies to the DID_FAIL_TO_RENEW notificationType.
    case gracePeriod = "GRACE_PERIOD"

    ///Applies to the PRICE_INCREASE notificationType.
    case pending = "PENDING"

    ///Applies to the PRICE_INCREASE notificationType.
    case accepted = "ACCEPTED"

    ///Applies to the DID_RENEW notificationType.
    case billingRecovery = "BILLING_RECOVERY"

    ///Applies to the EXPIRED notificationType.
    case productNotForSale = "PRODUCT_NOT_FOR_SALE"

    ///Applies to the RENEWAL_EXTENSION notificationType.
    case summary = "SUMMARY"

    ///Applies to the RENEWAL_EXTENSION notificationType.
    case failure = "FAILURE"

    ///Applies to the EXTERNAL_PURCHASE_TOKEN notificationType.
    case unreported = "UNREPORTED"

    ///Applies to the EXTERNAL_PURCHASE_TOKEN notificationType.
    case created = "CREATED"

    ///Applies to the EXTERNAL_PURCHASE_TOKEN notificationType.
    case activeTokenReminder = "ACTIVE_TOKEN_REMINDER"
}
