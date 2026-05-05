// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

final class SignedModelTests: XCTestCase {
    
    public func testNotificationDecoding() async throws {
        let signedNotification = TestingUtility.createSignedDataFromJson("resources/models/signedNotification.json")

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification)
        
        guard case .valid(let notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.subscribed, notification.notificationType)
        XCTAssertEqual("SUBSCRIBED", notification.rawNotificationType)
        XCTAssertEqual(Subtype.initialBuy, notification.subtype)
        XCTAssertEqual("INITIAL_BUY", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), notification.signedDate)
        XCTAssertNotNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNil(notification.externalPurchaseToken)
        XCTAssertEqual(AppStoreEnvironment.localTesting, notification.data!.environment)
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
        let signedNotification = TestingUtility.createSignedDataFromJson("resources/models/signedConsumptionRequestNotification.json")

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
        XCTAssertEqual(AppStoreEnvironment.localTesting, notification.data!.environment)
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
        let signedNotification = TestingUtility.createSignedDataFromJson("resources/models/signedSummaryNotification.json")

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification)
        
        guard case .valid(let notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.renewalExtension, notification.notificationType)
        XCTAssertEqual("RENEWAL_EXTENSION", notification.rawNotificationType)
        XCTAssertEqual(Subtype.summary, notification.subtype)
        XCTAssertEqual("SUMMARY", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), notification.signedDate)
        XCTAssertNil(notification.data)
        XCTAssertNotNil(notification.summary)
        XCTAssertNil(notification.externalPurchaseToken)
        XCTAssertEqual(AppStoreEnvironment.localTesting, notification.summary!.environment)
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
        let signedNotification = TestingUtility.createSignedDataFromJson("resources/models/signedExternalPurchaseTokenNotification.json")

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification) { bundleId, appAppleId, environment in
            XCTAssertEqual("com.example", bundleId)
            XCTAssertEqual(55555, appAppleId)
            XCTAssertEqual(.production, environment)
            return nil
        }
        
        guard case .valid(let notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.externalPurchaseToken, notification.notificationType)
        XCTAssertEqual("EXTERNAL_PURCHASE_TOKEN", notification.rawNotificationType)
        XCTAssertEqual(Subtype.unreported, notification.subtype)
        XCTAssertEqual("UNREPORTED", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), notification.signedDate)
        XCTAssertNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNotNil(notification.externalPurchaseToken)
        XCTAssertEqual("b2158121-7af9-49d4-9561-1f588205523e", notification.externalPurchaseToken!.externalPurchaseId)
        XCTAssertEqual(1698148950000, notification.externalPurchaseToken!.tokenCreationDate)
        XCTAssertEqual(55555, notification.externalPurchaseToken!.appAppleId)
        XCTAssertEqual("com.example", notification.externalPurchaseToken!.bundleId)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }
    
    public func testExternalPurchaseTokenSandboxNotificationDecoding() async throws {
        let signedNotification = TestingUtility.createSignedDataFromJson("resources/models/signedExternalPurchaseTokenSandboxNotification.json")

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification) { bundleId, appAppleId, environment in
            XCTAssertEqual("com.example", bundleId)
            XCTAssertEqual(55555, appAppleId)
            XCTAssertEqual(.sandbox, environment)
            return nil
        }
        
        guard case .valid(let notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.externalPurchaseToken, notification.notificationType)
        XCTAssertEqual("EXTERNAL_PURCHASE_TOKEN", notification.rawNotificationType)
        XCTAssertEqual(Subtype.unreported, notification.subtype)
        XCTAssertEqual("UNREPORTED", notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), notification.signedDate)
        XCTAssertNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNotNil(notification.externalPurchaseToken)
        XCTAssertEqual("SANDBOX_b2158121-7af9-49d4-9561-1f588205523e", notification.externalPurchaseToken!.externalPurchaseId)
        XCTAssertEqual(1698148950000, notification.externalPurchaseToken!.tokenCreationDate)
        XCTAssertEqual(55555, notification.externalPurchaseToken!.appAppleId)
        XCTAssertEqual("com.example", notification.externalPurchaseToken!.bundleId)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }
    
    public func testTransactionDecoding() async throws {
        let signedTransaction = TestingUtility.createSignedDataFromJson("resources/models/signedTransaction.json")

        let verifiedTransaction = await TestingUtility.getSignedDataVerifier().verifyAndDecodeTransaction(signedTransaction: signedTransaction)

        guard case .valid(let transaction) = verifiedTransaction else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual("12345", transaction.originalTransactionId)
        XCTAssertEqual("23456", transaction.transactionId)
        XCTAssertEqual("34343", transaction.webOrderLineItemId)
        XCTAssertEqual("com.example", transaction.bundleId)
        XCTAssertEqual("com.example.product", transaction.productId)
        XCTAssertEqual("55555", transaction.subscriptionGroupIdentifier)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148800), transaction.originalPurchaseDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), transaction.purchaseDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148950), transaction.revocationDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698149000), transaction.expiresDate)
        XCTAssertEqual(1, transaction.quantity)
        XCTAssertEqual(ProductType.autoRenewableSubscription, transaction.type)
        XCTAssertEqual("Auto-Renewable Subscription", transaction.rawType)
        XCTAssertEqual(UUID(uuidString: "7e3fb20b-4cdb-47cc-936d-99d65f608138"), transaction.appAccountToken)
        XCTAssertEqual(InAppOwnershipType.purchased, transaction.inAppOwnershipType)
        XCTAssertEqual("PURCHASED", transaction.rawInAppOwnershipType)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), transaction.signedDate)
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
        XCTAssertEqual(AppStoreEnvironment.localTesting, transaction.environment)
        XCTAssertEqual("LocalTesting", transaction.rawEnvironment)
        XCTAssertEqual(10990, transaction.price)
        XCTAssertEqual("USD", transaction.currency)
        XCTAssertEqual(OfferDiscountType.payAsYouGo, transaction.offerDiscountType)
        XCTAssertEqual("PAY_AS_YOU_GO", transaction.rawOfferDiscountType)
        XCTAssertEqual("71134", transaction.appTransactionId)
        XCTAssertEqual("P1Y", transaction.offerPeriod)
        XCTAssertNotNil(transaction.advancedCommerceInfo)
        let info = transaction.advancedCommerceInfo!
        XCTAssertNotNil(info.descriptors)
        XCTAssertEqual("Premium Plan", info.descriptors!.description)
        XCTAssertEqual("Premium", info.descriptors!.displayName)
        XCTAssertEqual(1500, info.estimatedTax)
        XCTAssertEqual(AdvancedCommercePeriod.p1M, info.period)
        XCTAssertEqual("P1M", info.rawPeriod)
        XCTAssertEqual("ref-12345", info.requestReferenceId)
        XCTAssertEqual("TAX_CODE_1", info.taxCode)
        XCTAssertEqual(8490, info.taxExclusivePrice)
        XCTAssertEqual("0.15", info.taxRate)
        XCTAssertNotNil(info.items)
        XCTAssertEqual(1, info.items!.count)
        let acItem = info.items![0]
        XCTAssertEqual("com.example.sku.premium", acItem.sku)
        XCTAssertEqual("Premium feature", acItem.description)
        XCTAssertEqual("Premium Feature", acItem.displayName)
        XCTAssertEqual(9990, acItem.price)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698149200), acItem.revocationDate)
        XCTAssertNotNil(acItem.refunds)
        XCTAssertEqual(1, acItem.refunds!.count)
        let refund = acItem.refunds![0]
        XCTAssertEqual(5000, refund.refundAmount)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698149100), refund.refundDate)
        XCTAssertEqual(AdvancedCommerceRefundReason.fulfillmentIssue, refund.refundReason)
        XCTAssertEqual("FULFILLMENT_ISSUE", refund.rawRefundReason)
        XCTAssertEqual(AdvancedCommerceRefundType.prorated, refund.refundType)
        XCTAssertEqual("PRORATED", refund.rawRefundType)
        XCTAssertEqual(BillingPlanType.monthly, transaction.billingPlanType)
        XCTAssertEqual("MONTHLY", transaction.rawBillingPlanType)
        XCTAssertNotNil(transaction.commitmentInfo)
        let txnCommitment = transaction.commitmentInfo!
        XCTAssertEqual(3, txnCommitment.billingPeriodNumber)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698150000), txnCommitment.commitmentExpiresDate)
        XCTAssertEqual(119880, txnCommitment.commitmentPrice)
        XCTAssertEqual(12, txnCommitment.totalBillingPeriods)
        TestingUtility.confirmCodableInternallyConsistent(transaction)
    }

    public func testTransactionWithRevocationDecoding() async throws {
        let signedTransaction = TestingUtility.createSignedDataFromJson("resources/models/signedTransactionWithRevocation.json")

        let verifiedTransaction = await TestingUtility.getSignedDataVerifier().verifyAndDecodeTransaction(signedTransaction: signedTransaction)

        guard case .valid(let transaction) = verifiedTransaction else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual("12345", transaction.originalTransactionId)
        XCTAssertEqual("23456", transaction.transactionId)
        XCTAssertEqual("34343", transaction.webOrderLineItemId)
        XCTAssertEqual("com.example", transaction.bundleId)
        XCTAssertEqual("com.example.product", transaction.productId)
        XCTAssertEqual("55555", transaction.subscriptionGroupIdentifier)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148800), transaction.originalPurchaseDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), transaction.purchaseDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148950), transaction.revocationDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698149000), transaction.expiresDate)
        XCTAssertEqual(1, transaction.quantity)
        XCTAssertEqual(ProductType.autoRenewableSubscription, transaction.type)
        XCTAssertEqual("Auto-Renewable Subscription", transaction.rawType)
        XCTAssertEqual(UUID(uuidString: "7e3fb20b-4cdb-47cc-936d-99d65f608138"), transaction.appAccountToken)
        XCTAssertEqual(InAppOwnershipType.purchased, transaction.inAppOwnershipType)
        XCTAssertEqual("PURCHASED", transaction.rawInAppOwnershipType)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), transaction.signedDate)
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
        XCTAssertEqual(AppStoreEnvironment.localTesting, transaction.environment)
        XCTAssertEqual("LocalTesting", transaction.rawEnvironment)
        XCTAssertEqual(10990, transaction.price)
        XCTAssertEqual("USD", transaction.currency)
        XCTAssertEqual(OfferDiscountType.payAsYouGo, transaction.offerDiscountType)
        XCTAssertEqual("PAY_AS_YOU_GO", transaction.rawOfferDiscountType)
        XCTAssertEqual("71134", transaction.appTransactionId)
        XCTAssertEqual("P1Y", transaction.offerPeriod)
        XCTAssertEqual(RevocationType.refundProrated, transaction.revocationType)
        XCTAssertEqual("REFUND_PRORATED", transaction.rawRevocationType)
        XCTAssertEqual(50000, transaction.revocationPercentage)
        TestingUtility.confirmCodableInternallyConsistent(transaction)
    }

    public func testRenewalInfoDecoding() async throws {
        let signedRenewalInfo = TestingUtility.createSignedDataFromJson("resources/models/signedRenewalInfo.json")

        let verifiedRenewalInfo = await TestingUtility.getSignedDataVerifier().verifyAndDecodeRenewalInfo(signedRenewalInfo: signedRenewalInfo)
        
        guard case .valid(let renewalInfo) = verifiedRenewalInfo else {
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
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), renewalInfo.gracePeriodExpiresDate)
        XCTAssertEqual(OfferType.promotionalOffer, renewalInfo.offerType)
        XCTAssertEqual(2, renewalInfo.rawOfferType)
        XCTAssertEqual("abc.123", renewalInfo.offerIdentifier)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148800), renewalInfo.signedDate)
        XCTAssertEqual(AppStoreEnvironment.localTesting, renewalInfo.environment)
        XCTAssertEqual("LocalTesting", renewalInfo.rawEnvironment)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148800), renewalInfo.recentSubscriptionStartDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148850), renewalInfo.renewalDate)
        XCTAssertEqual(9990, renewalInfo.renewalPrice)
        XCTAssertEqual("USD", renewalInfo.currency)
        XCTAssertEqual(OfferDiscountType.payAsYouGo, renewalInfo.offerDiscountType)
        XCTAssertEqual("PAY_AS_YOU_GO", renewalInfo.rawOfferDiscountType)
        XCTAssertEqual(["eligible1", "eligible2"], renewalInfo.eligibleWinBackOfferIds)
        XCTAssertEqual(UUID(uuidString: "7e3fb20b-4cdb-47cc-936d-99d65f608138"), renewalInfo.appAccountToken)
        XCTAssertEqual("71134", renewalInfo.appTransactionId)
        XCTAssertEqual("P1Y", renewalInfo.offerPeriod)
        XCTAssertNotNil(renewalInfo.advancedCommerceInfo)
        let acInfo = renewalInfo.advancedCommerceInfo!
        XCTAssertEqual("token-abc-123", acInfo.consistencyToken)
        XCTAssertNotNil(acInfo.descriptors)
        XCTAssertEqual("Premium Plan", acInfo.descriptors!.description)
        XCTAssertEqual("Premium", acInfo.descriptors!.displayName)
        XCTAssertEqual(AdvancedCommercePeriod.p1M, acInfo.period)
        XCTAssertEqual("P1M", acInfo.rawPeriod)
        XCTAssertEqual("ref-12345", acInfo.requestReferenceId)
        XCTAssertEqual("TAX_CODE_1", acInfo.taxCode)
        XCTAssertNotNil(acInfo.items)
        XCTAssertEqual(1, acInfo.items!.count)
        let item = acInfo.items![0]
        XCTAssertEqual("com.example.sku.premium", item.sku)
        XCTAssertEqual("Premium feature", item.description)
        XCTAssertEqual("Premium Feature", item.displayName)
        XCTAssertEqual(9990, item.price)
        XCTAssertNotNil(item.priceIncreaseInfo)
        XCTAssertEqual(["com.example.sku.1", "com.example.sku.2"], item.priceIncreaseInfo!.dependentSKUs)
        XCTAssertEqual(12990, item.priceIncreaseInfo!.price)
        XCTAssertEqual(AdvancedCommercePriceIncreaseInfoStatus.pending, item.priceIncreaseInfo!.status)
        XCTAssertEqual("PENDING", item.priceIncreaseInfo!.rawStatus)
        XCTAssertNotNil(renewalInfo.commitmentInfo)
        let commitment = renewalInfo.commitmentInfo!
        XCTAssertEqual("com.example.product.commitment", commitment.commitmentAutoRenewProductId)
        XCTAssertEqual(AutoRenewStatus.on, commitment.commitmentAutoRenewStatus)
        XCTAssertEqual(1, commitment.rawCommitmentAutoRenewStatus)
        XCTAssertEqual(RenewalBillingPlanType.monthly, commitment.commitmentRenewalBillingPlanType)
        XCTAssertEqual("MONTHLY", commitment.rawCommitmentRenewalBillingPlanType)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698149500), commitment.commitmentRenewalDate)
        XCTAssertEqual(9990, commitment.commitmentRenewalPrice)
        XCTAssertEqual(RenewalBillingPlanType.monthly, renewalInfo.renewalBillingPlanType)
        XCTAssertEqual("MONTHLY", renewalInfo.rawRenewalBillingPlanType)
        TestingUtility.confirmCodableInternallyConsistent(renewalInfo)
    }
    
    public func testAppTransactionDecoding() async throws {
        let signedAppTransaction = TestingUtility.createSignedDataFromJson("resources/models/appTransaction.json")

        let verifiedAppTransaction = await TestingUtility.getSignedDataVerifier().verifyAndDecodeAppTransaction(signedAppTransaction: signedAppTransaction)
    
        guard case .valid(let appTransaction) = verifiedAppTransaction else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(AppStoreEnvironment.localTesting, appTransaction.receiptType)
        XCTAssertEqual("LocalTesting", appTransaction.rawReceiptType)
        XCTAssertEqual(531412, appTransaction.appAppleId)
        XCTAssertEqual("com.example", appTransaction.bundleId)
        XCTAssertEqual("1.2.3", appTransaction.applicationVersion)
        XCTAssertEqual(512, appTransaction.versionExternalIdentifier)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), appTransaction.receiptCreationDate)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148800), appTransaction.originalPurchaseDate)
        XCTAssertEqual("1.1.2", appTransaction.originalApplicationVersion)
        XCTAssertEqual("device_verification_value", appTransaction.deviceVerification)
        XCTAssertEqual(UUID(uuidString: "48ccfa42-7431-4f22-9908-7e88983e105a"), appTransaction.deviceVerificationNonce)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148700), appTransaction.preorderDate)
        XCTAssertEqual("71134", appTransaction.appTransactionId)
        XCTAssertEqual(PurchasePlatform.iOS, appTransaction.originalPlatform)
        XCTAssertEqual("iOS", appTransaction.rawOriginalPlatform)
        TestingUtility.confirmCodableInternallyConsistent(appTransaction)
    }

    public func testRealtimeRequestDecoding() async throws {
        let signedRealtimeRequest = TestingUtility.createSignedDataFromJson("resources/models/decodedRealtimeRequest.json")

        let verifiedRequest = await TestingUtility.getSignedDataVerifier().verifyAndDecodeRealtimeRequest(signedPayload: signedRealtimeRequest)

        guard case .valid(let request) = verifiedRequest else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual("99371282", request.originalTransactionId)
        XCTAssertEqual(531412, request.appAppleId)
        XCTAssertEqual("com.example.product", request.productId)
        XCTAssertEqual("en-US", request.userLocale)
        XCTAssertEqual(UUID(uuidString: "3db5c98d-8acf-4e29-831e-8e1f82f9f6e9"), request.requestIdentifier)
        XCTAssertEqual(AppStoreEnvironment.localTesting, request.environment)
        XCTAssertEqual("LocalTesting", request.rawEnvironment)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), request.signedDate)
        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testRescindConsentNotificationDecoding() async throws {
        let signedNotification = TestingUtility.createSignedDataFromJson("resources/models/signedRescindConsentNotification.json")

        let verifiedNotification = await TestingUtility.getSignedDataVerifier().verifyAndDecodeNotification(signedPayload: signedNotification)

        guard case .valid(let notification) = verifiedNotification else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(NotificationTypeV2.rescindConsent, notification.notificationType)
        XCTAssertEqual("RESCIND_CONSENT", notification.rawNotificationType)
        XCTAssertNil(notification.subtype)
        XCTAssertNil(notification.rawSubtype)
        XCTAssertEqual("002e14d5-51f5-4503-b5a8-c3a1af68eb20", notification.notificationUUID)
        XCTAssertEqual("2.0", notification.version)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), notification.signedDate)
        XCTAssertNil(notification.data)
        XCTAssertNil(notification.summary)
        XCTAssertNil(notification.externalPurchaseToken)
        XCTAssertNotNil(notification.appData)
        XCTAssertEqual(AppStoreEnvironment.localTesting, notification.appData!.environment)
        XCTAssertEqual("LocalTesting", notification.appData!.rawEnvironment)
        XCTAssertEqual(41234, notification.appData!.appAppleId)
        XCTAssertEqual("com.example", notification.appData!.bundleId)
        XCTAssertEqual("signed_app_transaction_info_value", notification.appData!.signedAppTransactionInfo)
        TestingUtility.confirmCodableInternallyConsistent(notification)
    }

    public func testAppData() throws {
        let json = TestingUtility.readFile("resources/models/appData.json")
        let jsonDecoder = getJsonDecoder()

        let appData = try jsonDecoder.decode(AppData.self, from: json.data(using: .utf8)!)

        XCTAssertEqual(987654321, appData.appAppleId)
        XCTAssertEqual("com.example", appData.bundleId)
        XCTAssertEqual(AppStoreEnvironment.sandbox, appData.environment)
        XCTAssertEqual("Sandbox", appData.rawEnvironment)
        XCTAssertEqual("signed-app-transaction-info", appData.signedAppTransactionInfo)
    }

    // Xcode-generated dates are not well formed, therefore we only compare to ms precision
    private func compareXcodeDates(_ first: Date, _ second: Date?) {
        XCTAssertEqual(floor((first.timeIntervalSince1970 * 1000)), floor(((second?.timeIntervalSince1970 ?? 0.0) * 1000)))
    }
}
