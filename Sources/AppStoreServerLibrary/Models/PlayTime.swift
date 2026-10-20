// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A value that indicates the amount of time that the customer used the app.
///
///[playTime](https://developer.apple.com/documentation/appstoreserverapi/playtime)
public enum PlayTime: Int32, Decodable, Encodable, Hashable, Sendable {
    ///The engagement time is undeclared.
    case undeclared = 0

    ///The engagement time is between 0–5 minutes.
    case zeroToFiveMinutes = 1

    ///The engagement time is between 5–60 minutes.
    case fiveToSixtyMinutes = 2

    ///The engagement time is between 1–6 hours.
    case oneToSixHours = 3

    ///The engagement time is between 6–24 hours.
    case sixHoursToTwentyFourHours = 4

    ///The engagement time is between 1–4 days.
    case oneDayToFourDays = 5

    ///The engagement time is between 4–16 days.
    case fourDaysToSixteenDays = 6

    ///The engagement time is over 16 days.
    case overSixteenDays = 7
}
