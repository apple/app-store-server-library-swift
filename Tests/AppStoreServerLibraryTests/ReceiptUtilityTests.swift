// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import X509
import SwiftASN1

final class ReceiptUtilityTests: XCTestCase {
    
    private let APP_RECEIPT_EXPECTED_TRANSACTION_ID = "0"
    private let TRANSACTION_RECEIPT_EXPECTED_TRANSACTION_ID = "33993399"

    public func testXcodeAppReceiptExtractionWithNoTransactions() throws {
        let receipt = TestingUtility.readFile("resources/xcode/xcode-app-receipt-empty")

        let extractedTransactionId = try ReceiptUtility.extractTransactionId(appReceipt: receipt)

        XCTAssertNil(extractedTransactionId)
    }

    public func testXcodeAppReceiptExtractionWithTransactions() throws {
        let receipt = TestingUtility.readFile("resources/xcode/xcode-app-receipt-with-transaction")

        let extractedTransactionId = try ReceiptUtility.extractTransactionId(appReceipt: receipt)

        XCTAssertEqual(APP_RECEIPT_EXPECTED_TRANSACTION_ID, extractedTransactionId)
    }

    public func testTransactionReceiptExtraction() throws {
        let receipt = TestingUtility.readFile("resources/mock_signed_data/legacyTransaction")

        let extractedTransactionId = try ReceiptUtility.extractTransactionId(transactionReceipt: receipt)

        XCTAssertEqual(TRANSACTION_RECEIPT_EXPECTED_TRANSACTION_ID, extractedTransactionId)
    }
    
    public func testAppReceiptExtractionReturnsFirstTransactionId() throws {
        let receipt = try createAppReceipt(inAppPurchases: [
            [(1703, "1111"), (1705, "9999")],
            [(1703, "2222"), (1705, "9999")],
        ])

        let extractedTransactionId = try ReceiptUtility.extractTransactionId(appReceipt: receipt)

        XCTAssertEqual("1111", extractedTransactionId)
    }
    
    public func testAppReceiptExtractionSkipsInAppPurchasesWithoutTransactionId() throws {
        let receipt = try createAppReceipt(inAppPurchases: [
            [(1702, "com.example.product")],
            [(1703, "3333")],
            [(1702, "com.example.product")],
        ])

        let extractedTransactionId = try ReceiptUtility.extractTransactionId(appReceipt: receipt)

        XCTAssertEqual("3333", extractedTransactionId)
    }
    
    public func testAppReceiptWithoutInAppPurchasesReturnsNil() throws {
        let receipt = try createAppReceipt(content: serializeReceiptAttributes([(2, utf8StringBytes("com.example"))]))

        XCTAssertNil(try ReceiptUtility.extractTransactionId(appReceipt: receipt))
    }

    public func testMalformedAppReceiptThrows() throws {
        assertThrows(try ReceiptUtility.extractTransactionId(appReceipt: "Not a receipt"), .invalidAppReceipt)
        assertThrows(try ReceiptUtility.extractTransactionId(appReceipt: Data("Not a receipt".utf8).base64EncodedString()), .invalidAppReceipt)
        let receiptContent = try serializeReceiptAttributes([(17, serializeReceiptAttributes([(1703, utf8StringBytes("1111"))]))])
        assertThrows(try ReceiptUtility.extractTransactionId(appReceipt: createAppReceipt(content: receiptContent, contentType: [1, 2, 840, 113549, 1, 7, 1])), .invalidAppReceipt)
        assertThrows(try ReceiptUtility.extractTransactionId(appReceipt: createAppReceipt(content: utf8StringBytes("Not a receipt"))), .invalidAppReceipt)
        assertThrows(try ReceiptUtility.extractTransactionId(appReceipt: createAppReceipt(content: serializeReceiptAttributes([(17, utf8StringBytes("Not a receipt"))]))), .invalidAppReceipt)
        var serializer = DER.Serializer()
        try serializer.serialize(1111)
        let integerTransactionId = try serializeReceiptAttributes([(17, serializeReceiptAttributes([(1703, serializer.serializedBytes)]))])
        assertThrows(try ReceiptUtility.extractTransactionId(appReceipt: createAppReceipt(content: integerTransactionId)), .invalidAppReceipt)
    }

