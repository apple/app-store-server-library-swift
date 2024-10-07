// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The reason an auto-renewable subscription expired.
///
///[expirationIntent](https://developer.apple.com/documentation/appstoreserverapi/expirationintent)
public enum ExpirationIntent: Int32, Decodable, Encodable, Hashable, Sendable {
    case customerCancelled = 1
    case billingError = 2
    case customerDidNotConsentToPriceIncrease = 3
    case productNotAvailable = 4
    case other = 5
}
