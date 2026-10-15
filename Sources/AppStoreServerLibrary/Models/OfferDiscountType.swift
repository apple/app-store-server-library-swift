// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The payment mode for a discount offer on an In-App Purchase.
///
///[offerDiscountType](https://developer.apple.com/documentation/appstoreserverapi/offerdiscounttype)
public enum OfferDiscountType: String, Decodable, Encodable, Hashable, Sendable {
    ///A payment mode of a discount for auto-renewable subscriptions that indicates a free trial.
    case freeTrial = "FREE_TRIAL"

    ///A payment mode of a discount for auto-renewable subscriptions that customers pay over a single or multiple billing periods.
    case payAsYouGo = "PAY_AS_YOU_GO"

    ///A payment mode of a discount for auto-renewable subscriptions that customers pay up front.
    case payUpFront = "PAY_UP_FRONT"

    ///A payment mode for a discount for In-App Purchase types including consumable, non-consumable, and non-renewing subscription.
    case oneTime = "ONE_TIME"
}
