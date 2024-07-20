// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The status that indicates whether an auto-renewable subscription is subject to a price increase.
///
///[priceIncreaseStatus](https://developer.apple.com/documentation/appstoreserverapi/priceincreasestatus)
public enum PriceIncreaseStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    case customerHasNotResponded = 0
    case customerConsentedOrWasNotifiedWithoutNeedingConsent = 1
}
