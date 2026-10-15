// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the extent to which the customer consumed the In-App Purchase.
///
///[consumptionStatus](https://developer.apple.com/documentation/appstoreserverapi/consumptionstatus)
public enum ConsumptionStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The consumption status is undeclared.
    case undeclared = 0

    ///The In-App Purchase is not consumed.
    case notConsumed = 1

    ///The In-App Purchase is partially consumed.
    case partiallyConsumed = 2

    ///The In-App Purchase is fully consumed.
    case fullyConsumed = 3
}
