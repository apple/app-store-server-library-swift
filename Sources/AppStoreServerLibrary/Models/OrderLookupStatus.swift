// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates whether the order ID in the request is valid for your app.
///
///[OrderLookupStatus](https://developer.apple.com/documentation/appstoreserverapi/orderlookupstatus)
public enum OrderLookupStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The orderId that you provided in the Look Up Order ID request is valid and contains at least one in-app purchase for your app.
    case valid = 0

    ///The orderId is invalid or doesn’t contain any in-app purchases for your app.
    case invalid = 1
}
