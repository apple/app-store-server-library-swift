// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///The request object you provide for a performance test that contains an original transaction identifier.
///
///[PerformanceTestRequest](https://developer.apple.com/documentation/retentionmessaging/performancetestrequest)
public struct PerformanceTestRequest: Decodable, Encodable, Hashable, Sendable {

    public init(originalTransactionId: String) {
        self.originalTransactionId = originalTransactionId
    }

    ///The original transaction identifier of an In-App Purchase you initiate in the sandbox environment, to use as the purchase for this test.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String
}
