// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The type of In-App Purchase products you can offer in your app.
///
///[type](https://developer.apple.com/documentation/appstoreserverapi/type)
public enum ProductType: String, Decodable, Encodable, Hashable, Sendable {
    ///An auto-renewable subscription
    case autoRenewableSubscription = "Auto-Renewable Subscription"

    ///A non-consumable In-App Purchase
    case nonConsumable = "Non-Consumable"

    ///A consumable In-App Purchase
    case consumable = "Consumable"

    ///A non-renewing subscription
    case nonRenewingSubscription = "Non-Renewing Subscription"
}
