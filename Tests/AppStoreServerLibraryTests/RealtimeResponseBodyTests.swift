// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

final class RealtimeResponseBodyTests: XCTestCase {

    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    public func testRealtimeResponseBodyWithMessage() throws {
        // Create a RealtimeResponseBody with a Message
        let messageId = UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!
        let message = Message(messageIdentifier: messageId)
        let responseBody = RealtimeResponseBody(message: message)

        // Serialize to JSON
        let jsonData = try jsonEncoder.encode(responseBody)
        let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

        // Validate JSON structure
        XCTAssertTrue(json.keys.contains("message"), "JSON should have 'message' field")
        let messageDict = json["message"] as! [String: Any]
        XCTAssertTrue(messageDict.keys.contains("messageIdentifier"), "Message should have 'messageIdentifier' field")
        XCTAssertEqual("A1B2C3D4-E5F6-7890-A1B2-C3D4E5F67890", messageDict["messageIdentifier"] as! String)
        XCTAssertFalse(json.keys.contains("alternateProduct"), "JSON should not have 'alternateProduct' field")
        XCTAssertFalse(json.keys.contains("promotionalOffer"), "JSON should not have 'promotionalOffer' field")

        // Deserialize back
        let deserialized = try jsonDecoder.decode(RealtimeResponseBody.self, from: jsonData)

        // Verify
        XCTAssertNotNil(deserialized.message)
        XCTAssertEqual(messageId, deserialized.message?.messageIdentifier)
        XCTAssertNil(deserialized.alternateProduct)
        XCTAssertNil(deserialized.promotionalOffer)
    }

    public func testRealtimeResponseBodyWithAlternateProduct() throws {
        // Create a RealtimeResponseBody with an AlternateProduct
        let messageId = UUID(uuidString: "b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901")!
        let productId = "com.example.alternate.product"
        let alternateProduct = AlternateProduct(messageIdentifier: messageId, productId: productId)
        let responseBody = RealtimeResponseBody(alternateProduct: alternateProduct)

        // Serialize to JSON
        let jsonData = try jsonEncoder.encode(responseBody)
        let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

        // Validate JSON structure
        XCTAssertTrue(json.keys.contains("alternateProduct"), "JSON should have 'alternateProduct' field")
        let alternateProductDict = json["alternateProduct"] as! [String: Any]
        XCTAssertTrue(alternateProductDict.keys.contains("messageIdentifier"), "AlternateProduct should have 'messageIdentifier' field")
        XCTAssertTrue(alternateProductDict.keys.contains("productId"), "AlternateProduct should have 'productId' field")
        XCTAssertEqual("B2C3D4E5-F6A7-8901-B2C3-D4E5F6A78901", alternateProductDict["messageIdentifier"] as! String)
        XCTAssertEqual("com.example.alternate.product", alternateProductDict["productId"] as! String)
        XCTAssertFalse(json.keys.contains("message"), "JSON should not have 'message' field")
        XCTAssertFalse(json.keys.contains("promotionalOffer"), "JSON should not have 'promotionalOffer' field")

        // Deserialize back
        let deserialized = try jsonDecoder.decode(RealtimeResponseBody.self, from: jsonData)

        // Verify
        XCTAssertNil(deserialized.message)
        XCTAssertNotNil(deserialized.alternateProduct)
        XCTAssertEqual(messageId, deserialized.alternateProduct?.messageIdentifier)
        XCTAssertEqual(productId, deserialized.alternateProduct?.productId)
        XCTAssertNil(deserialized.promotionalOffer)
    }

