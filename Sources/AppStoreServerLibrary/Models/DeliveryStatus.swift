// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///A value that indicates whether the app successfully delivered an In-App Purchase that works properly.
///
///[deliveryStatus](https://developer.apple.com/documentation/appstoreserverapi/deliverystatus)
public enum DeliveryStatus: String, Decodable, Encodable, Hashable, Sendable {
    ///The app delivered the In-App Purchase and it’s working properly.
    case delivered = "DELIVERED"

    ///The app didn’t deliver the In-App Purchase due to a quality issue.
    case undeliveredQualityIssue = "UNDELIVERED_QUALITY_ISSUE"

    ///The app delivered the wrong item.
    case undeliveredWrongItem = "UNDELIVERED_WRONG_ITEM"

    ///The app didn’t deliver the In-App Purchase due to a server outage.
    case undeliveredServerOutage = "UNDELIVERED_SERVER_OUTAGE"

    ///The app didn’t deliver the In-App Purchase for other reasons.
    case undeliveredOther = "UNDELIVERED_OTHER"
}
