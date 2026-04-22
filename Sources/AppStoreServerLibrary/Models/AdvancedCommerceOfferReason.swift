// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The reason for the offer.
///
///[Offer](https://developer.apple.com/documentation/advancedcommerceapi/offer)
public enum AdvancedCommerceOfferReason: String, Decodable, Encodable, Hashable, Sendable {
    case acquisition = "ACQUISITION"
    case winBack = "WIN_BACK"
    case retention = "RETENTION"
}
