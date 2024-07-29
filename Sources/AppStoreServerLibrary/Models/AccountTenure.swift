// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The age of the customer’s account.
///
///[accountTenure](https://developer.apple.com/documentation/appstoreserverapi/accounttenure)
public enum AccountTenure: Int32, Decodable, Encodable, Hashable, Sendable {
    case undeclared = 0
    case zeroToThreeDays = 1
    case threeDaysToTenDays = 2
    case tenDaysToThirtyDays = 3
    case thirtyDaysToNinetyDays = 4
    case ninetyDaysToOneHundredEightyDays = 5
    case oneHundredEightyDaysToThreeHundredSixtyFiveDays = 6
    case greaterThanThreeHundredSixtyFiveDays = 7
}
