// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The success or error information the App Store server records when it attempts to send an App Store server notification to your server.
///
///[sendAttemptResult](https://developer.apple.com/documentation/appstoreserverapi/sendattemptresult)
public enum SendAttemptResult: String, Decodable, Encodable, Hashable, Sendable {
    ///The App Store server received a success response when it sent the notification to your server.
    case success = "SUCCESS"

    ///The App Store server didn’t get a response from your server and timed out.
    case timedOut = "TIMED_OUT"

    ///The App Store server couldn’t establish a TLS session or validate your certificate.
    case tlsIssue = "TLS_ISSUE"

    ///The App Store server detected a continual redirect.
    case circularRedirect = "CIRCULAR_REDIRECT"

    ///The App Store server didn’t receive a valid HTTP response from your server.
    case noResponse = "NO_RESPONSE"

    ///A network error caused the notification attempt to fail.
    case socketIssue = "SOCKET_ISSUE"

    ///The App Store server doesn’t support the supplied charset.
    case unsupportedCharset = "UNSUPPORTED_CHARSET"

    ///The App Store server received an invalid response from your server.
    case invalidResponse = "INVALID_RESPONSE"

    ///The App Store server’s connection to your server was closed while the send was in progress.
    case prematureClose = "PREMATURE_CLOSE"

    ///The App Store server didn’t receive an HTTP 200 response from your server.
    case unsuccessfulHttpResponseCode = "UNSUCCESSFUL_HTTP_RESPONSE_CODE"

    ///Another error occurred that prevented your server from receiving the notification.
    case other = "OTHER"
}
