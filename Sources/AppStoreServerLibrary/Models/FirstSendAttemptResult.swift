// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///An error or result that the App Store server receives when attempting to send an App Store server notification to your server.
///
///[firstSendAttemptResult](https://developer.apple.com/documentation/appstoreserverapi/firstsendattemptresult)
public enum FirstSendAttemptResult: String, Decodable, Encodable, Hashable {
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
