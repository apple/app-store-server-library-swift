// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The status that indicates whether an auto-renewable subscription is subject to a price increase.
///
///[priceIncreaseStatus](https://developer.apple.com/documentation/appstoreserverapi/priceincreasestatus)
public enum PriceIncreaseStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The customer hasn’t yet responded to an auto-renewable subscription price increase that requires customer consent.
    case customerHasNotResponded = 0

    ///The customer consented to an auto-renewable subscription price increase that requires customer consent, or the App Store has notified the customer of an auto-renewable subscription price increase that doesn’t require consent.
    case customerConsentedOrWasNotifiedWithoutNeedingConsent = 1
}
