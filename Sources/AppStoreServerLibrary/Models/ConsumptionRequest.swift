// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///The request body containing consumption information.
///
///[ConsumptionRequest](https://developer.apple.com/documentation/appstoreserverapi/consumptionrequest)
public struct ConsumptionRequest: Decodable, Encodable, Hashable {
    
    ///A Boolean value that indicates whether the customer consented to provide consumption data to the App Store.
    ///
    ///[customerConsented](https://developer.apple.com/documentation/appstoreserverapi/customerconsented)
    public var customerConsented: Bool?
    
    ///A value that indicates the extent to which the customer consumed the in-app purchase.
    ///
    ///[consumptionStatus](https://developer.apple.com/documentation/appstoreserverapi/consumptionstatus)
    public var consumptionStatus: ConsumptionStatus?
    
    ///A value that indicates the platform on which the customer consumed the in-app purchase.
    ///
    ///[platform](https://developer.apple.com/documentation/appstoreserverapi/platform)
    public var platform: Platform?
    
    ///A Boolean value that indicates whether you provided, prior to its purchase, a free sample or trial of the content, or information about its functionality.
    
    ///[sampleContentProvided](https://developer.apple.com/documentation/appstoreserverapi/samplecontentprovided)
    public var sampleContentProvided: Bool?
    
    ///A value that indicates whether the app successfully delivered an in-app purchase that works properly.
    ///
    ///[deliveryStatus](https://developer.apple.com/documentation/appstoreserverapi/deliverystatus)
    public var deliveryStatus: DeliveryStatus?
    
    ///The UUID that an app optionally generates to map a customer’s in-app purchase with its resulting App Store transaction.
    ///
    ///[appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken)
    public var appAccountToken: UUID?

    ///The age of the customer’s account.
    ///
    ///[accountTenure](https://developer.apple.com/documentation/appstoreserverapi/accounttenure)
    public var accountTenure: AccountTenure?
    
    ///A value that indicates the amount of time that the customer used the app.
    ///
    ///[ConsumptionRequest](https://developer.apple.com/documentation/appstoreserverapi/consumptionrequest)
    public var playTime: PlayTime?
    
    ///A value that indicates the total amount, in USD, of refunds the customer has received, in your app, across all platforms.
    ///
    ///[lifetimeDollarsRefunded](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarsrefunded)
    public var lifetimeDollarsRefunded: LifetimeDollarsRefunded?
    
    ///A value that indicates the total amount, in USD, of in-app purchases the customer has made in your app, across all platforms.
    ///
    ///[lifetimeDollarsPurchased](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarspurchased)
    public var lifetimeDollarsPurchased: LifetimeDollarsPurchased?
 
    ///The status of the customer’s account.
    ///
    ///[userStatus](https://developer.apple.com/documentation/appstoreserverapi/userstatus)
    public var userStatus: UserStatus?
}
