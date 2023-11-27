// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import X509

final class ReceiptUtilityTests: XCTestCase {
    
    private let APP_RECEIPT_EXPECTED_TRANSACTION_ID = "0"
    private let TRANSACTION_RECEIPT_EXPECTED_TRANSACTION_ID = "33993399"

    public func testXcodeAppReceiptExtractionWithNoTransactions() throws {
        let receipt = TestingUtility.readFile("resources/xcode/xcode-app-receipt-empty")

        let extractedTransactionId = ReceiptUtility.extractTransactionId(appReceipt: receipt)

        XCTAssertNil(extractedTransactionId)
    }

    public func testXcodeAppReceiptExtractionWithTransactions() throws {
        let receipt = TestingUtility.readFile("resources/xcode/xcode-app-receipt-with-transaction")

        let extractedTransactionId = ReceiptUtility.extractTransactionId(appReceipt: receipt)

        XCTAssertEqual(APP_RECEIPT_EXPECTED_TRANSACTION_ID, extractedTransactionId)
    }

    public func testTransactionReceiptExtraction() throws {
        let receipt = TestingUtility.readFile("resources/mock_signed_data/legacyTransaction")

        let extractedTransactionId = ReceiptUtility.extractTransactionId(transactionReceipt: receipt)

        XCTAssertEqual(TRANSACTION_RECEIPT_EXPECTED_TRANSACTION_ID, extractedTransactionId)
    }
}
