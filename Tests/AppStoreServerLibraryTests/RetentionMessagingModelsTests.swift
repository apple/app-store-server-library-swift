// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

final class RetentionMessagingModelsTests: XCTestCase {

    private let messageIdentifier = UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!
    private let imageIdentifier = UUID(uuidString: "b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901")!

    public func testBulletPointValidation() throws {
        let maxLengthText = String(repeating: "A", count: 66)
        let maxLengthAltText = String(repeating: "A", count: 150)
        let bulletPoint = try BulletPoint(altText: maxLengthAltText, imageIdentifier: imageIdentifier, text: maxLengthText)
        XCTAssertEqual(maxLengthText, bulletPoint.text)
        XCTAssertEqual(maxLengthAltText, bulletPoint.altText)

        XCTAssertThrowsError(try BulletPoint(altText: "Alt text", imageIdentifier: imageIdentifier, text: String(repeating: "A", count: 67))) { error in
            XCTAssertEqual(BulletPoint.ValidationError.textTooLong, error as? BulletPoint.ValidationError)
        }
        XCTAssertThrowsError(try BulletPoint(altText: String(repeating: "A", count: 151), imageIdentifier: imageIdentifier, text: "Text")) { error in
            XCTAssertEqual(BulletPoint.ValidationError.altTextTooLong, error as? BulletPoint.ValidationError)
        }
    }

    public func testUploadMessageImageValidation() throws {
        let maxLengthAltText = String(repeating: "A", count: 150)
        let image = try UploadMessageImage(imageIdentifier: imageIdentifier, altText: maxLengthAltText)
        XCTAssertEqual(maxLengthAltText, image.altText)

        XCTAssertThrowsError(try UploadMessageImage(imageIdentifier: imageIdentifier, altText: String(repeating: "A", count: 151))) { error in
            XCTAssertEqual(UploadMessageImage.ValidationError.altTextTooLong, error as? UploadMessageImage.ValidationError)
        }
    }

    public func testUploadMessageRequestBodyValidation() throws {
        let maxLengthHeader = String(repeating: "A", count: 66)
        let maxLengthBody = String(repeating: "A", count: 144)
        let bulletPoint = try BulletPoint(altText: "Alt text", imageIdentifier: imageIdentifier, text: "Text")
        let maxBulletPoints = Array(repeating: bulletPoint, count: 5)
        let requestBody = try UploadMessageRequestBody(header: maxLengthHeader, body: maxLengthBody, bulletPoints: maxBulletPoints)
        XCTAssertEqual(maxLengthHeader, requestBody.header)
        XCTAssertEqual(maxLengthBody, requestBody.body)
        XCTAssertEqual(5, requestBody.bulletPoints?.count)

        XCTAssertThrowsError(try UploadMessageRequestBody(header: String(repeating: "A", count: 67), body: "Body")) { error in
            XCTAssertEqual(UploadMessageRequestBody.ValidationError.headerTooLong, error as? UploadMessageRequestBody.ValidationError)
        }
        XCTAssertThrowsError(try UploadMessageRequestBody(header: "Header", body: String(repeating: "A", count: 145))) { error in
            XCTAssertEqual(UploadMessageRequestBody.ValidationError.bodyTooLong, error as? UploadMessageRequestBody.ValidationError)
        }
        XCTAssertThrowsError(try UploadMessageRequestBody(header: "Header", body: "Body", bulletPoints: Array(repeating: bulletPoint, count: 6))) { error in
            XCTAssertEqual(UploadMessageRequestBody.ValidationError.tooManyBulletPoints, error as? UploadMessageRequestBody.ValidationError)
        }
        XCTAssertThrowsError(try UploadMessageRequestBody(header: String(repeating: "A", count: 67), body: "Body", rawHeaderPosition: "ABOVE_BODY")) { error in
            XCTAssertEqual(UploadMessageRequestBody.ValidationError.headerTooLong, error as? UploadMessageRequestBody.ValidationError)
        }
    }

    public func testRealtimeUrlRequestValidation() throws {
        let maxLengthURL = "https://" + String(repeating: "a", count: 248)
        XCTAssertEqual(256, maxLengthURL.count)
        let request = try RealtimeUrlRequest(realtimeURL: maxLengthURL)
        XCTAssertEqual(maxLengthURL, request.realtimeURL)

        XCTAssertThrowsError(try RealtimeUrlRequest(realtimeURL: maxLengthURL + "a")) { error in
            XCTAssertEqual(RealtimeUrlRequest.ValidationError.realtimeURLTooLong, error as? RealtimeUrlRequest.ValidationError)
        }
    }

