// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the dollar amount of in-app purchases the customer has made in your app, since purchasing the app, across all platforms.
///
///[lifetimeDollarsPurchased](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarspurchased)
public enum LifetimeDollarsPurchased: Int32, Decodable, Encodable, Hashable, Sendable {
    ///Lifetime purchase amount is undeclared.
    case undeclared = 0

    ///Lifetime purchase amount is 0 USD.
    case zeroDollars = 1

    ///Lifetime purchase amount is between 0.01–49.99 USD.
    case oneCentToFortyNineDollarsAndNinetyNineCents = 2

    ///Lifetime purchase amount is between 50–99.99 USD.
    case fiftyDollarsToNinetyNineDollarsAndNinetyNineCents = 3

    ///Lifetime purchase amount is between 100–499.99 USD.
    case oneHundredDollarsToFourHundredNinetyNineDollarsAndNinetyNineCents = 4

    ///Lifetime purchase amount is between 500–999.99 USD.
    case fiveHundredDollarsToNineHundredNinetyNineDollarsAndNinetyNineCents = 5

    ///Lifetime purchase amount is between 1000–1999.99 USD.
    case oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents = 6

    ///Lifetime purchase amount is over 2000 USD.
    case twoThousandDollarsOrGreater = 7
}
