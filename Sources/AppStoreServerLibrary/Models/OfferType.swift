// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The type of subscription offer.
///
///[offerType](https://developer.apple.com/documentation/appstoreserverapi/offertype)
public enum OfferType: Int32, Decodable, Encodable, Hashable {
    case introductoryOffer = 1
    case promotionalOffer = 2
    case subscriptionOfferCode = 3
    case winBackOffer = 4
}
