// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the amount of time that the customer used the app.
///
///[playTime](https://developer.apple.com/documentation/appstoreserverapi/playtime)
public enum PlayTime: Int32, Decodable, Encodable, Hashable, Sendable {
    case undeclared = 0
    case zeroToFiveMinutes = 1
    case fiveToSixtyMinutes = 2
    case oneToSixHours = 3
    case sixHoursToTwentyFourHours = 4
    case oneDayToFourDays = 5
    case fourDaysToSixteenDays = 6
    case overSixteenDays = 7
}
