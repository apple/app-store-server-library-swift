// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The duration of a single cycle of an auto-renewable subscription.
///
///[period](https://developer.apple.com/documentation/advancedcommerceapi/period)
public enum AdvancedCommercePeriod: String, Decodable, Encodable, Hashable, Sendable {
    case p1W = "P1W"
    case p1M = "P1M"
    case p2M = "P2M"
    case p3M = "P3M"
    case p6M = "P6M"
    case p1Y = "P1Y"
}