    public func testValidationMeasuresLengthInUnicodeCodePoints() throws {
        let combiningHeader = String(repeating: "e\u{0301}", count: 33)
        XCTAssertEqual(combiningHeader, try UploadMessageRequestBody(header: combiningHeader, body: "Body").header)
        XCTAssertThrowsError(try UploadMessageRequestBody(header: combiningHeader + "e", body: "Body")) { error in
            XCTAssertEqual(UploadMessageRequestBody.ValidationError.headerTooLong, error as? UploadMessageRequestBody.ValidationError)
        }
        XCTAssertThrowsError(try UploadMessageRequestBody(header: "Header", body: String(repeating: "e\u{0301}", count: 73))) { error in
            XCTAssertEqual(UploadMessageRequestBody.ValidationError.bodyTooLong, error as? UploadMessageRequestBody.ValidationError)
        }
        XCTAssertThrowsError(try BulletPoint(altText: "Alt text", imageIdentifier: imageIdentifier, text: combiningHeader + "e")) { error in
            XCTAssertEqual(BulletPoint.ValidationError.textTooLong, error as? BulletPoint.ValidationError)
        }
        XCTAssertThrowsError(try BulletPoint(altText: String(repeating: "e\u{0301}", count: 76), imageIdentifier: imageIdentifier, text: "Text")) { error in
            XCTAssertEqual(BulletPoint.ValidationError.altTextTooLong, error as? BulletPoint.ValidationError)
        }
        XCTAssertThrowsError(try UploadMessageImage(imageIdentifier: imageIdentifier, altText: String(repeating: "e\u{0301}", count: 76))) { error in
            XCTAssertEqual(UploadMessageImage.ValidationError.altTextTooLong, error as? UploadMessageImage.ValidationError)
        }
        XCTAssertThrowsError(try RealtimeUrlRequest(realtimeURL: "https://" + String(repeating: "e\u{0301}", count: 125))) { error in
            XCTAssertEqual(RealtimeUrlRequest.ValidationError.realtimeURLTooLong, error as? RealtimeUrlRequest.ValidationError)
        }

        let nonBmpBody = String(repeating: "\u{1F44D}", count: 144)
        XCTAssertEqual(nonBmpBody, try UploadMessageRequestBody(header: "Header", body: nonBmpBody).body)
    }

    public func testInitializersWithDefaultEnumArguments() throws {
        let requestBody = try UploadMessageRequestBody(header: "Header", body: "Body")
        XCTAssertNil(requestBody.image)
        XCTAssertNil(requestBody.headerPosition)
        XCTAssertNil(requestBody.rawHeaderPosition)
        XCTAssertNil(requestBody.bulletPoints)
        let requestBodyWithImage = try UploadMessageRequestBody(header: "Header", body: "Body", image: nil)
        XCTAssertNil(requestBodyWithImage.image)
        let requestBodyWithBulletPoints = try UploadMessageRequestBody(header: "Header", body: "Body", bulletPoints: [])
        XCTAssertEqual(0, requestBodyWithBulletPoints.bulletPoints?.count)
        let requestBodyWithRawHeaderPosition = try UploadMessageRequestBody(header: "Header", body: "Body", rawHeaderPosition: "UNKNOWN")
        XCTAssertNil(requestBodyWithRawHeaderPosition.headerPosition)
        XCTAssertEqual("UNKNOWN", requestBodyWithRawHeaderPosition.rawHeaderPosition)

        let alternateProduct = AlternateProduct(messageIdentifier: messageIdentifier, productId: "com.example.product")
        XCTAssertEqual(messageIdentifier, alternateProduct.messageIdentifier)
        XCTAssertEqual("com.example.product", alternateProduct.productId)
        XCTAssertNil(alternateProduct.billingPlanType)
        let rawAlternateProduct = AlternateProduct(messageIdentifier: messageIdentifier, productId: "com.example.product", rawBillingPlanType: "UNKNOWN")
        XCTAssertNil(rawAlternateProduct.billingPlanType)
        XCTAssertEqual("UNKNOWN", rawAlternateProduct.rawBillingPlanType)

        let emptyImageListItem = GetImageListResponseItem()
        XCTAssertNil(emptyImageListItem.imageIdentifier)
        let imageListItem = GetImageListResponseItem(imageIdentifier: imageIdentifier)
        XCTAssertEqual(imageIdentifier, imageListItem.imageIdentifier)
        XCTAssertNil(imageListItem.rawImageState)
        XCTAssertNil(imageListItem.rawImageSize)
        let typedImageListItem = GetImageListResponseItem(imageIdentifier: imageIdentifier, imageSize: .bulletPoint, imageState: .approved)
        XCTAssertEqual("APPROVED", typedImageListItem.rawImageState)
        XCTAssertEqual("BULLET_POINT", typedImageListItem.rawImageSize)
        let rawImageStateItem = GetImageListResponseItem(imageIdentifier: imageIdentifier, rawImageState: "PENDING")
        XCTAssertEqual(ImageState.pending, rawImageStateItem.imageState)
        XCTAssertNil(rawImageStateItem.rawImageSize)
        let rawImageSizeItem = GetImageListResponseItem(imageIdentifier: imageIdentifier, rawImageSize: "FULL_SIZE")
        XCTAssertNil(rawImageSizeItem.rawImageState)
        XCTAssertEqual(ImageSize.fullSize, rawImageSizeItem.imageSize)

        let emptyMessageListItem = GetMessageListResponseItem()
        XCTAssertNil(emptyMessageListItem.messageIdentifier)
        let messageListItem = GetMessageListResponseItem(messageIdentifier: messageIdentifier)
        XCTAssertEqual(messageIdentifier, messageListItem.messageIdentifier)
        XCTAssertNil(messageListItem.rawMessageState)
        let rawMessageListItem = GetMessageListResponseItem(messageIdentifier: messageIdentifier, rawMessageState: "REJECTED")
        XCTAssertEqual(MessageState.rejected, rawMessageListItem.messageState)
    }