    public func testRealtimeResponseBodyWithPromotionalOfferV2() throws {
        // Create a RealtimeResponseBody with a PromotionalOffer (V2 signature)
        let messageId = UUID(uuidString: "c3d4e5f6-a789-0123-c3d4-e5f6a7890123")!
        let signatureV2 = "signature2"
        let promotionalOffer = PromotionalOffer(messageIdentifier: messageId, promotionalOfferSignatureV2: signatureV2)
        let responseBody = RealtimeResponseBody(promotionalOffer: promotionalOffer)

        // Serialize to JSON
        let jsonData = try jsonEncoder.encode(responseBody)
        let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

        // Validate JSON structure
        XCTAssertTrue(json.keys.contains("promotionalOffer"), "JSON should have 'promotionalOffer' field")
        let promotionalOfferDict = json["promotionalOffer"] as! [String: Any]
        XCTAssertTrue(promotionalOfferDict.keys.contains("messageIdentifier"), "PromotionalOffer should have 'messageIdentifier' field")
        XCTAssertTrue(promotionalOfferDict.keys.contains("promotionalOfferSignatureV2"), "PromotionalOffer should have 'promotionalOfferSignatureV2' field")
        XCTAssertEqual("C3D4E5F6-A789-0123-C3D4-E5F6A7890123", promotionalOfferDict["messageIdentifier"] as! String)
        XCTAssertEqual("signature2", promotionalOfferDict["promotionalOfferSignatureV2"] as! String)
        XCTAssertFalse(promotionalOfferDict.keys.contains("promotionalOfferSignatureV1"), "PromotionalOffer should not have 'promotionalOfferSignatureV1' field")
        XCTAssertFalse(json.keys.contains("message"), "JSON should not have 'message' field")
        XCTAssertFalse(json.keys.contains("alternateProduct"), "JSON should not have 'alternateProduct' field")

        // Deserialize back
        let deserialized = try jsonDecoder.decode(RealtimeResponseBody.self, from: jsonData)

        // Verify
        XCTAssertNil(deserialized.message)
        XCTAssertNil(deserialized.alternateProduct)
        XCTAssertNotNil(deserialized.promotionalOffer)
        XCTAssertEqual(messageId, deserialized.promotionalOffer?.messageIdentifier)
        XCTAssertEqual(signatureV2, deserialized.promotionalOffer?.promotionalOfferSignatureV2)
        XCTAssertNil(deserialized.promotionalOffer?.promotionalOfferSignatureV1)
    }

