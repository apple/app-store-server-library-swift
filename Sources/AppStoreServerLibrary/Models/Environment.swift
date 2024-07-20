// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The server environment, either sandbox or production.
///
///[environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
public enum Environment: String, Decodable, Encodable, Hashable, Sendable {
    case sandbox = "Sandbox"
    case production = "Production"
    case xcode = "Xcode"
    case localTesting = "LocalTesting" // Used for unit testing
}
