// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The App Store server notification history record, including the signed notification payload and the result of the server’s first send attempt.
///
///[notificationHistoryResponseItem](https://developer.apple.com/documentation/appstoreserverapi/notificationhistoryresponseitem)
public struct NotificationHistoryResponseItem: Decodable, Encodable, Hashable, Sendable {

    public init(sendAttempts: [SendAttemptItem]? = nil, signedPayload: String? = nil) {
        self.sendAttempts = sendAttempts
        self.signedPayload = signedPayload
    }

    ///An array of information the App Store server records for its attempts to send a notification to your server.
    ///
    ///[sendAttemptItem](https://developer.apple.com/documentation/appstoreserverapi/sendattemptitem)
    public var sendAttempts: [SendAttemptItem]?

    ///The cryptographically signed payload, in JSON Web Signature (JWS) format, containing the original response body of a version 2 notification.
    ///
    ///[signedPayload](https://developer.apple.com/documentation/appstoreserverapi/signedpayload)
    public var signedPayload: String?
}
