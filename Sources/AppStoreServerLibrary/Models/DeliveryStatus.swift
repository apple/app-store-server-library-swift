// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

///A value that indicates whether the app successfully delivered an In-App Purchase that works properly.
///
///[deliveryStatus](https://developer.apple.com/documentation/appstoreserverapi/deliverystatus)
public enum DeliveryStatus: String, Decodable, Encodable, Hashable, Sendable {
    case delivered = "DELIVERED"
    case undeliveredQualityIssue = "UNDELIVERED_QUALITY_ISSUE"
    case undeliveredWrongItem = "UNDELIVERED_WRONG_ITEM"
    case undeliveredServerOutage = "UNDELIVERED_SERVER_OUTAGE"
    case undeliveredOther = "UNDELIVERED_OTHER"
}
