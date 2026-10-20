// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import X509
import Crypto

final class PromotionalOfferSignatureCreatorTests: XCTestCase {

    public func testSignatureCreator() throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try PromotionalOfferSignatureCreator(privateKey: key, keyId: "keyId", bundleId: "bundleId")
        let signature = try signatureCreator.createSignature(productIdentifier: "productId", subscriptionOfferID: "offerId", appAccountToken: "appAccountToken", nonce: UUID(uuidString: "20fba8a0-2b80-4a7d-a17f-85c1854727f8")!, timestamp: 1698148900000)
        XCTAssertNotNil(signature)
        
        let expectedPayload = "bundleId\u{2063}keyId\u{2063}productId\u{2063}offerId\u{2063}appaccounttoken\u{2063}20fba8a0-2b80-4a7d-a17f-85c1854727f8\u{2063}1698148900000"
        let publicKey = try P256.Signing.PrivateKey(pemRepresentation: key).publicKey
        let decodedSignature = try P256.Signing.ECDSASignature(derRepresentation: Data(base64Encoded: signature)!)
        XCTAssertTrue(publicKey.isValidSignature(decodedSignature, for: Data(expectedPayload.utf8)))
    }
    
    public func testSignatureCreatorUsesLowercaseNonceAndAppAccountToken() throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try PromotionalOfferSignatureCreator(privateKey: key, keyId: "keyId", bundleId: "bundleId")
        let signature = try signatureCreator.createSignature(productIdentifier: "productId", subscriptionOfferID: "offerId", appAccountToken: "7E3FB20B-4CDB-47CC-936D-99D65F608138", nonce: UUID(uuidString: "20FBA8A0-2B80-4A7D-A17F-85C1854727F8")!, timestamp: 1698148900000)
        
        let expectedPayload = "bundleId\u{2063}keyId\u{2063}productId\u{2063}offerId\u{2063}7e3fb20b-4cdb-47cc-936d-99d65f608138\u{2063}20fba8a0-2b80-4a7d-a17f-85c1854727f8\u{2063}1698148900000"
        let publicKey = try P256.Signing.PrivateKey(pemRepresentation: key).publicKey
        let decodedSignature = try P256.Signing.ECDSASignature(derRepresentation: Data(base64Encoded: signature)!)
        XCTAssertTrue(publicKey.isValidSignature(decodedSignature, for: Data(expectedPayload.utf8)))
    }

    public func testSignatureCreatorWithDateTimestampSignsTheSamePayloadAsInt64() throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")

        let signatureCreator = try PromotionalOfferSignatureCreator(privateKey: key, keyId: "keyId", bundleId: "bundleId")
        let nonce = UUID(uuidString: "20fba8a0-2b80-4a7d-a17f-85c1854727f8")!
        let dateSignature = try signatureCreator.createSignature(productIdentifier: "productId", subscriptionOfferID: "offerId", appAccountToken: "appAccountToken", nonce: nonce, timestamp: Date(timeIntervalSince1970: 1698148900.123))
        let int64Signature = try signatureCreator.createSignature(productIdentifier: "productId", subscriptionOfferID: "offerId", appAccountToken: "appAccountToken", nonce: nonce, timestamp: Int64(1698148900123))

        let expectedPayload = "bundleId\u{2063}keyId\u{2063}productId\u{2063}offerId\u{2063}appaccounttoken\u{2063}20fba8a0-2b80-4a7d-a17f-85c1854727f8\u{2063}1698148900123"
        let publicKey = try P256.Signing.PrivateKey(pemRepresentation: key).publicKey
        for signature in [dateSignature, int64Signature] {
            let decodedSignature = try P256.Signing.ECDSASignature(derRepresentation: Data(base64Encoded: signature)!)
            XCTAssertTrue(publicKey.isValidSignature(decodedSignature, for: Data(expectedPayload.utf8)))
        }
    }
}
