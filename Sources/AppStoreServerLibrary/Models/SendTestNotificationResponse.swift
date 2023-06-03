// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains the test notification token.
///
///[SendTestNotificationResponse](https://developer.apple.com/documentation/appstoreserverapi/sendtestnotificationresponse)
public struct SendTestNotificationResponse: Decodable, Encodable, Hashable {
    ///A unique identifier for a notification test that the App Store server sends to your server.
    ///
    ///[testNotificationToken](https://developer.apple.com/documentation/appstoreserverapi/testnotificationtoken)
    public var testNotificationToken: String?
}
