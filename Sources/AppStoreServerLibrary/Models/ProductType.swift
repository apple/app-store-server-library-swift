// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The type of in-app purchase products you can offer in your app.
///
///[type](https://developer.apple.com/documentation/appstoreserverapi/type)
public enum ProductType: String, Decodable, Encodable, Hashable, Sendable {
    case autoRenewableSubscription = "Auto-Renewable Subscription"
    case nonConsumable = "Non-Consumable"
    case consumable = "Consumable"
    case nonRenewingSubscription = "Non-Renewing Subscription"
}
