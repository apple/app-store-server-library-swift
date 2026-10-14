// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains the contents of the App Store server’s test notification and the result from your server.
///
///[CheckTestNotificationResponse](https://developer.apple.com/documentation/appstoreserverapi/checktestnotificationresponse)
public struct CheckTestNotificationResponse: Decodable, Encodable, Hashable, Sendable {

    public init(sendAttempts: [SendAttemptItem]? = nil, signedPayload: String? = nil) {
        self.sendAttempts = sendAttempts
        self.signedPayload = signedPayload
    }

    ///An array of information the App Store server records for its attempts to send the TEST notification to your server.
    ///
    ///[sendAttemptItem](https://developer.apple.com/documentation/appstoreserverapi/sendattemptitem)
    public var sendAttempts: [SendAttemptItem]?

    ///The signed payload, in JWS format, that contains the TEST notification that the App Store server sent to your server.
    ///
    ///[signedPayload](https://developer.apple.com/documentation/appstoreserverapi/signedpayload)
    public var signedPayload: String?
}
