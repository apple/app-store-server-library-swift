// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

@testable import AppStoreServerLibrary
import JWTKit
import XCTest

final class SignedModelTests: XCTestCase {
    public func testNotificationDecoding() async throws {
        let signedNotification = try await TestingUtility.createSignedDataFromJson("resources/models/signedNotification.json", as: ResponseBodyV2DecodedPayload.self)

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification)

        guard case let .valid(notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.subscribed, notification.notificationType)
        XCTAssertEqual("SUBSCRIBED", notification.rawNotificationType)
        XCTAssertEqual(Subtype.initialBuy, notification.subtype)
        XCTAssertEqual("INITIAL_BUY", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), notification.signedDate)
        XCTAssertNotNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNil(notification.externalPurchaseToken)
        XCTAssertEqual(Environment.localTesting, notification.data!.environment)
        XCTAssertEqual("LocalTesting", notification.data!.rawEnvironment)
        XCTAssertEqual(41234, notification.data!.appAppleId)
        XCTAssertEqual("com.example", notification.data!.bundleId)
        XCTAssertEqual("1.2.3", notification.data!.bundleVersion)
        XCTAssertEqual("signed_transaction_info_value", notification.data!.signedTransactionInfo)
        XCTAssertEqual("signed_renewal_info_value", notification.data!.signedRenewalInfo)
        XCTAssertEqual(Status.active, notification.data!.status)
        XCTAssertEqual(1, notification.data!.rawStatus)
        XCTAssertNil(notification.data!.consumptionRequestReason)
        XCTAssertNil(notification.data!.rawConsumptionRequestReason)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }

    public func testConsumptionRequestNotificationDecoding() async throws {
        let signedNotification = try await TestingUtility.createSignedDataFromJson("resources/models/signedConsumptionRequestNotification.json", as: ResponseBodyV2DecodedPayload.self)

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification)
        
        guard case .valid(let notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.consumptionRequest, notification.notificationType)
        XCTAssertEqual("CONSUMPTION_REQUEST", notification.rawNotificationType)
        XCTAssertNil(notification.subtype)
        XCTAssertNil(notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), notification.signedDate)
        XCTAssertNotNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNil(notification.externalPurchaseToken)
        XCTAssertEqual(Environment.localTesting, notification.data!.environment)
        XCTAssertEqual("LocalTesting", notification.data!.rawEnvironment)
        XCTAssertEqual(41234, notification.data!.appAppleId)
        XCTAssertEqual("com.example", notification.data!.bundleId)
        XCTAssertEqual("1.2.3", notification.data!.bundleVersion)
        XCTAssertEqual("signed_transaction_info_value", notification.data!.signedTransactionInfo)
        XCTAssertEqual("signed_renewal_info_value", notification.data!.signedRenewalInfo)
        XCTAssertEqual(Status.active, notification.data!.status)
        XCTAssertEqual(1, notification.data!.rawStatus)
        XCTAssertEqual(ConsumptionRequestReason.unintendedPurchase, notification.data!.consumptionRequestReason)
        XCTAssertEqual("UNINTENDED_PURCHASE", notification.data!.rawConsumptionRequestReason)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }

    public func testSummaryNotificationDecoding() async throws {
        let signedNotification = try await TestingUtility.createSignedDataFromJson("resources/models/signedSummaryNotification.json", as: ResponseBodyV2DecodedPayload.self)

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification)

        guard case let .valid(notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.renewalExtension, notification.notificationType)
        XCTAssertEqual("RENEWAL_EXTENSION", notification.rawNotificationType)
        XCTAssertEqual(Subtype.summary, notification.subtype)
        XCTAssertEqual("SUMMARY", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), notification.signedDate)
        XCTAssertNil(notification.data)
        XCTAssertNotNil(notification.summary)
        XCTAssertNil(notification.externalPurchaseToken)
        XCTAssertEqual(Environment.localTesting, notification.summary!.environment)
        XCTAssertEqual("LocalTesting", notification.summary!.rawEnvironment)
        XCTAssertEqual(41234, notification.summary!.appAppleId)
        XCTAssertEqual("com.example", notification.summary!.bundleId)
        XCTAssertEqual("com.example.product", notification.summary!.productId)
        XCTAssertEqual("efb27071-45a4-4aca-9854-2a1e9146f265", notification.summary!.requestIdentifier)
        XCTAssertEqual(["CAN", "USA", "MEX"], notification.summary!.storefrontCountryCodes)
        XCTAssertEqual(5, notification.summary!.succeededCount)
        XCTAssertEqual(2, notification.summary!.failedCount)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }

    public func testExternalPurchaseTokenNotificationDecoding() async throws {
        let signedNotification = try await TestingUtility.createSignedDataFromJson("resources/models/signedExternalPurchaseTokenNotification.json", as: ResponseBodyV2DecodedPayload.self)

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification) { bundleId, appAppleId, environment in
            XCTAssertEqual("com.example", bundleId)
            XCTAssertEqual(55555, appAppleId)
            XCTAssertEqual(.production, environment)
            return nil
        }

        guard case let .valid(notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.externalPurchaseToken, notification.notificationType)
        XCTAssertEqual("EXTERNAL_PURCHASE_TOKEN", notification.rawNotificationType)
        XCTAssertEqual(Subtype.unreported, notification.subtype)
        XCTAssertEqual("UNREPORTED", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), notification.signedDate)
        XCTAssertNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNotNil(notification.externalPurchaseToken)
        XCTAssertEqual("b2158121-7af9-49d4-9561-1f588205523e", notification.externalPurchaseToken!.externalPurchaseId)
        XCTAssertEqual(1_698_148_950_000, notification.externalPurchaseToken!.tokenCreationDate)
        XCTAssertEqual(55555, notification.externalPurchaseToken!.appAppleId)
        XCTAssertEqual("com.example", notification.externalPurchaseToken!.bundleId)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }

    public func testExternalPurchaseTokenSandboxNotificationDecoding() async throws {
        let signedNotification = try await TestingUtility.createSignedDataFromJson("resources/models/signedExternalPurchaseTokenSandboxNotification.json", as: ResponseBodyV2DecodedPayload.self)

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification) { bundleId, appAppleId, environment in
            XCTAssertEqual("com.example", bundleId)
            XCTAssertEqual(55555, appAppleId)
            XCTAssertEqual(.sandbox, environment)
            return nil
        }

        guard case let .valid(notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.externalPurchaseToken, notification.notificationType)
        XCTAssertEqual("EXTERNAL_PURCHASE_TOKEN", notification.rawNotificationType)
        XCTAssertEqual(Subtype.unreported, notification.subtype)
        XCTAssertEqual("UNREPORTED", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), notification.signedDate)
        XCTAssertNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNotNil(notification.externalPurchaseToken)
        XCTAssertEqual("SANDBOX_b2158121-7af9-49d4-9561-1f588205523e", notification.externalPurchaseToken!.externalPurchaseId)
        XCTAssertEqual(1_698_148_950_000, notification.externalPurchaseToken!.tokenCreationDate)
        XCTAssertEqual(55555, notification.externalPurchaseToken!.appAppleId)
        XCTAssertEqual("com.example", notification.externalPurchaseToken!.bundleId)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }

    public func testTransactionDecoding() async throws {
        let signedTransaction = try await TestingUtility.createSignedDataFromJson("resources/models/signedTransaction.json", as: JWSTransactionDecodedPayload.self)

        let verifiedTransaction = await TestingUtility.getSignedDataVerifier().verifyAndDecodeTransaction(signedTransaction: signedTransaction)

        guard case let .valid(transaction) = verifiedTransaction else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual("12345", transaction.originalTransactionId)
        XCTAssertEqual("23456", transaction.transactionId)
        XCTAssertEqual("34343", transaction.webOrderLineItemId)
        XCTAssertEqual("com.example", transaction.bundleId)
        XCTAssertEqual("com.example.product", transaction.productId)
        XCTAssertEqual("55555", transaction.subscriptionGroupIdentifier)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_800), transaction.originalPurchaseDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), transaction.purchaseDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_950), transaction.revocationDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_149_000), transaction.expiresDate)
        XCTAssertEqual(1, transaction.quantity)
        XCTAssertEqual(ProductType.autoRenewableSubscription, transaction.type)
        XCTAssertEqual("Auto-Renewable Subscription", transaction.rawType)
        XCTAssertEqual(UUID(uuidString: "7e3fb20b-4cdb-47cc-936d-99d65f608138"), transaction.appAccountToken)
        XCTAssertEqual(InAppOwnershipType.purchased, transaction.inAppOwnershipType)
        XCTAssertEqual("PURCHASED", transaction.rawInAppOwnershipType)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), transaction.signedDate)
        XCTAssertEqual(RevocationReason.refundedDueToIssue, transaction.revocationReason)
        XCTAssertEqual(1, transaction.rawRevocationReason)
        XCTAssertEqual("abc.123", transaction.offerIdentifier)
        XCTAssertEqual(true, transaction.isUpgraded)
        XCTAssertEqual(OfferType.introductoryOffer, transaction.offerType)
        XCTAssertEqual(1, transaction.rawOfferType)
        XCTAssertEqual("USA", transaction.storefront)
        XCTAssertEqual("143441", transaction.storefrontId)
        XCTAssertEqual(TransactionReason.purchase, transaction.transactionReason)
        XCTAssertEqual("PURCHASE", transaction.rawTransactionReason)
        XCTAssertEqual(Environment.localTesting, transaction.environment)
        XCTAssertEqual("LocalTesting", transaction.rawEnvironment)
        XCTAssertEqual(10990, transaction.price)
        XCTAssertEqual("USD", transaction.currency)
        XCTAssertEqual(OfferDiscountType.payAsYouGo, transaction.offerDiscountType)
        XCTAssertEqual("PAY_AS_YOU_GO", transaction.rawOfferDiscountType)
        TestingUtility.confirmCodableInternallyConsistent(transaction)
    }

    public func testRenewalInfoDecoding() async throws {
        let signedRenewalInfo = try await TestingUtility.createSignedDataFromJson("resources/models/signedRenewalInfo.json", as: JWSRenewalInfoDecodedPayload.self)

        let verifiedRenewalInfo = await TestingUtility.getSignedDataVerifier().verifyAndDecodeRenewalInfo(signedRenewalInfo: signedRenewalInfo)

        guard case let .valid(renewalInfo) = verifiedRenewalInfo else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(ExpirationIntent.customerCancelled, renewalInfo.expirationIntent)
        XCTAssertEqual(1, renewalInfo.rawExpirationIntent)
        XCTAssertEqual("12345", renewalInfo.originalTransactionId)
        XCTAssertEqual("com.example.product.2", renewalInfo.autoRenewProductId)
        XCTAssertEqual("com.example.product", renewalInfo.productId)
        XCTAssertEqual(AutoRenewStatus.on, renewalInfo.autoRenewStatus)
        XCTAssertEqual(1, renewalInfo.rawAutoRenewStatus)
        XCTAssertEqual(true, renewalInfo.isInBillingRetryPeriod)
        XCTAssertEqual(PriceIncreaseStatus.customerHasNotResponded, renewalInfo.priceIncreaseStatus)
        XCTAssertEqual(0, renewalInfo.rawPriceIncreaseStatus)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), renewalInfo.gracePeriodExpiresDate)
        XCTAssertEqual(OfferType.promotionalOffer, renewalInfo.offerType)
        XCTAssertEqual(2, renewalInfo.rawOfferType)
        XCTAssertEqual("abc.123", renewalInfo.offerIdentifier)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_800), renewalInfo.signedDate)
        XCTAssertEqual(Environment.localTesting, renewalInfo.environment)
        XCTAssertEqual("LocalTesting", renewalInfo.rawEnvironment)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148800), renewalInfo.recentSubscriptionStartDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148850), renewalInfo.renewalDate)
        XCTAssertEqual(9990, renewalInfo.renewalPrice)
        XCTAssertEqual("USD", renewalInfo.currency)
        XCTAssertEqual(OfferDiscountType.payAsYouGo, renewalInfo.offerDiscountType)
        XCTAssertEqual("PAY_AS_YOU_GO", renewalInfo.rawOfferDiscountType)
        XCTAssertEqual(["eligible1", "eligible2"], renewalInfo.eligibleWinBackOfferIds)
        TestingUtility.confirmCodableInternallyConsistent(renewalInfo)
    }

    public func testAppTransactionDecoding() async throws {
        let signedAppTransaction = try await TestingUtility.createSignedDataFromJson("resources/models/appTransaction.json", as: AppTransaction.self)

        let verifiedAppTransaction = await TestingUtility.getSignedDataVerifier().verifyAndDecodeAppTransaction(signedAppTransaction: signedAppTransaction)

        guard case let .valid(appTransaction) = verifiedAppTransaction else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(Environment.localTesting, appTransaction.receiptType)
        XCTAssertEqual("LocalTesting", appTransaction.rawReceiptType)
        XCTAssertEqual(531_412, appTransaction.appAppleId)
        XCTAssertEqual("com.example", appTransaction.bundleId)
        XCTAssertEqual("1.2.3", appTransaction.applicationVersion)
        XCTAssertEqual(512, appTransaction.versionExternalIdentifier)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_900), appTransaction.receiptCreationDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1_698_148_800), appTransaction.originalPurchaseDate)
        XCTAssertEqual("1.1.2", appTransaction.originalApplicationVersion)
        XCTAssertEqual("device_verification_value", appTransaction.deviceVerification)
        XCTAssertEqual(UUID(uuidString: "48ccfa42-7431-4f22-9908-7e88983e105a"), appTransaction.deviceVerificationNonce)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148700), appTransaction.preorderDate)
        TestingUtility.confirmCodableInternallyConsistent(appTransaction)
    }

    // Xcode-generated dates are not well formed, therefore we only compare to ms precision
    private func compareXcodeDates(_ first: Date, _ second: Date?) {
        XCTAssertEqual(floor(first.timeIntervalSince1970 * 1000), floor((second?.timeIntervalSince1970 ?? 0.0) * 1000))
    }
}
