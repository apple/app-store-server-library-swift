// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///A response that indicates the current status of a request to extend the subscription renewal date to all eligible subscribers.
///
///[MassExtendRenewalDateStatusResponse](https://developer.apple.com/documentation/appstoreserverapi/massextendrenewaldatestatusresponse)
public struct MassExtendRenewalDateStatusResponse: Decodable, Encodable, Hashable {
    ///A string that contains a unique identifier you provide to track each subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String?

    ///A Boolean value that indicates whether the App Store completed the request to extend a subscription renewal date to active subscribers.
    ///
    ///[complete](https://developer.apple.com/documentation/appstoreserverapi/complete)
    public var complete: Bool?

    ///The UNIX time, in milliseconds, that the App Store completes a request to extend a subscription renewal date for eligible subscribers.
    ///
    ///[completeDate](https://developer.apple.com/documentation/appstoreserverapi/completedate)
    public var completeDate: Date?

    ///The count of subscriptions that successfully receive a subscription-renewal-date extension.
    ///
    ///[succeededCount](https://developer.apple.com/documentation/appstoreserverapi/succeededcount)
    public var succeededCount: Int64?

    ///The count of subscriptions that fail to receive a subscription-renewal-date extension.
    ///
    ///[failedCount](https://developer.apple.com/documentation/appstoreserverapi/failedcount)
    public var failedCount: Int64?
}
