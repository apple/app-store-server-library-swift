// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The type that describes the In-App Purchase or external purchase event for which the App Store sends the version 2 notification.
///
///[notificationType](https://developer.apple.com/documentation/appstoreservernotifications/notificationtype)
public enum NotificationTypeV2: String, Decodable, Encodable, Hashable, Sendable {
    ///A notification type that, along with its subtype, indicates that the customer subscribed to an auto-renewable subscription.
    case subscribed = "SUBSCRIBED"

    ///A notification type that, along with its subtype, indicates that the customer made a change to their subscription plan.
    case didChangeRenewalPref = "DID_CHANGE_RENEWAL_PREF"

    ///A notification type that, along with its subtype, indicates that the customer made a change to the subscription renewal status.
    case didChangeRenewalStatus = "DID_CHANGE_RENEWAL_STATUS"

    ///A notification type that, along with its subtype, indicates that a customer with an active subscription redeemed a subscription offer.
    case offerRedeemed = "OFFER_REDEEMED"

    ///A notification type that, along with its subtype, indicates that the subscription successfully renewed.
    case didRenew = "DID_RENEW"

    ///A notification type that, along with its subtype, indicates that a subscription expired.
    case expired = "EXPIRED"

    ///A notification type that, along with its subtype, indicates that the subscription failed to renew due to a billing issue.
    case didFailToRenew = "DID_FAIL_TO_RENEW"

    ///A notification type that indicates that the billing grace period has ended without renewing the subscription, so you can turn off access to the service or content.
    case gracePeriodExpired = "GRACE_PERIOD_EXPIRED"

    ///A notification type that, along with its subtype, indicates that the system has informed the customer of an auto-renewable subscription price increase.
    case priceIncrease = "PRICE_INCREASE"

    ///A notification type that indicates that the App Store successfully refunded a transaction for a consumable In-App Purchase, a non-consumable In-App Purchase, an auto-renewable subscription, or a non-renewing subscription.
    case refund = "REFUND"

    ///A notification type that indicates the App Store declined a refund request.
    case refundDeclined = "REFUND_DECLINED"

    ///A notification type that indicates that the customer initiated a refund request for a consumable In-App Purchase or auto-renewable subscription, and the App Store is requesting that you provide consumption data.
    case consumptionRequest = "CONSUMPTION_REQUEST"

    ///A notification type that indicates the App Store extended the subscription renewal date for a specific subscription.
    case renewalExtended = "RENEWAL_EXTENDED"

    ///A notification type that indicates that an In-App Purchase the customer was entitled to through Family Sharing is no longer available through sharing.
    case revoke = "REVOKE"

    ///A notification type that the App Store server sends when you request it by calling the Request a Test Notification endpoint.
    case test = "TEST"

    ///A notification type that, along with its subtype, indicates that the App Store is attempting to extend the subscription renewal date that you request by calling Extend Subscription Renewal Dates for All Active Subscribers.
    case renewalExtension = "RENEWAL_EXTENSION"

    ///A notification type that indicates the App Store reversed a previously granted refund due to a dispute that the customer raised.
    case refundReversed = "REFUND_REVERSED"

    ///A notification type that applies only to apps that get tokens from the External Purchase or TransactionReporting APIs.
    case externalPurchaseToken = "EXTERNAL_PURCHASE_TOKEN"

    ///A notification type that indicates the customer purchased a consumable, non-consumable, or non-renewing subscription.
    case oneTimeCharge = "ONE_TIME_CHARGE"

    ///A notification type that indicates that you called the Change Subscription Price endpoint.
    case priceChange = "PRICE_CHANGE"

    ///A notification type that indicates you used the Change Subscription Metadata endpoint to change the metadata for a subscription.
    case metadataUpdate = "METADATA_UPDATE"

    ///A notification type that indicates you used the Migrate Subscription to Advanced Commerce API endpoint.
    case migration = "MIGRATION"

    ///A notification type that indicates the parent or guardian has withdrawn consent for a child’s app usage.
    case rescindConsent = "RESCIND_CONSENT"
}
