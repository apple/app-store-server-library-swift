// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

final class XcodeSignedDataVerifierTests: XCTestCase {
    
    private let XCODE_BUNDLE_ID = "com.example.naturelab.backyardbirds.example"

    public func testXcodeSignedAppTransaction() async throws {
        let verifier = TestingUtility.getSignedDataVerifier(.xcode, XCODE_BUNDLE_ID)
        let encodedAppTransaction = TestingUtility.readFile("resources/xcode/xcode-signed-app-transaction")

        let verifiedAppTransaction = await verifier.verifyAndDecodeAppTransaction(signedAppTransaction: encodedAppTransaction)
        
        guard case .valid(let appTransaction) = verifiedAppTransaction else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertNotNil(appTransaction)
        XCTAssertNil(appTransaction.appAppleId)
        XCTAssertEqual(XCODE_BUNDLE_ID, appTransaction.bundleId)
        XCTAssertEqual("1", appTransaction.applicationVersion)
        XCTAssertNil(appTransaction.versionExternalIdentifier)
        compareXcodeDates(Date(timeIntervalSince1970: -62135769600), appTransaction.originalPurchaseDate)
        XCTAssertEqual("1", appTransaction.originalApplicationVersion)
        XCTAssertEqual("cYUsXc53EbYc0pOeXG5d6/31LGHeVGf84sqSN0OrJi5u/j2H89WWKgS8N0hMsMlf", appTransaction.deviceVerification)
        XCTAssertEqual(UUID(uuidString: "48c8b92d-ce0d-4229-bedf-e61b4f9cfc92"), appTransaction.deviceVerificationNonce)
        XCTAssertNil(appTransaction.preorderDate)
        XCTAssertEqual(.xcode, appTransaction.environment)
        XCTAssertEqual("Xcode", appTransaction.rawEnvironment)
        confirmCodableInternallyConsistentForXcode(appTransaction)
    }

    public func testXcodeSignedTransaction() async throws {
        let verifier = TestingUtility.getSignedDataVerifier(.xcode, XCODE_BUNDLE_ID)
        let encodedTransaction = TestingUtility.readFile("resources/xcode/xcode-signed-transaction")

        let verifiedTransaction = await verifier.verifyAndDecodeTransaction(signedTransaction: encodedTransaction)

        guard case .valid(let transaction) = verifiedTransaction else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual("0", transaction.originalTransactionId)
        XCTAssertEqual("0", transaction.transactionId)
        XCTAssertEqual("0", transaction.webOrderLineItemId)
        XCTAssertEqual(XCODE_BUNDLE_ID, transaction.bundleId)
        XCTAssertEqual("pass.premium", transaction.productId)
        XCTAssertEqual("6F3A93AB", transaction.subscriptionGroupIdentifier)
        compareXcodeDates(Date(timeIntervalSince1970: 1697679936.049), transaction.purchaseDate)
        compareXcodeDates(Date(timeIntervalSince1970: 1697679936.049), transaction.originalPurchaseDate)
        compareXcodeDates(Date(timeIntervalSince1970: 1700358336.049), transaction.expiresDate)
        XCTAssertEqual(1, transaction.quantity)
        XCTAssertEqual(ProductType.autoRenewableSubscription, transaction.type)
        XCTAssertEqual("Auto-Renewable Subscription", transaction.rawType)
        XCTAssertNil(transaction.appAccountToken)
        XCTAssertEqual(InAppOwnershipType.purchased, transaction.inAppOwnershipType)
        XCTAssertEqual("PURCHASED", transaction.rawInAppOwnershipType)
        compareXcodeDates(Date(timeIntervalSince1970: 1697679936.056), transaction.signedDate)
        XCTAssertNil(transaction.revocationReason)
        XCTAssertNil(transaction.revocationDate)
        XCTAssertEqual(false, transaction.isUpgraded)
        XCTAssertEqual(OfferType.introductoryOffer, transaction.offerType)
        XCTAssertEqual(1, transaction.rawOfferType)
        XCTAssertNil(transaction.offerIdentifier)
        XCTAssertEqual(AppStoreEnvironment.xcode, transaction.environment)
        XCTAssertEqual("Xcode", transaction.rawEnvironment)
        XCTAssertEqual("USA", transaction.storefront)
        XCTAssertEqual("143441", transaction.storefrontId)
        XCTAssertEqual(TransactionReason.purchase, transaction.transactionReason)
        XCTAssertEqual("PURCHASE", transaction.rawTransactionReason)
        confirmCodableInternallyConsistentForXcode(transaction)
    }