    public func testAlternateProductRequiredFields() throws {
        let alternateProduct = AlternateProduct(messageIdentifier: messageIdentifier, productId: "com.example.product")
        var json = try encodeToDictionary(alternateProduct)
        XCTAssertEqual("a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", json["messageIdentifier"] as? String)
        XCTAssertEqual("com.example.product", json["productId"] as? String)
        XCTAssertNil(json["billingPlanType"])
        json["billingPlanType"] = "MONTHLY"
        TestingUtility.confirmRequiredKeys(AlternateProduct.self, json, requiredKeys: ["messageIdentifier", "productId"])
    }

    public func testDefaultConfigurationRequestRequiredFields() throws {
        let json = try encodeToDictionary(DefaultConfigurationRequest(messageIdentifier: messageIdentifier))
        XCTAssertEqual("a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", json["messageIdentifier"] as? String)
        TestingUtility.confirmRequiredKeys(DefaultConfigurationRequest.self, json, requiredKeys: ["messageIdentifier"])
    }

    public func testResponsesWithoutRequiredFieldsFailToDecode() throws {
        TestingUtility.confirmRequiredKeys(DecodedRealtimeRequestBody.self, TestingUtility.readJsonObject("resources/models/decodedRealtimeRequest.json"), requiredKeys: ["originalTransactionId", "appAppleId", "productId", "userLocale", "requestIdentifier", "signedDate", "environment"])
        let performanceTestResponse = TestingUtility.readJsonObject("resources/models/performanceTestResponse.json")
        TestingUtility.confirmRequiredKeys(PerformanceTestResponse.self, performanceTestResponse, requiredKeys: ["config", "requestId"])
        TestingUtility.confirmRequiredKeys(PerformanceTestConfig.self, performanceTestResponse["config"] as! [String: Any], requiredKeys: ["maxConcurrentRequests", "totalRequests", "totalDuration", "responseTimeThreshold", "successRateThreshold"])
        let performanceTestResultResponse = TestingUtility.readJsonObject("resources/models/performanceTestResultResponse.json")
        TestingUtility.confirmRequiredKeys(PerformanceTestResponseTimes.self, performanceTestResultResponse["responseTimes"] as! [String: Any], requiredKeys: ["average", "p50", "p90", "p95", "p99"])
        TestingUtility.confirmRequiredKeys(RealtimeUrlResponse.self, TestingUtility.readJsonObject("resources/models/getRealtimeUrlResponse.json"), requiredKeys: ["realtimeURL"])
        TestingUtility.confirmRequiredKeys(DefaultConfigurationResponse.self, TestingUtility.readJsonObject("resources/models/getDefaultMessageResponse.json"), requiredKeys: ["messageIdentifier"])
    }

