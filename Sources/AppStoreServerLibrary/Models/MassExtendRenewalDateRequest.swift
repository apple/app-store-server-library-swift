// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The request body that contains subscription-renewal-extension data to apply for all eligible active subscribers.
///
///[MassExtendRenewalDateRequest](https://developer.apple.com/documentation/appstoreserverapi/massextendrenewaldaterequest)
public struct MassExtendRenewalDateRequest: Decodable, Encodable, Hashable {
    ///The number of days to extend the subscription renewal date.
    ///
    ///[extendByDays](https://developer.apple.com/documentation/appstoreserverapi/extendbydays)
    ///maximum: 90
    public var extendByDays: Int32?

    ///The reason code for the subscription-renewal-date extension.
    ///
    ///[extendReasonCode](https://developer.apple.com/documentation/appstoreserverapi/extendreasoncode)
    public var extendReasonCode: ExtendReasonCode?

    ///A string that contains a unique identifier you provide to track each subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?

    ///A list of storefront country codes you provide to limit the storefronts for a subscription-renewal-date extension.
    ///
    ///[storefrontCountryCodes](https://developer.apple.com/documentation/appstoreserverapi/storefrontcountrycodes)
    public var storefrontCountryCodes: [String]?

    ///The unique identifier for the product, that you create in App Store Connect.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?
}
