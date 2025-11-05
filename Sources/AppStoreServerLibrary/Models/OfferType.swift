// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The type of offer.
///
///[offerType](https://developer.apple.com/documentation/appstoreserverapi/offertype)
public enum OfferType: Int32, Decodable, Encodable, Hashable, Sendable {
    case introductoryOffer = 1
    case promotionalOffer = 2
    case offerCode = 3
    case winBackOffer = 4
}
