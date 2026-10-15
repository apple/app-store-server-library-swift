// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The server environment, either sandbox or production.
///
///[environment](https://developer.apple.com/documentation/appstoreserverapi/environment)
public enum AppStoreEnvironment: String, Decodable, Encodable, Hashable, Sendable {
    ///Indicates that the data applies to testing in the sandbox environment.
    case sandbox = "Sandbox"

    ///Indicates that the data applies to the production environment.
    case production = "Production"

    case xcode = "Xcode"

    case localTesting = "LocalTesting"
}
