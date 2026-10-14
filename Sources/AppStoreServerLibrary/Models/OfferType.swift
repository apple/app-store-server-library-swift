// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The type of offer.
///
///[offerType](https://developer.apple.com/documentation/appstoreserverapi/offertype)
public enum OfferType: Int32, Decodable, Encodable, Hashable, Sendable {
    ///An introductory offer.
    case introductoryOffer = 1

    ///A promotional offer.
    case promotionalOffer = 2

    ///An offer with an offer code.
    case offerCode = 3

    ///A win-back offer.
    case winBackOffer = 4
}
