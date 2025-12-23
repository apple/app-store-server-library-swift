// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates whether the app successfully delivered an in-app purchase that works properly.
///
///[DeliveryStatusV1](https://developer.apple.com/documentation/appstoreserverapi/deliverystatusv1)
@available(*, deprecated, renamed: "DeliveryStatus")
public enum DeliveryStatusV1: Int32, Decodable, Encodable, Hashable, Sendable {
    case deliveredAndWorkingProperly = 0
    case didNotDeliverDueToQualityIssue = 1
    case deliveredWrongItem = 2
    case didNotDeliverDueToServerOutage = 3
    case didNotDeliverDueToIngameCurrencyChange = 4
    case didNotDeliverForOtherReason = 5
}
