// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The type that describes the in-app purchase or external purchase event for which the App Store sends the version 2 notification.
///
///[notificationType](https://developer.apple.com/documentation/appstoreservernotifications/notificationtype)
public enum NotificationTypeV2: String, Decodable, Encodable, Hashable, Sendable {
    case subscribed = "SUBSCRIBED"
    case didChangeRenewalPref = "DID_CHANGE_RENEWAL_PREF"
    case didChangeRenewalStatus = "DID_CHANGE_RENEWAL_STATUS"
    case offerRedeemed = "OFFER_REDEEMED"
    case didRenew = "DID_RENEW"
    case expired = "EXPIRED"
    case didFailToRenew = "DID_FAIL_TO_RENEW"
    case gracePeriodExpired = "GRACE_PERIOD_EXPIRED"
    case priceIncrease = "PRICE_INCREASE"
    case refund = "REFUND"
    case refundDeclined = "REFUND_DECLINED"
    case consumptionRequest = "CONSUMPTION_REQUEST"
    case renewalExtended = "RENEWAL_EXTENDED"
    case revoke = "REVOKE"
    case test = "TEST"
    case renewalExtension = "RENEWAL_EXTENSION"
    case refundReversed = "REFUND_REVERSED"
    case externalPurchaseToken = "EXTERNAL_PURCHASE_TOKEN"
    case oneTimeCharge = "ONE_TIME_CHARGE"
    case rescindConsent = "RESCIND_CONSENT"
}
