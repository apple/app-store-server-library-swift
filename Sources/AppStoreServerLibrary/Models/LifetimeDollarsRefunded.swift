// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the dollar amount of refunds the customer has received in your app, since purchasing the app, across all platforms.
///
///[lifetimeDollarsRefunded](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarsrefunded)
public enum LifetimeDollarsRefunded: Int32, Decodable, Encodable, Hashable, Sendable {
    ///Lifetime refund amount is undeclared.
    case undeclared = 0

    ///Lifetime refund amount is 0 USD.
    case zeroDollars = 1

    ///Lifetime refund amount is between 0.01–49.99 USD.
    case oneCentToFortyNineDollarsAndNinetyNineCents = 2

    ///Lifetime refund amount is between 50–99.99 USD.
    case fiftyDollarsToNinetyNineDollarsAndNinetyNineCents = 3

    ///Lifetime refund amount is between 100–499.99 USD.
    case oneHundredDollarsToFourHundredNinetyNineDollarsAndNinetyNineCents = 4

    ///Lifetime refund amount is between 500–999.99 USD.
    case fiveHundredDollarsToNineHundredNinetyNineDollarsAndNinetyNineCents = 5

    ///Lifetime refund amount is between 1000–1999.99 USD.
    case oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents = 6

    ///Lifetime refund amount is over 2000 USD.
    case twoThousandDollarsOrGreater = 7
}