    public func testPerformanceTestResultResponseRequiredFields() throws {
        let json = TestingUtility.readJsonObject("resources/models/performanceTestResultResponse.json")
        TestingUtility.confirmRequiredKeys(PerformanceTestResultResponse.self, json, requiredKeys: ["config", "target", "result", "successRate", "numPending", "responseTimes", "failures"])

        var unknownValues = json
        unknownValues["result"] = "UNKNOWN"
        unknownValues["failures"] = ["UNKNOWN": 2, "TIMED_OUT": 1]
        let response = try getJsonDecoder().decode(PerformanceTestResultResponse.self, from: JSONSerialization.data(withJSONObject: unknownValues))
        XCTAssertNil(response.result)
        XCTAssertEqual("UNKNOWN", response.rawResult)
        XCTAssertEqual([SendAttemptResult.timedOut: Int32(1)], response.failures)
        XCTAssertEqual(["UNKNOWN": Int32(2), "TIMED_OUT": Int32(1)], response.rawFailures)

        var mutableResponse = response
        mutableResponse.result = nil
        mutableResponse.failures = nil
        XCTAssertEqual("UNKNOWN", mutableResponse.rawResult)
        XCTAssertEqual(["UNKNOWN": Int32(2), "TIMED_OUT": Int32(1)], mutableResponse.rawFailures)
        mutableResponse.result = .pass
        mutableResponse.failures = [.noResponse: 3]
        XCTAssertEqual("PASS", mutableResponse.rawResult)
        XCTAssertEqual(["NO_RESPONSE": Int32(3)], mutableResponse.rawFailures)
    }

    public func testTypedPropertySetters() throws {
        var requestBody = try UploadMessageRequestBody(header: "Header", body: "Body")
        requestBody.headerPosition = .aboveImage
        XCTAssertEqual(HeaderPosition.aboveImage, requestBody.headerPosition)
        XCTAssertEqual("ABOVE_IMAGE", requestBody.rawHeaderPosition)
        requestBody.headerPosition = nil
        XCTAssertNil(requestBody.rawHeaderPosition)

        var imageListItem = GetImageListResponseItem(imageIdentifier: imageIdentifier)
        imageListItem.imageState = .rejected
        imageListItem.imageSize = .bulletPoint
        XCTAssertEqual("REJECTED", imageListItem.rawImageState)
        XCTAssertEqual("BULLET_POINT", imageListItem.rawImageSize)
        imageListItem.imageState = nil
        imageListItem.imageSize = nil
        XCTAssertNil(imageListItem.rawImageState)
        XCTAssertNil(imageListItem.rawImageSize)

        var messageListItem = GetMessageListResponseItem(messageIdentifier: messageIdentifier)
        messageListItem.messageState = .approved
        XCTAssertEqual("APPROVED", messageListItem.rawMessageState)
        messageListItem.messageState = nil
        XCTAssertNil(messageListItem.rawMessageState)

        var decodedRealtimeRequestBody = DecodedRealtimeRequestBody(originalTransactionId: "99371282", appAppleId: 531412, productId: "com.example.product", userLocale: "en-US", requestIdentifier: messageIdentifier, environment: .sandbox, signedDate: Date(timeIntervalSince1970: 1698148900))
        decodedRealtimeRequestBody.environment = .production
        XCTAssertEqual(AppStoreEnvironment.production, decodedRealtimeRequestBody.environment)
        XCTAssertEqual("Production", decodedRealtimeRequestBody.rawEnvironment)
        decodedRealtimeRequestBody.environment = nil
        XCTAssertEqual("Production", decodedRealtimeRequestBody.rawEnvironment)
    }

