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
        assertIssuedAtIsIntegerSeconds(payloadData)
        XCTAssertNil(payload["exp"])
        XCTAssertEqual("promotional-offer", payload["aud"] as! String)
        XCTAssertEqual("bundleId", payload["bid"] as! String)
        assertNonceIsLowercaseUUID(payload["nonce"])
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
    
    public func testIntroductoryOfferEligibilitySignatureCreator() async throws {
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
        assertIssuedAtIsIntegerSeconds(payloadData)
        XCTAssertNil(payload["exp"])
        XCTAssertEqual("introductory-offer-eligibility", payload["aud"] as! String)
        XCTAssertEqual("bundleId", payload["bid"] as! String)
        assertNonceIsLowercaseUUID(payload["nonce"])
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
        assertIssuedAtIsIntegerSeconds(payloadData)
        XCTAssertNil(payload["exp"])
        XCTAssertEqual("advanced-commerce-api", payload["aud"] as! String)
        XCTAssertEqual("bundleId", payload["bid"] as! String)
        assertNonceIsLowercaseUUID(payload["nonce"])
        let base64EncodedRequest = payload["request"] as! String
        guard let requestData = Foundation.Data(base64Encoded: base64EncodedRequest) else {
            XCTAssertTrue(false)
            return
        }
        let decodedRequest = try JSONSerialization.jsonObject(with: requestData) as! [String: Any]
        XCTAssertEqual("testData", decodedRequest["testData"] as! String)
    }
    
    public func testAdvancedCommerceInAppSignatureCreatorWithAdvancedCommerceRequest() async throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try AdvancedCommerceInAppSignatureCreator(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "bundleId")
        let requestInfo = AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "f55df048-4cd8-4261-b404-b6f813ff70e5")!, appAccountToken: UUID(uuidString: "7e3fb20b-4cdb-47cc-936d-99d65f608138")!, consistencyToken: "consistencyToken")
        let inAppRequest = try AdvancedCommerceSubscriptionReactivateInAppRequest(requestInfo: requestInfo, transactionId: "transactionId", items: [AdvancedCommerceSubscriptionReactivateItem(sku: "sku")], storefront: "USA")
        let signature = try await signatureCreator.createSignature(advancedCommerceInAppRequest: inAppRequest)
        let tokenComponents = signature.components(separatedBy: ".")
        guard let payloadData = Foundation.Data(base64Encoded: base64URLToBase64(tokenComponents[1])) else {
            XCTAssertTrue(false)
            return
        }
        let payload = try JSONSerialization.jsonObject(with: payloadData) as! [String: Any]
        XCTAssertEqual("advanced-commerce-api", payload["aud"] as! String)
        guard let requestData = Foundation.Data(base64Encoded: payload["request"] as! String) else {
            XCTAssertTrue(false)
            return
        }
        let decodedRequest = try JSONSerialization.jsonObject(with: requestData) as! [String: Any]
        XCTAssertEqual("REACTIVATE_SUBSCRIPTION", decodedRequest["operation"] as! String)
        XCTAssertEqual("1", decodedRequest["version"] as! String)
        XCTAssertEqual("transactionId", decodedRequest["transactionId"] as! String)
        XCTAssertEqual("USA", decodedRequest["storefront"] as! String)
        let decodedRequestInfo = decodedRequest["requestInfo"] as! [String: Any]
        XCTAssertEqual("f55df048-4cd8-4261-b404-b6f813ff70e5", decodedRequestInfo["requestReferenceId"] as! String)
        XCTAssertEqual("7e3fb20b-4cdb-47cc-936d-99d65f608138", decodedRequestInfo["appAccountToken"] as! String)
        XCTAssertEqual("consistencyToken", decodedRequestInfo["consistencyToken"] as! String)
        let decodedItems = decodedRequest["items"] as! [[String: Any]]
        XCTAssertEqual(1, decodedItems.count)
        XCTAssertEqual("sku", decodedItems[0]["SKU"] as! String)
        XCTAssertEqual(inAppRequest, try getJsonDecoder().decode(AdvancedCommerceSubscriptionReactivateInAppRequest.self, from: requestData))
    }
    
    private func assertIssuedAtIsIntegerSeconds(_ payloadData: Foundation.Data, file: StaticString = #filePath, line: UInt = #line) {
        let payloadString = String(decoding: payloadData, as: UTF8.self)
        guard let range = payloadString.range(of: #""iat":[0-9]+[,}]"#, options: .regularExpression) else {
            XCTFail(file: file, line: line)
            return
        }
        let iat = Int64(payloadString[range].dropFirst(6).dropLast())!
        XCTAssertLessThanOrEqual(abs(iat - Int64(Date().timeIntervalSince1970)), 60, file: file, line: line)
    }
    
    private func assertNonceIsLowercaseUUID(_ nonce: Any?, file: StaticString = #filePath, line: UInt = #line) {
        guard let nonce = nonce as? String else {
            XCTFail(file: file, line: line)
            return
        }
        XCTAssertNotNil(UUID(uuidString: nonce), file: file, line: line)
        XCTAssertEqual(nonce.lowercased(), nonce, file: file, line: line)
    }
    
    struct TestInAppRequest: AdvancedCommerceInAppRequest {
        var testData: String
        
        init(testData: String) {
            self.testData = testData
        }
    }
}
