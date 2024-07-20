// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The payment mode you configure for an introductory offer, promotional offer, or offer code on an auto-renewable subscription.
///
///[offerDiscountType](https://developer.apple.com/documentation/appstoreserverapi/offerdiscounttype)
public enum OfferDiscountType: String, Decodable, Encodable, Hashable, Sendable {
    case freeTrial = "FREE_TRIAL"
    case payAsYouGo = "PAY_AS_YOU_GO"
    case payUpFront = "PAY_UP_FRONT"
}
