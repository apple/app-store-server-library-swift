// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates whether the app successfully delivered an In-App Purchase that works properly.
///
///[deliveryStatusV1](https://developer.apple.com/documentation/appstoreserverapi/deliverystatusv1)
@available(*, deprecated, message: "Use DeliveryStatus instead")
public enum DeliveryStatusV1: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The app delivered the consumable In-App Purchase and it’s working properly.
    case deliveredAndWorkingProperly = 0

    ///The app didn’t deliver the consumable In-App Purchase due to a quality issue.
    case didNotDeliverDueToQualityIssue = 1

    ///The app delivered the wrong item.
    case deliveredWrongItem = 2

    ///The app didn’t deliver the consumable In-App Purchase due to a server outage.
    case didNotDeliverDueToServerOutage = 3

    ///The app didn’t deliver the consumable In-App Purchase due to an in-game currency change.
    case didNotDeliverDueToInGameCurrencyChange = 4

    ///The app didn’t deliver the consumable In-App Purchase for other reasons.
    case didNotDeliverForOtherReason = 5
}
