// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The period of the offer.
///
///[Offer](https://developer.apple.com/documentation/advancedcommerceapi/offer)
public enum AdvancedCommerceOfferPeriod: String, Decodable, Encodable, Hashable, Sendable {
    case p3D = "P3D"
    case p1W = "P1W"
    case p2W = "P2W"
    case p1M = "P1M"
    case p2M = "P2M"
    case p3M = "P3M"
    case p6M = "P6M"
    case p9M = "P9M"
    case p1Y = "P1Y"
}
