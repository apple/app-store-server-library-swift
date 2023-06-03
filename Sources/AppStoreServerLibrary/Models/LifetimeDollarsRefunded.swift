// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the dollar amount of refunds the customer has received in your app, since purchasing the app, across all platforms.
///
///[lifetimeDollarsRefunded](https://developer.apple.com/documentation/appstoreserverapi/lifetimedollarsrefunded)
public enum LifetimeDollarsRefunded: Int32, Decodable, Encodable, Hashable {
    case undeclared = 0
    case zeroDollars = 1
    case oneCentToFortyNineDollarsAndNinetyNineCents = 2
    case fiftyDollarsToNinetyNineDollarsAndNinetyNineCents = 3
    case oneHundredDollarsToFourHundredNinetyNineDollarsAndNinetyNineCents = 4
    case fiveHundredDollarsToNineHundredNinetyNineDollarsAndNinetyNineCents = 5
    case oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents = 6
    case twoThousandDollarsOrGreater = 7
}
