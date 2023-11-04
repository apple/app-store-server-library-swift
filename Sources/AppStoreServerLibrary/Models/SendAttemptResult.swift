// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The success or error information the App Store server records when it attempts to send an App Store server notification to your server.
///
///[sendAttemptResult](https://developer.apple.com/documentation/appstoreserverapi/sendattemptresult)
public enum SendAttemptResult: String, Decodable, Encodable, Hashable {
    case success = "SUCCESS"
    case timedOut = "TIMED_OUT"
    case tlsIssue = "TLS_ISSUE"
    case circularRedirect = "CIRCULAR_REDIRECT"
    case noResponse = "NO_RESPONSE"
    case socketIssue = "SOCKET_ISSUE"
    case unsuportedCharset = "UNSUPPORTED_CHARSET"
    case invalidResponse = "INVALID_RESPONSE"
    case prematureClose = "PREMATURE_CLOSE"
    case unsuccessfulHttpResponseCode = "UNSUCCESSFUL_HTTP_RESPONSE_CODE"
    case other = "OTHER"
}
