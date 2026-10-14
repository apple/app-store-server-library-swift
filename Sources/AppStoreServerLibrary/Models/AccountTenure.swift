// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The age of the customer’s account.
///
///[accountTenure](https://developer.apple.com/documentation/appstoreserverapi/accounttenure)
public enum AccountTenure: Int32, Decodable, Encodable, Hashable, Sendable {
    ///Account age is undeclared.
    case undeclared = 0

    ///Account age is between 0–3 days.
    case zeroToThreeDays = 1

    ///Account age is between 3–10 days.
    case threeDaysToTenDays = 2

    ///Account age is between 10–30 days.
    case tenDaysToThirtyDays = 3

    ///Account age is between 30–90 days.
    case thirtyDaysToNinetyDays = 4

    ///Account age is between 90–180 days.
    case ninetyDaysToOneHundredEightyDays = 5

    ///Account age is between 180–365 days.
    case oneHundredEightyDaysToThreeHundredSixtyFiveDays = 6

    ///Account age is over 365 days.
    case greaterThanThreeHundredSixtyFiveDays = 7
}
