// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import X509

final class JWSSignatureCreatorTests: XCTestCase {

    public func testPromotionalOfferV2SignatureCreator() async throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try PromotionalOfferV2SignatureCreator(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "bundleId")
        let signature = try await signatureCreator.createSignature(productId: "productId", offerIdentifier: "offerIdentifier", transactionId: "transactionId")
        let tokenComponents = signature.components(separatedBy: ".")
        guard let headerData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[0])),
              let payloadData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[1])) else {
            XCTAssertTrue(false)
            return
        }
        let header = try JSONSerialization.jsonObject(with: headerData) as! [String: Any]
        let payload = try JSONSerialization.jsonObject(with: payloadData) as! [String: Any]
        
        // Header
        XCTAssertEqual("JWT", header["typ"] as! String)
        XCTAssertEqual("ES256", header["alg"] as! String)
        XCTAssertEqual("keyId", header["kid"] as! String)
        // Payload
        XCTAssertEqual("issuerId", payload["iss"] as! String)
        XCTAssertNotNil(payload["iat"])
        XCTAssertNil(payload["exp"])
        XCTAssertEqual("promotional-offer", payload["aud"] as! String)
        XCTAssertEqual("bundleId", payload["bid"] as! String)
        XCTAssertNotNil(payload["nonce"])
        XCTAssertEqual("productId", payload["productId"] as! String)
        XCTAssertEqual("offerIdentifier", payload["offerIdentifier"] as! String)
        XCTAssertEqual("transactionId", payload["transactionId"] as! String)
    }
    
    public func testPromotionalOfferV2SignatureCreatorWithoutTransactionId() async throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try PromotionalOfferV2SignatureCreator(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "bundleId")
        let signature = try await signatureCreator.createSignature(productId: "productId", offerIdentifier: "offerIdentifier", transactionId: nil)
        let tokenComponents = signature.components(separatedBy: ".")
        guard let payloadData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[1])) else {
            XCTAssertTrue(false)
            return
        }
        let payload = try JSONSerialization.jsonObject(with: payloadData) as! [String: Any]
        XCTAssertNil(payload["transactionId"])
    }
    
    public func testIntroductoryOfferEligbilitySignatureCreator() async throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try IntroductoryOfferEligibilitySignatureCreator(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "bundleId")
        let signature = try await signatureCreator.createSignature(productId: "productId", allowIntroductoryOffer: true, transactionId: "transactionId")
        let tokenComponents = signature.components(separatedBy: ".")
        guard let headerData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[0])),
              let payloadData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[1])) else {
            XCTAssertTrue(false)
            return
        }
        let header = try JSONSerialization.jsonObject(with: headerData) as! [String: Any]
        let payload = try JSONSerialization.jsonObject(with: payloadData) as! [String: Any]
        
        // Header
        XCTAssertEqual("JWT", header["typ"] as! String)
        XCTAssertEqual("ES256", header["alg"] as! String)
        XCTAssertEqual("keyId", header["kid"] as! String)
        // Payload
        XCTAssertEqual("issuerId", payload["iss"] as! String)
        XCTAssertNotNil(payload["iat"])
        XCTAssertNil(payload["exp"])
        XCTAssertEqual("introductory-offer-eligibility", payload["aud"] as! String)
        XCTAssertEqual("bundleId", payload["bid"] as! String)
        XCTAssertNotNil(payload["nonce"])
        XCTAssertEqual("productId", payload["productId"] as! String)
        XCTAssertEqual(true, payload["allowIntroductoryOffer"] as! Bool)
        XCTAssertEqual("transactionId", payload["transactionId"] as! String)
    }
    
    public func testAdvancedCommerceInAppSignatureCreator() async throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try AdvancedCommerceInAppSignatureCreator(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "bundleId")
        let inAppRequest = TestInAppRequest(testData: "testData")
        let signature = try await signatureCreator.createSignature(advancedCommerceInAppRequest: inAppRequest)
        let tokenComponents = signature.components(separatedBy: ".")
        guard let headerData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[0])),
              let payloadData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[1])) else {
            XCTAssertTrue(false)
            return
        }
        let header = try JSONSerialization.jsonObject(with: headerData) as! [String: Any]
        let payload = try JSONSerialization.jsonObject(with: payloadData) as! [String: Any]
        
        // Header
        XCTAssertEqual("JWT", header["typ"] as! String)
        XCTAssertEqual("ES256", header["alg"] as! String)
        XCTAssertEqual("keyId", header["kid"] as! String)
        // Payload
        XCTAssertEqual("issuerId", payload["iss"] as! String)
        XCTAssertNotNil(payload["iat"])
        XCTAssertNil(payload["exp"])
        XCTAssertEqual("advanced-commerce-api", payload["aud"] as! String)
        XCTAssertEqual("bundleId", payload["bid"] as! String)
        XCTAssertNotNil(payload["nonce"])
        let base64EncodedRequest = payload["request"] as! String
        guard let requestData = Foundation.Data(base64Encoded: base64EncodedRequest) else {
            XCTAssertTrue(false)
            return
        }
        let decodedRequest = try JSONSerialization.jsonObject(with: requestData) as! [String: Any]
        XCTAssertEqual("testData", decodedRequest["testData"] as! String)
    }
    
    struct TestInAppRequest: AdvancedCommerceInAppRequest {
        var testData: String
        
        init(testData: String) {
            self.testData = testData
        }
    }
}