    public func testUUIDsEncodeAsLowercase() throws {
        let lowercaseMessageIdentifier = "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890"
        let lowercaseImageIdentifier = "b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901"

        let message = Message(messageIdentifier: messageIdentifier)
        XCTAssertEqual(lowercaseMessageIdentifier, try encodeToDictionary(message)["messageIdentifier"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(message)
        XCTAssertFalse(try encodeToDictionary(Message()).keys.contains("messageIdentifier"))

        let alternateProduct = AlternateProduct(messageIdentifier: messageIdentifier, productId: "com.example.product", billingPlanType: .monthly)
        XCTAssertEqual(lowercaseMessageIdentifier, try encodeToDictionary(alternateProduct)["messageIdentifier"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(alternateProduct)

        let promotionalOffer = PromotionalOffer(messageIdentifier: messageIdentifier, promotionalOfferSignatureV2: "signature2")
        let promotionalOfferDictionary = try encodeToDictionary(promotionalOffer)
        XCTAssertEqual(lowercaseMessageIdentifier, promotionalOfferDictionary["messageIdentifier"] as? String)
        XCTAssertEqual("signature2", promotionalOfferDictionary["promotionalOfferSignatureV2"] as? String)
        XCTAssertFalse(promotionalOfferDictionary.keys.contains("promotionalOfferSignatureV1"))
        TestingUtility.confirmCodableInternallyConsistent(promotionalOffer)

        let bulletPoint = try BulletPoint(altText: "Alt text", imageIdentifier: imageIdentifier, text: "Text")
        let bulletPointDictionary = try encodeToDictionary(bulletPoint)
        XCTAssertEqual("Text", bulletPointDictionary["text"] as? String)
        XCTAssertEqual(lowercaseImageIdentifier, bulletPointDictionary["imageIdentifier"] as? String)
        XCTAssertEqual("Alt text", bulletPointDictionary["altText"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(bulletPoint)

        let image = try UploadMessageImage(imageIdentifier: imageIdentifier, altText: "Alt text")
        let imageDictionary = try encodeToDictionary(image)
        XCTAssertEqual(lowercaseImageIdentifier, imageDictionary["imageIdentifier"] as? String)
        XCTAssertEqual("Alt text", imageDictionary["altText"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(image)

        let defaultConfigurationRequest = DefaultConfigurationRequest(messageIdentifier: messageIdentifier)
        XCTAssertEqual(lowercaseMessageIdentifier, try encodeToDictionary(defaultConfigurationRequest)["messageIdentifier"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(defaultConfigurationRequest)

        let defaultConfigurationResponse = DefaultConfigurationResponse(messageIdentifier: messageIdentifier)
        XCTAssertEqual(lowercaseMessageIdentifier, try encodeToDictionary(defaultConfigurationResponse)["messageIdentifier"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(defaultConfigurationResponse)

        let imageListItem = GetImageListResponseItem(imageIdentifier: imageIdentifier, imageSize: .fullSize, imageState: .approved)
        XCTAssertEqual(lowercaseImageIdentifier, try encodeToDictionary(imageListItem)["imageIdentifier"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(imageListItem)

        let messageListItem = GetMessageListResponseItem(messageIdentifier: messageIdentifier, messageState: .approved)
        XCTAssertEqual(lowercaseMessageIdentifier, try encodeToDictionary(messageListItem)["messageIdentifier"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(messageListItem)

        let decodedRealtimeRequestBody = DecodedRealtimeRequestBody(originalTransactionId: "99371282", appAppleId: 531412, productId: "com.example.product", userLocale: "en-US", requestIdentifier: messageIdentifier, environment: .sandbox, signedDate: Date(timeIntervalSince1970: 1698148900))
        XCTAssertEqual(lowercaseMessageIdentifier, try encodeToDictionary(decodedRealtimeRequestBody)["requestIdentifier"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(decodedRealtimeRequestBody)

        let performanceTestResponse = PerformanceTestResponse(config: PerformanceTestConfig(maxConcurrentRequests: 10, responseTimeThreshold: 500, successRateThreshold: 95, totalDuration: 60000, totalRequests: 100), requestId: messageIdentifier)
        XCTAssertEqual(lowercaseMessageIdentifier, try encodeToDictionary(performanceTestResponse)["requestId"] as? String)
        TestingUtility.confirmCodableInternallyConsistent(performanceTestResponse)
    }

    public func testPerformanceTestResponseRequestIdIsUUID() throws {
        var json = TestingUtility.readJsonObject("resources/models/performanceTestResponse.json")
        json["requestId"] = "C4B87A1D-2E3F-4A5B-9C6D-7E8F9A0B1C2D"
        let response = try getJsonDecoder().decode(PerformanceTestResponse.self, from: JSONSerialization.data(withJSONObject: json))
        XCTAssertEqual(UUID(uuidString: "c4b87a1d-2e3f-4a5b-9c6d-7e8f9a0b1c2d"), response.requestId)
        XCTAssertEqual("c4b87a1d-2e3f-4a5b-9c6d-7e8f9a0b1c2d", try encodeToDictionary(response)["requestId"] as? String)

        json["requestId"] = "not-a-uuid"
        XCTAssertThrowsError(try getJsonDecoder().decode(PerformanceTestResponse.self, from: JSONSerialization.data(withJSONObject: json)))
    }

    private func encodeToDictionary<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try getJsonEncoder().encode(value)
        return try JSONSerialization.jsonObject(with: data) as! [String: Any]
    }
}
