// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

@testable import AppStoreServerLibrary
import Foundation

import JWTKit

public enum TestingUtility {
    public static func readFile(_ path: String) -> String {
        let absolutePath = Bundle.module.url(forResource: path, withExtension: "")!
        return try! String(contentsOf: absolutePath, encoding: .utf8)
    }

    public static func readBytes(_ path: String) -> Foundation.Data {
        let absolutePath = Bundle.module.url(forResource: path, withExtension: "")!
        return try! Data(contentsOf: absolutePath)
    }

    public static func getSignedDataVerifier(_ environment: Environment, _ bundleId: String, _ appAppleId: Int64) -> SignedDataVerifier {
        return try! SignedDataVerifier(rootCertificates: [readBytes("resources/certs/testCA.der")], bundleId: bundleId, appAppleId: appAppleId, environment: environment, enableOnlineChecks: false)
    }

    public static func getSignedDataVerifier(_ environment: Environment, _ bundleId: String) -> SignedDataVerifier {
        return getSignedDataVerifier(environment, bundleId, 1234)
    }

    public static func getSignedDataVerifier() -> SignedDataVerifier {
        return getSignedDataVerifier(.localTesting, "com.example")
    }

    public static func createSignedDataFromJson<Payload: JWTPayload>(_ path: String, as: Payload.Type) async throws -> String {
        let payloadString = readFile(path)
        let serializer = DefaultJWTSerializer(jsonEncoder: getJsonEncoder())
        let key = await JWTKeyCollection().addES256(key: ES256PrivateKey(), serializer: serializer)

        let payload = try getJsonDecoder().decode(Payload.self, from: .init(payloadString.utf8))

        return try await key.sign(payload)
    }

    private static func base64ToBase64URL(_ encodedString: String) -> String {
        return encodedString
            .replacingOccurrences(of: "+", with: "/")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
