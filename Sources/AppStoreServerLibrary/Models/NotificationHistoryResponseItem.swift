// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The App Store server notification history record, including the signed notification payload and the result of the server’s first send attempt.
///
///[notificationHistoryResponseItem](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryresponseitem)
public struct NotificationHistoryResponseItem: Decodable, Encodable, Hashable {

    public init(signedPayload: String? = nil, sendAttempts: [SendAttemptItem]? = nil) {
        self.signedPayload = signedPayload
        self.sendAttempts = sendAttempts
    }

    ///A cryptographically signed payload, in JSON Web Signature (JWS) format, containing the response body for a version 2 notification.
    ///
    ///[signedPayload](https://developer.apple.com/documentation/appstoreservernotifications/signedpayload)
    public var signedPayload: String?

    ///An array of information the App Store server records for its attempts to send a notification to your server. The maximum number of entries in the array is six.
    ///
    ///[sendAttemptItem](https://developer.apple.com/documentation/appstoreserverapi/sendattemptitem)
    public var sendAttempts: [SendAttemptItem]?
}
