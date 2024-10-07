// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the extent to which the customer consumed the in-app purchase.
///
///[consumptionStatus](https://developer.apple.com/documentation/appstoreserverapi/consumptionstatus)
public enum ConsumptionStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    case undeclared = 0
    case notConsumed = 1
    case partiallyConsumed = 2
    case fullyConsumed = 3
}
