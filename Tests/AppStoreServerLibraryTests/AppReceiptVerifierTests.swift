// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import SwiftASN1

final class AppReceiptVerifierTests: XCTestCase {

    private static let BUNDLE_ID = "com.example"
    private static let APP_VERSION = "1.2.3"
    private static let ORIGINAL_APP_VERSION = "1.0"
    private static let OPAQUE_VALUE: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]
    private static let SHA1_HASH: [UInt8] = [
        0xa1, 0xb2, 0xc3, 0xd4, 0xe5, 0xf6, 0x07, 0x18,
        0x29, 0x3a, 0x4b, 0x5c, 0x6d, 0x7e, 0x8f, 0x90, 0x11, 0x22, 0x33, 0x44]
    private static let UNKNOWN_RECEIPT_ATTRIBUTE_VALUE: [UInt8] = [0x0d, 0x0e, 0x0a, 0x0d]
    private static let UNKNOWN_IN_APP_ATTRIBUTE_VALUE: [UInt8] = [0x0b, 0x0e, 0x0e, 0x0f]

    private static let RECEIPT_CREATION_DATE = "2024-03-01T12:00:00Z"
    private static let RECEIPT_CREATION_DATE_VALUE = Date(timeIntervalSince1970: 1709294400)
    private static let ORIGINAL_PURCHASE_DATE = "2023-11-15T08:30:00Z"
    private static let ORIGINAL_PURCHASE_DATE_VALUE = Date(timeIntervalSince1970: 1700037000)
    private static let EXPIRATION_DATE = "2030-01-01T00:00:00Z"
    private static let EXPIRATION_DATE_VALUE = Date(timeIntervalSince1970: 1893456000)

    private static let CONSUMABLE_PRODUCT_ID = "com.example.coins"
    private static let CONSUMABLE_PURCHASE_DATE = "2024-01-15T12:00:00Z"
    private static let CONSUMABLE_PURCHASE_DATE_VALUE = Date(timeIntervalSince1970: 1705320000)
    private static let CONSUMABLE_ORIGINAL_PURCHASE_DATE = "2024-01-10T09:00:00Z"
    private static let CONSUMABLE_ORIGINAL_PURCHASE_DATE_VALUE = Date(timeIntervalSince1970: 1704877200)

    private static let SUBSCRIPTION_PRODUCT_ID = "com.example.subscription"
    private static let SUBSCRIPTION_PURCHASE_DATE = "2024-02-01T09:30:00Z"
    private static let SUBSCRIPTION_PURCHASE_DATE_VALUE = Date(timeIntervalSince1970: 1706779800)
    private static let SUBSCRIPTION_EXPIRES_DATE = "2030-02-01T09:30:00Z"
    private static let SUBSCRIPTION_EXPIRES_DATE_VALUE = Date(timeIntervalSince1970: 1896168600)
    private static let SUBSCRIPTION_CANCELLATION_DATE = "2024-06-01T00:00:00Z"
    private static let SUBSCRIPTION_CANCELLATION_DATE_VALUE = Date(timeIntervalSince1970: 1717200000)

    private static let receiptCreator = try! ReceiptCreator.createReceiptCreator()
    private static let sandboxReceipt = try! receiptCreator.signReceipt(receiptPayload("ProductionSandbox", BUNDLE_ID, RECEIPT_CREATION_DATE))
    private static let xcodeReceiptCreator = try! ReceiptCreator.createSelfSignedReceiptCreator()

    public func testAppReceiptDecoding() async throws {
        let receipt = try await validReceipt(AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndDecodeAppReceipt(encodedReceipt: encode(AppReceiptVerifierTests.sandboxReceipt)))

        XCTAssertEqual("ProductionSandbox", receipt.receiptType)
        XCTAssertEqual(AppReceiptVerifierTests.BUNDLE_ID, receipt.bundleId)
        XCTAssertEqual(derEncodedUTF8String(AppReceiptVerifierTests.BUNDLE_ID), receipt.bundleIdBytes)
        XCTAssertEqual(AppReceiptVerifierTests.APP_VERSION, receipt.applicationVersion)
        XCTAssertEqual(AppReceiptVerifierTests.ORIGINAL_APP_VERSION, receipt.originalApplicationVersion)
        XCTAssertEqual(Data(AppReceiptVerifierTests.OPAQUE_VALUE), receipt.opaqueValue)
        XCTAssertEqual(Data(AppReceiptVerifierTests.SHA1_HASH), receipt.sha1Hash)
        XCTAssertEqual(AppReceiptVerifierTests.RECEIPT_CREATION_DATE_VALUE, receipt.receiptCreationDate)
        XCTAssertEqual(AppReceiptVerifierTests.ORIGINAL_PURCHASE_DATE_VALUE, receipt.originalPurchaseDate)
        XCTAssertEqual(AppReceiptVerifierTests.EXPIRATION_DATE_VALUE, receipt.expirationDate)
        XCTAssertEqual(2, receipt.inAppPurchases.count)

        let consumable = receipt.inAppPurchases[0]
        XCTAssertEqual(1, consumable.quantity)
        XCTAssertEqual(AppReceiptVerifierTests.CONSUMABLE_PRODUCT_ID, consumable.productId)
        XCTAssertEqual("70000000000001", consumable.transactionId)
        XCTAssertEqual("70000000000001", consumable.originalTransactionId)
        XCTAssertEqual(AppReceiptVerifierTests.CONSUMABLE_PURCHASE_DATE_VALUE, consumable.purchaseDate)
        XCTAssertEqual(AppReceiptVerifierTests.CONSUMABLE_ORIGINAL_PURCHASE_DATE_VALUE, consumable.originalPurchaseDate)
        XCTAssertEqual(42, consumable.webOrderLineItemId)

        let subscription = receipt.inAppPurchases[1]
        XCTAssertEqual(1, subscription.quantity)
        XCTAssertEqual(AppReceiptVerifierTests.SUBSCRIPTION_PRODUCT_ID, subscription.productId)
        XCTAssertEqual("70000000000002", subscription.transactionId)
        XCTAssertEqual("70000000000002", subscription.originalTransactionId)
        XCTAssertEqual(AppReceiptVerifierTests.SUBSCRIPTION_PURCHASE_DATE_VALUE, subscription.purchaseDate)
        XCTAssertEqual(AppReceiptVerifierTests.SUBSCRIPTION_PURCHASE_DATE_VALUE, subscription.originalPurchaseDate)
        XCTAssertEqual(AppReceiptVerifierTests.SUBSCRIPTION_EXPIRES_DATE_VALUE, subscription.expiresDate)
        XCTAssertEqual(AppReceiptVerifierTests.SUBSCRIPTION_CANCELLATION_DATE_VALUE, subscription.cancellationDate)
        XCTAssertEqual(12345, subscription.webOrderLineItemId)
    }

    ///An in-app purchase attribute that is present but empty means "absent", and the intro offer flag is an integer
    ///that must surface as a boolean, so a caller can distinguish "no expiration" from "expired at epoch".
    public func testInAppPurchaseFlagAndEmptyDateDecoding() async throws {
        let receipt = try await validReceipt(AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndDecodeAppReceipt(encodedReceipt: encode(AppReceiptVerifierTests.sandboxReceipt)))

        let consumable = receipt.inAppPurchases[0]
        XCTAssertEqual(false, consumable.isInIntroOfferPeriod)
        XCTAssertNil(consumable.expiresDate)
        XCTAssertNil(consumable.cancellationDate)

        XCTAssertEqual(true, receipt.inAppPurchases[1].isInIntroOfferPeriod)
    }

    ///Attribute types this library does not model must survive decoding with their raw bytes, so a receipt field
    ///Apple adds later stays reachable.
    public func testUnknownAttributesArePreserved() async throws {
        let receipt = try await validReceipt(AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndDecodeAppReceipt(encodedReceipt: encode(AppReceiptVerifierTests.sandboxReceipt)))

        XCTAssertEqual(1, receipt.unknownAttributes[9999]?.count)
        XCTAssertEqual(Data(AppReceiptVerifierTests.UNKNOWN_RECEIPT_ATTRIBUTE_VALUE), receipt.unknownAttributes[9999]?[0])
        XCTAssertEqual(Data(AppReceiptVerifierTests.UNKNOWN_IN_APP_ATTRIBUTE_VALUE), receipt.inAppPurchases[0].unknownAttributes[1799]?[0])
    }

    public func testWrongBundleId() async throws {
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox, bundleId: "com.example.other")
        await assertInvalid(.INVALID_APP_IDENTIFIER, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(AppReceiptVerifierTests.sandboxReceipt)))
    }

    public func testWrongEnvironment() async throws {
        let productionReceipt = try AppReceiptVerifierTests.receiptCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("Production", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE))
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.INVALID_ENVIRONMENT, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(productionReceipt)))
    }

    ///A receipt type this library does not recognize maps to no environment at all rather than defaulting to the
    ///verifier's, so an unexpected value can never be mistaken for a match.
    public func testUnknownReceiptType() async throws {
        let unknownTypeReceipt = try AppReceiptVerifierTests.receiptCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionInternal", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE))
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.INVALID_ENVIRONMENT, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(unknownTypeReceipt)))
    }

    public func testTamperedPayload() async throws {
        var tamperedReceipt = AppReceiptVerifierTests.sandboxReceipt
        // Flip a bit inside the app version of the encapsulated payload; the chain is untouched, so only the
        // signature check can catch this.
        tamperedReceipt[try indexOf(tamperedReceipt, Array(AppReceiptVerifierTests.APP_VERSION.utf8))] ^= 0x01
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(tamperedReceipt)))
    }

    public func testReceiptSignedByForeignRoot() async throws {
        let foreignCreator = try ReceiptCreator.createReceiptCreator()
        let forgedReceipt = try foreignCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE))
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(forgedReceipt)))
    }

    public func testLeafWithoutReceiptSigningOid() async throws {
        let creator = try ReceiptCreator.createReceiptCreator(receiptSignerOid: false)
        let receipt = try creator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE))
        let verifier = AppReceiptVerifierTests.verifier(creator, environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
    }

    public func testIntermediateWithoutWwdrOid() async throws {
        let creator = try ReceiptCreator.createReceiptCreator(wwdrIntermediateOid: false)
        let receipt = try creator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE))
        let verifier = AppReceiptVerifierTests.verifier(creator, environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
    }

    public func testReceiptWithoutRootCertificateEmbedded() async throws {
        let receipt = try AppReceiptVerifierTests.receiptCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE), embeddedCertificates: 2)
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
    }

    public func testReceiptThatIsNotBase64() async throws {
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: "!!!not-base64!!!"))
    }

    public func testReceiptThatIsNotAPkcs7Container() async throws {
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(Data([1, 2, 3, 4]))))
    }

    ///Bytes appended after the container must not be ignored, a verifier that parsed a prefix would accept a receipt
    ///carrying unverified extra data.
    public func testTrailingBytesAfterContainer() async throws {
        let paddedReceipt = AppReceiptVerifierTests.sandboxReceipt + Data([0, 0, 0, 0])
        let verifier = AppReceiptVerifierTests.verifier(environment: .sandbox)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(paddedReceipt)))
    }

    ///Receipts outlive the certificates that signed them, so with online checks off the chain is evaluated at the
    ///receipt's creation date.
    public func testReceiptSignedByNowExpiredCertificates() async throws {
        let expiredCreator = try ReceiptCreator.createReceiptCreator(notBefore: ReceiptCreator.daysAgo(730), notAfter: ReceiptCreator.daysAgo(365))
        let createdAt = ReceiptCreator.daysAgo(547)
        let receipt = try expiredCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, rfc3339(createdAt)), signingTime: createdAt)

        let decoded = try await validReceipt(AppReceiptVerifierTests.verifier(expiredCreator, environment: .sandbox).verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
        XCTAssertEqual(rfc3339(createdAt), rfc3339(decoded.receiptCreationDate!))
    }

    ///Enabling online checks moves the evaluation to now, which is the point of the option: the same receipt must
    ///then fail on the expired chain.
    public func testReceiptSignedByNowExpiredCertificatesWithOnlineChecks() async throws {
        let expiredCreator = try ReceiptCreator.createReceiptCreator(notBefore: ReceiptCreator.daysAgo(730), notAfter: ReceiptCreator.daysAgo(365))
        let createdAt = ReceiptCreator.daysAgo(547)
        let receipt = try expiredCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, rfc3339(createdAt)), signingTime: createdAt)

        let verifier = AppReceiptVerifierTests.verifier(expiredCreator, environment: .sandbox, enableOnlineChecks: true)
        await assertInvalid(.VERIFICATION_FAILURE, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
    }

    ///Genuine App Store receipts carry no signed attributes and sign the encapsulated payload directly, unlike the
    ///receipts most CMS tooling produces.
    public func testReceiptWithoutSignedAttributes() async throws {
        let receipt = try AppReceiptVerifierTests.receiptCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE), signedAttributes: false)

        let decoded = try await validReceipt(AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
        XCTAssertEqual(AppReceiptVerifierTests.BUNDLE_ID, decoded.bundleId)
    }

    ///Genuine App Store receipts encapsulate the payload in a constructed OCTET STRING, whose segments have to be
    ///joined before the payload is either digested or decoded.
    public func testReceiptWithSegmentedContent() async throws {
        let receipt = try AppReceiptVerifierTests.receiptCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE), segmentedContent: true)

        let decoded = try await validReceipt(AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
        XCTAssertEqual(AppReceiptVerifierTests.BUNDLE_ID, decoded.bundleId)
        XCTAssertEqual(2, decoded.inAppPurchases.count)
    }

    ///Xcode-generated receipts are not signed by the App Store, so they are decoded without any chain or signature check.
    public func testXcodeReceiptDecoding() async throws {
        let receipt = try AppReceiptVerifierTests.xcodeReceiptCreator.signReceipt(ReceiptCreator.doubleWrap(AppReceiptVerifierTests.receiptPayload("Xcode", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE)))

        let decoded = try await validReceipt(AppReceiptVerifierTests.verifier(AppReceiptVerifierTests.xcodeReceiptCreator, environment: .xcode).verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
        XCTAssertEqual("Xcode", decoded.receiptType)
        XCTAssertEqual(AppReceiptVerifierTests.BUNDLE_ID, decoded.bundleId)
        XCTAssertEqual(AppReceiptVerifierTests.APP_VERSION, decoded.applicationVersion)
        XCTAssertEqual(AppReceiptVerifierTests.RECEIPT_CREATION_DATE_VALUE, decoded.receiptCreationDate)
        XCTAssertEqual(2, decoded.inAppPurchases.count)
    }

    ///Skipping the signature checks must not skip the app identity check.
    public func testXcodeReceiptWithWrongBundleId() async throws {
        let receipt = try AppReceiptVerifierTests.xcodeReceiptCreator.signReceipt(ReceiptCreator.doubleWrap(AppReceiptVerifierTests.receiptPayload("Xcode", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE)))

        let verifier = AppReceiptVerifierTests.verifier(AppReceiptVerifierTests.xcodeReceiptCreator, environment: .xcode, bundleId: "com.example.other")
        await assertInvalid(.INVALID_APP_IDENTIFIER, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
    }

    ///Skipping the signature checks must not skip the environment check either.
    public func testXcodeReceiptWithWrongEnvironment() async throws {
        let receipt = try AppReceiptVerifierTests.xcodeReceiptCreator.signReceipt(ReceiptCreator.doubleWrap(AppReceiptVerifierTests.receiptPayload("Production", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE)))

        let verifier = AppReceiptVerifierTests.verifier(AppReceiptVerifierTests.xcodeReceiptCreator, environment: .xcode)
        await assertInvalid(.INVALID_ENVIRONMENT, await verifier.verifyAndDecodeAppReceipt(encodedReceipt: encode(receipt)))
    }

    public func testVerifyAndExtractTransactionId() async throws {
        let result = await AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndExtractTransactionId(encodedReceipt: encode(AppReceiptVerifierTests.sandboxReceipt))
        switch result {
        case .valid(let transactionId):
            XCTAssertEqual("70000000000001", transactionId)
        case .invalid(_):
            XCTAssert(false)
        }
    }

    ///Same output contract as ReceiptUtility: a verified receipt with no in-app purchases yields nil.
    public func testVerifyAndExtractTransactionIdWithoutInAppPurchases() async throws {
        let receipt = try AppReceiptVerifierTests.receiptCreator.signReceipt(ReceiptCreator.attributeSet()
            .string(0, "ProductionSandbox")
            .string(2, AppReceiptVerifierTests.BUNDLE_ID)
            .date(12, AppReceiptVerifierTests.RECEIPT_CREATION_DATE)
            .build())
        let result = await AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndExtractTransactionId(encodedReceipt: encode(receipt))
        switch result {
        case .valid(let transactionId):
            XCTAssertNil(transactionId)
        case .invalid(_):
            XCTAssert(false)
        }
    }

    ///Unlike ReceiptUtility, extraction refuses a receipt that does not verify.
    public func testVerifyAndExtractTransactionIdRejectsForeignReceipt() async throws {
        let foreignCreator = try ReceiptCreator.createReceiptCreator()
        let receipt = try foreignCreator.signReceipt(AppReceiptVerifierTests.receiptPayload("ProductionSandbox", AppReceiptVerifierTests.BUNDLE_ID, AppReceiptVerifierTests.RECEIPT_CREATION_DATE))

        let result = await AppReceiptVerifierTests.verifier(environment: .sandbox).verifyAndExtractTransactionId(encodedReceipt: encode(receipt))
        switch result {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.VERIFICATION_FAILURE, error)
        }
    }

    private static func verifier(_ creator: ReceiptCreator = receiptCreator, environment: AppStoreEnvironment, bundleId: String = BUNDLE_ID, enableOnlineChecks: Bool = false) -> AppReceiptVerifier {
        return try! AppReceiptVerifier(rootCertificates: [creator.rootCertificate], bundleId: bundleId, environment: environment, enableOnlineChecks: enableOnlineChecks)
    }

    private static func receiptPayload(_ receiptType: String, _ bundleId: String, _ creationDate: String) -> [UInt8] {
        return ReceiptCreator.attributeSet()
            .string(0, receiptType)
            .string(2, bundleId)
            .string(3, APP_VERSION)
            .raw(4, OPAQUE_VALUE)
            .raw(5, SHA1_HASH)
            .date(12, creationDate)
            .date(18, ORIGINAL_PURCHASE_DATE)
            .string(19, ORIGINAL_APP_VERSION)
            .date(21, EXPIRATION_DATE)
            .raw(9999, UNKNOWN_RECEIPT_ATTRIBUTE_VALUE)
            .raw(17, consumablePurchase())
            .raw(17, subscriptionPurchase())
            .build()
    }

    private static func consumablePurchase() -> [UInt8] {
        return ReceiptCreator.attributeSet()
            .integer(1701, 1)
            .string(1702, CONSUMABLE_PRODUCT_ID)
            .string(1703, "70000000000001")
            .date(1704, CONSUMABLE_PURCHASE_DATE)
            .string(1705, "70000000000001")
            .date(1706, CONSUMABLE_ORIGINAL_PURCHASE_DATE)
            .date(1708, "")
            .integer(1711, 42)
            .date(1712, "")
            .integer(1719, 0)
            .raw(1799, UNKNOWN_IN_APP_ATTRIBUTE_VALUE)
            .build()
    }

    private static func subscriptionPurchase() -> [UInt8] {
        return ReceiptCreator.attributeSet()
            .integer(1701, 1)
            .string(1702, SUBSCRIPTION_PRODUCT_ID)
            .string(1703, "70000000000002")
            .date(1704, SUBSCRIPTION_PURCHASE_DATE)
            .string(1705, "70000000000002")
            .date(1706, SUBSCRIPTION_PURCHASE_DATE)
            .date(1708, SUBSCRIPTION_EXPIRES_DATE)
            .integer(1711, 12345)
            .date(1712, SUBSCRIPTION_CANCELLATION_DATE)
            .integer(1719, 1)
            .build()
    }

    private func validReceipt(_ result: VerificationResult<AppReceipt>) throws -> AppReceipt {
        switch result {
        case .valid(let receipt):
            return receipt
        case .invalid(let error):
            XCTFail("Expected a valid receipt, got \(error)")
            throw XCTSkip("Expected a valid receipt, got \(error)")
        }
    }

    private func assertInvalid<T>(_ expected: VerificationError, _ result: VerificationResult<T>) {
        switch result {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(expected, error)
        }
    }

    private func encode(_ receipt: Data) -> String {
        return receipt.base64EncodedString()
    }

    private func derEncodedUTF8String(_ value: String) -> Data {
        var serializer = DER.Serializer()
        try! serializer.serialize(ASN1UTF8String(value))
        return Data(serializer.serializedBytes)
    }

    private func rfc3339(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    private func indexOf(_ haystack: Data, _ needle: [UInt8]) throws -> Data.Index {
        guard let range = haystack.range(of: Data(needle)) else {
            throw XCTSkip("Expected bytes not found in the receipt")
        }
        return range.lowerBound
    }
}
