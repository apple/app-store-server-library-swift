// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
@testable import AppStoreServerLibrary

import JWTKit
import Crypto

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
    
    public static func createSignedDataFromJson(_ path: String) -> String {
        let payload = readFile(path)
        let signingKey = Crypto.P256.Signing.PrivateKey()
        let signer: JWTSigner = try! .es256(key: .private(pem: signingKey.pemRepresentation))
        
        let header = JWTHeader(alg: "ES256")

        let encoder = JSONEncoder()
        let headerData = try! encoder.encode(header)
        let encodedHeader = headerData.base64EncodedString()

        let encodedPayload = payload.data(using: .utf8)!.base64EncodedString()

        let signature = try! signer.algorithm.sign("\(encodedHeader).\(encodedPayload)".data(using: .utf8)!)

        return "\(base64ToBase64URL(encodedHeader)).\(base64ToBase64URL(encodedPayload)).\(base64ToBase64URL(Data(signature).base64EncodedString()))";
    }
    
    private static func base64ToBase64URL(_ encodedString: String) -> String {
        return encodedString
            .replacingOccurrences(of: "+", with: "/")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
