// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the total amount, in USD, of in-app purchases the customer has made in your app, across all platforms.
///
///[lifetimeDollarsPurchased](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarspurchased)
public enum LifetimeDollarsPurchased: Int32, Decodable, Encodable, Hashable {
    case undeclared = 0
    case zeroDollars = 1
    case oneCentToFortyNineDollarsAndNinetyNineCents = 2
    case fiftyDollarsToNinetyNineDollarsAndNinetyNineCents = 3
    case oneHundredDollarsToFourHundredNinetyNineDollarsAndNinetyNineCents = 4
    case fiveHundredDollarsToNineHundredNinetyNineDollarsAndNinetyNineCents = 5
    case oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents = 6
    case twoThousandDollarsOrGreater = 7
}
