// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The payload data for a subscription-renewal-date extension notification.
///
///[summary](https://developer.apple.com/documentation/appstoreservernotifications/summary)
public struct Summary: Decodable, Encodable, Hashable {
    ///The server environment that the notification applies to, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/appstoreservernotifications/environment)
    public var environment: Environment?

    ///The unique identifier of an app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/appstoreservernotifications/appappleid)
    public var appAppleId: Int64?

    ///The bundle identifier of an app.
    ///
    ///[bundleId](https://developer.apple.com/documentation/appstoreserverapi/bundleid)
    public var bundleId: String?

    ///The unique identifier for the product, that you create in App Store Connect.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?

    ///A string that contains a unique identifier you provide to track each subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?

    ///A list of storefront country codes you provide to limit the storefronts for a subscription-renewal-date extension.
    ///
    ///[storefrontCountryCodes](https://developer.apple.com/documentation/appstoreserverapi/storefrontcountrycodes)
    public var storefrontCountryCodes: [String]?

    ///The count of subscriptions that successfully receive a subscription-renewal-date extension.
    ///
    ///[succeededCount](https://developer.apple.com/documentation/appstoreserverapi/succeededcount)
    public var succeededCount: Int64?

    ///The count of subscriptions that fail to receive a subscription-renewal-date extension.
    ///
    ///[failedCount](https://developer.apple.com/documentation/appstoreserverapi/failedcount)
    public var failedCount: Int64?
}
