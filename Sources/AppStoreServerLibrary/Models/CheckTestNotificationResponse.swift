// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that contains the contents of the test notification sent by the App Store server and the result from your server.
///
///[CheckTestNotificationResponse](https://developer.apple.com/documentation/appstoreserverapi/checktestnotificationresponse)
public struct CheckTestNotificationResponse: Decodable, Encodable, Hashable {

    public init(signedPayload: String? = nil, sendAttempts: [SendAttemptItem]? = nil) {
        self.signedPayload = signedPayload
        self.sendAttempts = sendAttempts
    }

    ///A cryptographically signed payload, in JSON Web Signature (JWS) format, containing the response body for a version 2 notification.
    ///
    ///[signedPayload](https://developer.apple.com/documentation/appstoreservernotifications/signedpayload)
    public var signedPayload: String?

    ///An array of information the App Store server records for its attempts to send the TEST notification to your server. The array may contain a maximum of six sendAttemptItem objects.
    ///
    ///[sendAttemptItem](https://developer.apple.com/documentation/appstoreserverapi/sendattemptitem)
    public var sendAttempts: [SendAttemptItem]?
}
