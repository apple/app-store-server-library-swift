// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The payment mode for a discount offer on an In-App Purchase.
///
///[offerDiscountType](https://developer.apple.com/documentation/appstoreserverapi/offerdiscounttype)
public enum OfferDiscountType: String, Decodable, Encodable, Hashable, Sendable {
    case freeTrial = "FREE_TRIAL"
    case payAsYouGo = "PAY_AS_YOU_GO"
    case payUpFront = "PAY_UP_FRONT"
    case oneTime = "ONE_TIME"
}
