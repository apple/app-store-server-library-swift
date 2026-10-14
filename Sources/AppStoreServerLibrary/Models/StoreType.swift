// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A string that describes the store the customer obtained the app from.
///
///[storeType](https://developer.apple.com/documentation/appstoreserverapi/storetype)
public enum StoreType: String, Decodable, Encodable, Hashable, Sendable {
    ///The customer obtained the app from the App Store.
    case consumer = "CONSUMER"
}