    public func testTransactionReceiptWithoutTransactionIdReturnsNil() throws {
        let receipt = createTransactionReceipt(purchaseInfo: Data("{\n\t\"product-id\" = \"com.example\";\n}".utf8).base64EncodedString())

        XCTAssertNil(try ReceiptUtility.extractTransactionId(transactionReceipt: receipt))
    }

    public func testMalformedTransactionReceiptThrows() throws {
        assertThrows(try ReceiptUtility.extractTransactionId(transactionReceipt: "Not a receipt"), .invalidTransactionReceipt)
        assertThrows(try ReceiptUtility.extractTransactionId(transactionReceipt: Data("Not a receipt".utf8).base64EncodedString()), .invalidTransactionReceipt)
        assertThrows(try ReceiptUtility.extractTransactionId(transactionReceipt: createTransactionReceipt(purchaseInfo: "abc")), .invalidTransactionReceipt)
    }

    private func assertThrows<T>(_ expression: @autoclosure () throws -> T, _ expectedError: ReceiptUtility.ReceiptError, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try expression(), file: file, line: line) { error in
            XCTAssertEqual(expectedError, error as? ReceiptUtility.ReceiptError, file: file, line: line)
        }
    }

    private func createTransactionReceipt(purchaseInfo: String) -> String {
        return Data("{\n\t\"signature\" = \"c2lnbmF0dXJl\";\n\t\"purchase-info\" = \"\(purchaseInfo)\";\n}".utf8).base64EncodedString()
    }

    private func utf8StringBytes(_ value: String) throws -> [UInt8] {
        var serializer = DER.Serializer()
        try serializer.serialize(ASN1UTF8String(value))
        return serializer.serializedBytes
    }
    
    private func createAppReceipt(inAppPurchases: [[(Int64, String)]]) throws -> String {
        let inAppPurchaseReceipts = try inAppPurchases.map { attributes in
            try serializeReceiptAttributes(attributes.map { type, value in (type, try utf8StringBytes(value)) })
        }
        return try createAppReceipt(content: serializeReceiptAttributes(inAppPurchaseReceipts.map { (17, $0) }))
    }

    private func createAppReceipt(content: [UInt8], contentType: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 7, 2]) throws -> String {
        let dataOID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 7, 1]
        var serializer = DER.Serializer()
        try serializer.appendConstructedNode(identifier: .sequence) { serializer in
            try serializer.serialize(contentType)
            try serializer.appendConstructedNode(identifier: ASN1Identifier(tagWithNumber: 0, tagClass: .contextSpecific)) { serializer in
                try serializer.appendConstructedNode(identifier: .sequence) { serializer in
                    try serializer.serialize(1)
                    serializer.appendConstructedNode(identifier: .set) { _ in }
                    try serializer.appendConstructedNode(identifier: .sequence) { serializer in
                        try serializer.serialize(dataOID)
                        try serializer.appendConstructedNode(identifier: ASN1Identifier(tagWithNumber: 0, tagClass: .contextSpecific)) { serializer in
                            try serializer.serialize(ASN1OctetString(contentBytes: content[...]))
                        }
                    }
                }
            }
        }
        return Data(serializer.serializedBytes).base64EncodedString()
    }
    
    private func serializeReceiptAttributes(_ attributes: [(Int64, [UInt8])]) throws -> [UInt8] {
        var serializer = DER.Serializer()
        try serializer.appendConstructedNode(identifier: .set) { serializer in
            for (type, value) in attributes {
                try serializer.appendConstructedNode(identifier: .sequence) { serializer in
                    try serializer.serialize(type)
                    try serializer.serialize(1)
                    try serializer.serialize(ASN1OctetString(contentBytes: value[...]))
                }
            }
        }
        return serializer.serializedBytes
    }
}
