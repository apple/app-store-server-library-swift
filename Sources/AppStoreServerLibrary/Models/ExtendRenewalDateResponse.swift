// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A response that indicates whether an individual renewal-date extension succeeded, and related details.
///
///[ExtendRenewalDateResponse](https://developer.apple.com/documentation/appstoreserverapi/extendrenewaldateresponse)
public struct ExtendRenewalDateResponse: Decodable, Encodable, Hashable, Sendable {

    public init(originalTransactionId: String? = nil, webOrderLineItemId: String? = nil, success: Bool? = nil, effectiveDate: Date? = nil) {
        self.originalTransactionId = originalTransactionId
        self.webOrderLineItemId = webOrderLineItemId
        self.success = success
        self.effectiveDate = effectiveDate
    }

    ///The original transaction identifier of a purchase.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?
    
    ///The unique identifier of subscription-purchase events across devices, including renewals.
    ///
    ///[webOrderLineItemId](https://developer.apple.com/documentation/appstoreserverapi/weborderlineitemid)
    public var webOrderLineItemId: String?
    
    ///A Boolean value that indicates whether the subscription-renewal-date extension succeeded.
    ///
    ///[success](https://developer.apple.com/documentation/appstoreserverapi/success)
    public var success: Bool?
   
    ///The new subscription expiration date for a subscription-renewal extension.
    ///
    ///[effectiveDate](https://developer.apple.com/documentation/appstoreserverapi/effectivedate)
    public var effectiveDate: Date?
}