    public func testRealtimeResponseBodyWithPromotionalOfferV1() throws {
        // Create a RealtimeResponseBody with a PromotionalOffer (V1 signature)
        let messageId = UUID(uuidString: "d4e5f6a7-8901-2345-d4e5-f6a789012345")!
        let nonce = UUID(uuidString: "e5f6a789-0123-4567-e5f6-a78901234567")!
        let appAccountToken = UUID(uuidString: "f6a78901-2345-6789-f6a7-890123456789")!
        let signatureV1 = PromotionalOfferSignatureV1(
            encodedSignature: "base64encodedSignature",
            productId: "com.example.product",
            nonce: nonce,
            timestamp: 1698148900000,
            keyId: "keyId123",
            offerIdentifier: "offer123",
            appAccountToken: appAccountToken
        )

        let promotionalOffer = PromotionalOffer(messageIdentifier: messageId, promotionalOfferSignatureV1: signatureV1)
        let responseBody = RealtimeResponseBody(promotionalOffer: promotionalOffer)

        // Serialize to JSON
        let jsonData = try jsonEncoder.encode(responseBody)
        let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

        // Validate JSON structure
        XCTAssertTrue(json.keys.contains("promotionalOffer"), "JSON should have 'promotionalOffer' field")
        let promotionalOfferDict = json["promotionalOffer"] as! [String: Any]
        XCTAssertTrue(promotionalOfferDict.keys.contains("messageIdentifier"), "PromotionalOffer should have 'messageIdentifier' field")
        XCTAssertTrue(promotionalOfferDict.keys.contains("promotionalOfferSignatureV1"), "PromotionalOffer should have 'promotionalOfferSignatureV1' field")
        XCTAssertEqual("D4E5F6A7-8901-2345-D4E5-F6A789012345", promotionalOfferDict["messageIdentifier"] as! String)

        let v1Dict = promotionalOfferDict["promotionalOfferSignatureV1"] as! [String: Any]
        XCTAssertTrue(v1Dict.keys.contains("encodedSignature"), "V1 signature should have 'encodedSignature' field")
        XCTAssertTrue(v1Dict.keys.contains("productId"), "V1 signature should have 'productId' field")
        XCTAssertTrue(v1Dict.keys.contains("nonce"), "V1 signature should have 'nonce' field")
        XCTAssertTrue(v1Dict.keys.contains("timestamp"), "V1 signature should have 'timestamp' field")
        XCTAssertTrue(v1Dict.keys.contains("keyId"), "V1 signature should have 'keyId' field")
        XCTAssertTrue(v1Dict.keys.contains("offerIdentifier"), "V1 signature should have 'offerIdentifier' field")
        XCTAssertTrue(v1Dict.keys.contains("appAccountToken"), "V1 signature should have 'appAccountToken' field")
        XCTAssertEqual("base64encodedSignature", v1Dict["encodedSignature"] as! String)
        XCTAssertEqual("com.example.product", v1Dict["productId"] as! String)
        XCTAssertEqual("e5f6a789-0123-4567-e5f6-a78901234567", v1Dict["nonce"] as! String)
        XCTAssertEqual(1698148900000, v1Dict["timestamp"] as! Int64)
        XCTAssertEqual("keyId123", v1Dict["keyId"] as! String)
        XCTAssertEqual("offer123", v1Dict["offerIdentifier"] as! String)
        XCTAssertEqual("f6a78901-2345-6789-f6a7-890123456789", v1Dict["appAccountToken"] as! String)

        XCTAssertFalse(promotionalOfferDict.keys.contains("promotionalOfferSignatureV2"), "PromotionalOffer should not have 'promotionalOfferSignatureV2' field")
        XCTAssertFalse(json.keys.contains("message"), "JSON should not have 'message' field")
        XCTAssertFalse(json.keys.contains("alternateProduct"), "JSON should not have 'alternateProduct' field")

        // Deserialize back
        let deserialized = try jsonDecoder.decode(RealtimeResponseBody.self, from: jsonData)

        // Verify
        XCTAssertNil(deserialized.message)
        XCTAssertNil(deserialized.alternateProduct)
        XCTAssertNotNil(deserialized.promotionalOffer)
        XCTAssertEqual(messageId, deserialized.promotionalOffer?.messageIdentifier)
        XCTAssertNil(deserialized.promotionalOffer?.promotionalOfferSignatureV2)
        XCTAssertNotNil(deserialized.promotionalOffer?.promotionalOfferSignatureV1)

        let deserializedV1 = deserialized.promotionalOffer!.promotionalOfferSignatureV1!
        XCTAssertEqual("com.example.product", deserializedV1.productId)
        XCTAssertEqual("offer123", deserializedV1.offerIdentifier)
        XCTAssertEqual(nonce, deserializedV1.nonce)
        XCTAssertEqual(1698148900000, deserializedV1.timestamp)
        XCTAssertEqual("keyId123", deserializedV1.keyId)
        XCTAssertEqual(appAccountToken, deserializedV1.appAccountToken)
        XCTAssertEqual("base64encodedSignature", deserializedV1.encodedSignature)
    }

    public func testRealtimeResponseBodySerialization() throws {
        // Test that JSON serialization uses correct field names
        let messageId = UUID(uuidString: "12345678-1234-1234-1234-123456789012")!
        let message = Message(messageIdentifier: messageId)
        let responseBody = RealtimeResponseBody(message: message)

        let jsonData = try jsonEncoder.encode(responseBody)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        // Verify JSON contains correct field names
        XCTAssertTrue(jsonString.contains("\"message\""))
        XCTAssertTrue(jsonString.contains("\"messageIdentifier\""))
        XCTAssertTrue(jsonString.contains("\"12345678-1234-1234-1234-123456789012\""))
    }
}
