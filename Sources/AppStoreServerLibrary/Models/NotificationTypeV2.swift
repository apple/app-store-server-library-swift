// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A notification type value that App Store Server Notifications V2 uses.
///
///[notificationType](https://developer.apple.com/documentation/appstoreserverapi/notificationtype)
public enum NotificationTypeV2: String, Decodable, Encodable, Hashable {
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
}
