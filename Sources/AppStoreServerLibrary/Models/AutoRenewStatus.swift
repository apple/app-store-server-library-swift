// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The renewal status for an auto-renewable subscription.
///
///[autoRenewStatus](https://developer.apple.com/documentation/appstoreserverapi/autorenewstatus)
public enum AutoRenewStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    case off = 0
    case on = 1
}
