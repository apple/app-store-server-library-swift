// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The request body that contains subscription-renewal-extension data for an individual subscription.
///
///[ExtendRenewalDateRequest](https://developer.apple.com/documentation/appstoreserverapi/extendrenewaldaterequest)
public struct ExtendRenewalDateRequest: Decodable, Encodable, Hashable {
    
    ///The number of days to extend the subscription renewal date.
    ///
    ///[extendByDays](https://developer.apple.com/documentation/appstoreserverapi/extendbydays)
    ///
    ///maximum: 90
    public var extendByDays: Int32?
    
    ///The reason code for the subscription date extension
    ///
    ///[extendReasonCode](https://developer.apple.com/documentation/appstoreserverapi/extendreasoncode)
    public var extendReasonCode: ExtendReasonCode?
    
    ///A string that contains a unique identifier you provide to track each subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?
}