    public func testXcodeSignedRenewalInfo() async throws {
        let verifier = TestingUtility.getSignedDataVerifier(.xcode, XCODE_BUNDLE_ID)
        let encodedRenewalInfo = TestingUtility.readFile("resources/xcode/xcode-signed-renewal-info")

        let verifiedRenewalInfo = await verifier.verifyAndDecodeRenewalInfo(signedRenewalInfo: encodedRenewalInfo)
        
        guard case .valid(let renewalInfo) = verifiedRenewalInfo else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertNil(renewalInfo.expirationIntent)
        XCTAssertEqual("0", renewalInfo.originalTransactionId)
        XCTAssertEqual("pass.premium", renewalInfo.autoRenewProductId)
        XCTAssertEqual("pass.premium", renewalInfo.productId)
        XCTAssertEqual(AutoRenewStatus.on, renewalInfo.autoRenewStatus)
        XCTAssertEqual(1, renewalInfo.rawAutoRenewStatus)
        XCTAssertNil(renewalInfo.isInBillingRetryPeriod)
        XCTAssertNil(renewalInfo.priceIncreaseStatus)
        XCTAssertNil(renewalInfo.gracePeriodExpiresDate)
        XCTAssertNil(renewalInfo.offerType)
        XCTAssertNil(renewalInfo.offerIdentifier)
        compareXcodeDates(Date(timeIntervalSince1970: 1697679936.711), renewalInfo.signedDate)
        XCTAssertEqual(AppStoreEnvironment.xcode, renewalInfo.environment)
        XCTAssertEqual("Xcode", renewalInfo.rawEnvironment)
        compareXcodeDates(Date(timeIntervalSince1970: 1697679936.049), renewalInfo.recentSubscriptionStartDate)
        compareXcodeDates(Date(timeIntervalSince1970: 1700358336.049), renewalInfo.renewalDate)
        confirmCodableInternallyConsistentForXcode(renewalInfo)
    }

    public func testXcodeSignedAppTransactionWithProductionEnvironment() async throws {
        let verifier = TestingUtility.getSignedDataVerifier(.production, XCODE_BUNDLE_ID)
        let encodedAppTransaction = TestingUtility.readFile("resources/xcode/xcode-signed-app-transaction")
        let verifiedAppTransaction = await verifier.verifyAndDecodeAppTransaction(signedAppTransaction: encodedAppTransaction)
        switch verifiedAppTransaction {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            // Without a valid x5c header this won't even pass formatting checks
            XCTAssertEqual(VerificationError.INVALID_JWT_FORMAT, error)
        }
    }
    
    // Xcode-generated dates are not well formed, therefore we only compare to ms precision
    private func compareXcodeDates(_ first: Date, _ second: Date?) {
        XCTAssertEqual(floor((first.timeIntervalSince1970 * 1000)), floor(((second?.timeIntervalSince1970 ?? 0.0) * 1000)))
    }
    
    private func confirmCodableInternallyConsistentForXcode<T>(_ codable: T) where T : Codable, T : Equatable {
        let type = type(of: codable)
        let encoder = JSONEncoder()
        // Xcode receipts contain a decimal value, we encode the value as encoded in those receipts
        encoder.dateEncodingStrategy = .millisecondsSince1970
        let parsedValue = try! getJsonDecoder().decode(type, from: encoder.encode(codable))
        XCTAssertEqual(parsedValue, codable)
    }
}
