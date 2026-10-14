// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The reason an auto-renewable subscription expired.
///
///[expirationIntent](https://developer.apple.com/documentation/appstoreserverapi/expirationintent)
public enum ExpirationIntent: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The customer canceled their subscription.
    case customerCancelled = 1

    ///Billing error; for example, the customer’s payment information is no longer valid.
    case billingError = 2

    ///The customer didn’t consent to an auto-renewable subscription price increase that requires their consent, or to a subscription offer conversion that requires their consent, so the subscription expired.
    case customerDidNotConsentToPriceIncrease = 3

    ///The product wasn’t available for purchase at the time of renewal.
    case productNotAvailable = 4

    ///The subscription expired for some other reason.
    case other = 5
}
