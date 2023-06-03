// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates whether the order ID in the request is valid for your app.
///
///[OrderLookupStatus](https://developer.apple.com/documentation/appstoreserverapi/orderlookupstatus)
public enum OrderLookupStatus: Int32, Decodable, Encodable, Hashable {
    case valid = 0
    case invalid = 1
}
