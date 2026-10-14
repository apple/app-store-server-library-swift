// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The duration of a single cycle of an auto-renewable subscription.
///
///[period](https://developer.apple.com/documentation/advancedcommerceapi/period)
public enum AdvancedCommercePeriod: String, Decodable, Encodable, Hashable, Sendable {
    ///A period that is 1 week in duration.
    case p1W = "P1W"

    ///A period that is 1 month in duration.
    case p1M = "P1M"

    ///A period that is 2 months in duration.
    case p2M = "P2M"

    ///A period that is 3 months in duration.
    case p3M = "P3M"

    ///A period that is 6 months in duration.
    case p6M = "P6M"

    ///A period that is 1 year in duration.
    case p1Y = "P1Y"
}
