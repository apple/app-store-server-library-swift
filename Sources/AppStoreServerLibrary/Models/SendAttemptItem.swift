// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
///The success or error information and the date the App Store server records when it attempts to send a server notification to your server.
///
///[sendAttemptItem](https://developer.apple.com/documentation/appstoreserverapi/sendattemptitem)
public struct SendAttemptItem: Decodable, Encodable, Hashable {
    ///The date the App Store server attempts to send a notification.
    ///
    ///[attemptDate](https://developer.apple.com/documentation/appstoreservernotifications/attemptdate)
    public var attemptDate: Date?
    
    ///The success or error information the App Store server records when it attempts to send an App Store server notification to your server.
    ///
    ///[sendAttemptResult](https://developer.apple.com/documentation/appstoreserverapi/sendattemptresult)
    public var sendAttemptResult: SendAttemptResult?
}
