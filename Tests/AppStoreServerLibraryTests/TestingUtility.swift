// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
@testable import AppStoreServerLibrary

import JWTKit
import Crypto
import XCTest

public class TestingUtility {

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
    
    public static func confirmCodableInternallyConsistent<T>(_ codable: T) where T : Codable, T : Equatable {
        let type = type(of: codable)
        let parsedValue = try! getJsonDecoder().decode(type, from: getJsonEncoder().encode(codable))
        XCTAssertEqual(parsedValue, codable)
    }
    
    public static func createSignedDataFromJson(_ path: String) -> String {
        let payload = readFile(path)
        let signingKey = Crypto.P256.Signing.PrivateKey()
        
        let header = JWTHeader(alg: "ES256")

        let encoder = JSONEncoder()
        let headerData = try! encoder.encode(header)
        let encodedHeader = base64ToBase64URL(headerData.base64EncodedString())

        let encodedPayload = base64ToBase64URL(payload.data(using: .utf8)!.base64EncodedString())
        
        var signingInput = "\(encodedHeader).\(encodedPayload)"
        let signature = try! signingInput.withUTF8 { try signingKey.signature(for: $0) }

        return "\(signingInput).\(base64ToBase64URL(signature.rawRepresentation.base64EncodedString()))";
    }
    
    private static func base64ToBase64URL(_ encodedString: String) -> String {
        return encodedString
            .replacingOccurrences(of: "+", with: "/")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
