// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The renewal status for an auto-renewable subscription.
///
///[autoRenewStatus](https://developer.apple.com/documentation/appstoreserverapi/autorenewstatus)
public enum AutoRenewStatus: Int32, Decodable, Encodable, Hashable, Sendable {
    ///Automatic renewal is off.
    case off = 0

    ///Automatic renewal is on.
    case on = 1
}
