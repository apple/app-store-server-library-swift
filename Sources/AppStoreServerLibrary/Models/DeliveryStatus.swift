// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates whether the app successfully delivered an in-app purchase that works properly.
///
///[deliveryStatus](https://developer.apple.com/documentation/appstoreserverapi/deliverystatus)
public enum DeliveryStatus: Int32, Decodable, Encodable, Hashable {
    case deliveredAndWorkingProperly = 0
    case didNotDeliverDueToQualityIssue = 1
    case deliveredWrongItem = 2
    case didNotDeliverDueToServerOutage = 3
    case didNotDeliverDueToIngameCurrencyChange = 4
    case didNotDeliverForOtherReason = 5
}
