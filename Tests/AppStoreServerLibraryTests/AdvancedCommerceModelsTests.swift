// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

final class AdvancedCommerceModelsTests: XCTestCase {

    public func testAdvancedCommercePeriod() throws {
        XCTAssertEqual("P1W", AdvancedCommercePeriod.p1W.rawValue)
        XCTAssertEqual("P1M", AdvancedCommercePeriod.p1M.rawValue)
        XCTAssertEqual("P2M", AdvancedCommercePeriod.p2M.rawValue)
        XCTAssertEqual("P3M", AdvancedCommercePeriod.p3M.rawValue)
        XCTAssertEqual("P6M", AdvancedCommercePeriod.p6M.rawValue)
        XCTAssertEqual("P1Y", AdvancedCommercePeriod.p1Y.rawValue)

        XCTAssertEqual(AdvancedCommercePeriod.p1W, AdvancedCommercePeriod(rawValue: "P1W"))
        XCTAssertEqual(AdvancedCommercePeriod.p1M, AdvancedCommercePeriod(rawValue: "P1M"))
        XCTAssertEqual(AdvancedCommercePeriod.p1Y, AdvancedCommercePeriod(rawValue: "P1Y"))
        XCTAssertNil(AdvancedCommercePeriod(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePeriod.p1W)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePeriod.p1M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePeriod.p2M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePeriod.p3M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePeriod.p6M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePeriod.p1Y)
    }

    public func testAdvancedCommerceReason() throws {
        XCTAssertEqual("UPGRADE", AdvancedCommerceReason.upgrade.rawValue)
        XCTAssertEqual("DOWNGRADE", AdvancedCommerceReason.downgrade.rawValue)
        XCTAssertEqual("APPLY_OFFER", AdvancedCommerceReason.applyOffer.rawValue)

        XCTAssertEqual(AdvancedCommerceReason.upgrade, AdvancedCommerceReason(rawValue: "UPGRADE"))
        XCTAssertEqual(AdvancedCommerceReason.downgrade, AdvancedCommerceReason(rawValue: "DOWNGRADE"))
        XCTAssertEqual(AdvancedCommerceReason.applyOffer, AdvancedCommerceReason(rawValue: "APPLY_OFFER"))
        XCTAssertNil(AdvancedCommerceReason(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceReason.upgrade)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceReason.downgrade)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceReason.applyOffer)
    }

    public func testAdvancedCommerceRefundReason() throws {
        XCTAssertEqual("UNINTENDED_PURCHASE", AdvancedCommerceRefundReason.unintendedPurchase.rawValue)
        XCTAssertEqual("FULFILLMENT_ISSUE", AdvancedCommerceRefundReason.fulfillmentIssue.rawValue)
        XCTAssertEqual("UNSATISFIED_WITH_PURCHASE", AdvancedCommerceRefundReason.unsatisfiedWithPurchase.rawValue)
        XCTAssertEqual("LEGAL", AdvancedCommerceRefundReason.legal.rawValue)
        XCTAssertEqual("OTHER", AdvancedCommerceRefundReason.other.rawValue)
        XCTAssertEqual("MODIFY_ITEMS_REFUND", AdvancedCommerceRefundReason.modifyItemsRefund.rawValue)
        XCTAssertEqual("SIMULATE_REFUND_DECLINE", AdvancedCommerceRefundReason.simulateRefundDecline.rawValue)

        XCTAssertEqual(AdvancedCommerceRefundReason.legal, AdvancedCommerceRefundReason(rawValue: "LEGAL"))
        XCTAssertEqual(AdvancedCommerceRefundReason.other, AdvancedCommerceRefundReason(rawValue: "OTHER"))
        XCTAssertNil(AdvancedCommerceRefundReason(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundReason.unintendedPurchase)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundReason.fulfillmentIssue)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundReason.unsatisfiedWithPurchase)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundReason.legal)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundReason.other)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundReason.modifyItemsRefund)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundReason.simulateRefundDecline)
    }

    public func testAdvancedCommerceRefundType() throws {
        XCTAssertEqual("FULL", AdvancedCommerceRefundType.full.rawValue)
        XCTAssertEqual("PRORATED", AdvancedCommerceRefundType.prorated.rawValue)
        XCTAssertEqual("CUSTOM", AdvancedCommerceRefundType.custom.rawValue)

        XCTAssertEqual(AdvancedCommerceRefundType.full, AdvancedCommerceRefundType(rawValue: "FULL"))
        XCTAssertEqual(AdvancedCommerceRefundType.prorated, AdvancedCommerceRefundType(rawValue: "PRORATED"))
        XCTAssertEqual(AdvancedCommerceRefundType.custom, AdvancedCommerceRefundType(rawValue: "CUSTOM"))
        XCTAssertNil(AdvancedCommerceRefundType(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundType.full)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundType.prorated)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceRefundType.custom)
    }

    public func testAdvancedCommerceOfferPeriod() throws {
        XCTAssertEqual("P3D", AdvancedCommerceOfferPeriod.p3D.rawValue)
        XCTAssertEqual("P1W", AdvancedCommerceOfferPeriod.p1W.rawValue)
        XCTAssertEqual("P2W", AdvancedCommerceOfferPeriod.p2W.rawValue)
        XCTAssertEqual("P1M", AdvancedCommerceOfferPeriod.p1M.rawValue)
        XCTAssertEqual("P2M", AdvancedCommerceOfferPeriod.p2M.rawValue)
        XCTAssertEqual("P3M", AdvancedCommerceOfferPeriod.p3M.rawValue)

        XCTAssertEqual(AdvancedCommerceOfferPeriod.p1W, AdvancedCommerceOfferPeriod(rawValue: "P1W"))
        XCTAssertEqual(AdvancedCommerceOfferPeriod.p1M, AdvancedCommerceOfferPeriod(rawValue: "P1M"))
        XCTAssertEqual(AdvancedCommerceOfferPeriod.p3D, AdvancedCommerceOfferPeriod(rawValue: "P3D"))
        XCTAssertNil(AdvancedCommerceOfferPeriod(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p3D)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p1W)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p2W)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p1M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p2M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p3M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p6M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p9M)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferPeriod.p1Y)
    }

    public func testAdvancedCommerceOfferReason() throws {
        XCTAssertEqual("ACQUISITION", AdvancedCommerceOfferReason.acquisition.rawValue)
        XCTAssertEqual("WIN_BACK", AdvancedCommerceOfferReason.winBack.rawValue)
        XCTAssertEqual("RETENTION", AdvancedCommerceOfferReason.retention.rawValue)

        XCTAssertEqual(AdvancedCommerceOfferReason.acquisition, AdvancedCommerceOfferReason(rawValue: "ACQUISITION"))
        XCTAssertEqual(AdvancedCommerceOfferReason.winBack, AdvancedCommerceOfferReason(rawValue: "WIN_BACK"))
        XCTAssertEqual(AdvancedCommerceOfferReason.retention, AdvancedCommerceOfferReason(rawValue: "RETENTION"))
        XCTAssertNil(AdvancedCommerceOfferReason(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferReason.acquisition)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferReason.winBack)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceOfferReason.retention)
    }

    public func testAdvancedCommerceEffective() throws {
        XCTAssertEqual("IMMEDIATELY", AdvancedCommerceEffective.immediately.rawValue)
        XCTAssertEqual("NEXT_BILL_CYCLE", AdvancedCommerceEffective.nextBillCycle.rawValue)

        XCTAssertEqual(AdvancedCommerceEffective.immediately, AdvancedCommerceEffective(rawValue: "IMMEDIATELY"))
        XCTAssertEqual(AdvancedCommerceEffective.nextBillCycle, AdvancedCommerceEffective(rawValue: "NEXT_BILL_CYCLE"))
        XCTAssertNil(AdvancedCommerceEffective(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceEffective.immediately)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommerceEffective.nextBillCycle)
    }

    public func testValidationUtilsDescription() throws {
        let validDescription = "Valid description"
        XCTAssertEqual(validDescription, try AdvancedCommerceValidationUtils.validateDescription(validDescription))

        let maxLengthDescription = String(repeating: "A", count: 45)
        XCTAssertEqual(maxLengthDescription, try AdvancedCommerceValidationUtils.validateDescription(maxLengthDescription))

        let tooLongDescription = String(repeating: "A", count: 46)
        XCTAssertThrowsError(try AdvancedCommerceValidationUtils.validateDescription(tooLongDescription))
    }

    public func testValidationUtilsDisplayName() throws {
        let validDisplayName = "Valid Name"
        XCTAssertEqual(validDisplayName, try AdvancedCommerceValidationUtils.validateDisplayName(validDisplayName))

        let maxLengthDisplayName = String(repeating: "A", count: 30)
        XCTAssertEqual(maxLengthDisplayName, try AdvancedCommerceValidationUtils.validateDisplayName(maxLengthDisplayName))

        let tooLongDisplayName = String(repeating: "A", count: 31)
        XCTAssertThrowsError(try AdvancedCommerceValidationUtils.validateDisplayName(tooLongDisplayName))
    }

    public func testValidationUtilsSku() throws {
        let validSku = "valid.sku.123"
        XCTAssertEqual(validSku, try AdvancedCommerceValidationUtils.validateSku(validSku))

        let maxLengthSku = String(repeating: "A", count: 128)
        XCTAssertEqual(maxLengthSku, try AdvancedCommerceValidationUtils.validateSku(maxLengthSku))

        let tooLongSku = String(repeating: "A", count: 129)
        XCTAssertThrowsError(try AdvancedCommerceValidationUtils.validateSku(tooLongSku))
    }

    public func testValidationUtilsPeriodCount() throws {
        XCTAssertEqual(1, try AdvancedCommerceValidationUtils.validatePeriodCount(1))
        XCTAssertEqual(6, try AdvancedCommerceValidationUtils.validatePeriodCount(6))
        XCTAssertEqual(12, try AdvancedCommerceValidationUtils.validatePeriodCount(12))

        XCTAssertThrowsError(try AdvancedCommerceValidationUtils.validatePeriodCount(0))
        XCTAssertThrowsError(try AdvancedCommerceValidationUtils.validatePeriodCount(13))
    }

    public func testValidationUtilsItems() throws {
        let validList = [try AdvancedCommerceOneTimeChargeItem(description: "desc", displayName: "name", sku: "sku1", price: 1000)]
        XCTAssertEqual(validList, try AdvancedCommerceValidationUtils.validateItems(validList))

        let emptyList: [AdvancedCommerceOneTimeChargeItem] = []
        XCTAssertThrowsError(try AdvancedCommerceValidationUtils.validateItems(emptyList))
    }

    public func testAdvancedCommerceDescriptors() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceDescriptors.json")
        let jsonDecoder = getJsonDecoder()

        let descriptors = try jsonDecoder.decode(AdvancedCommerceDescriptors.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", descriptors.description)
        XCTAssertEqual("display name", descriptors.displayName)

        TestingUtility.confirmCodableInternallyConsistent(descriptors)
    }

    public func testAdvancedCommerceOneTimeChargeItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceOneTimeChargeItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceOneTimeChargeItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", item.description)
        XCTAssertEqual("display name", item.displayName)
        XCTAssertEqual("sku", item.sku)
        XCTAssertEqual(15000, item.price)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionCreateItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionCreateItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionCreateItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", item.description)
        XCTAssertEqual("display name", item.displayName)
        XCTAssertEqual("sku", item.sku)
        XCTAssertEqual(20000, item.price)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceRequestRefundItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceRequestRefundItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceRequestRefundItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("sku", item.sku)
        XCTAssertEqual(AdvancedCommerceRefundReason.legal, item.refundReason)
        XCTAssertEqual(AdvancedCommerceRefundType.full, item.refundType)
        XCTAssertEqual(true, item.revoke)
        XCTAssertEqual(5000, item.refundAmount)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceOffer() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceOffer.json")
        let jsonDecoder = getJsonDecoder()

        let offer = try jsonDecoder.decode(AdvancedCommerceOffer.self, from: json.data(using: .utf8)!)

        XCTAssertEqual(AdvancedCommerceOfferPeriod.p1W, offer.period)
        XCTAssertEqual(3, offer.periodCount)
        XCTAssertEqual(5000, offer.price)
        XCTAssertEqual(AdvancedCommerceOfferReason.winBack, offer.reason)

        TestingUtility.confirmCodableInternallyConsistent(offer)
    }

    public func testAdvancedCommerceOneTimeChargeCreateRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceOneTimeChargeCreateRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceOneTimeChargeCreateRequest.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("USD", request.currency)
        XCTAssertNotNil(request.item)
        XCTAssertEqual("taxCode", request.taxCode)
        XCTAssertNotNil(request.requestInfo)
        XCTAssertEqual("USA", request.storefront)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionCreateRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionCreateRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionCreateRequest.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("USD", request.currency)
        XCTAssertNotNil(request.descriptors)
        XCTAssertNotNil(request.items)
        XCTAssertEqual(2, request.items.count)
        XCTAssertEqual(AdvancedCommercePeriod.p1M, request.period)
        XCTAssertEqual("taxCode", request.taxCode)
        XCTAssertEqual("USA", request.storefront)
        XCTAssertEqual("transactionId", request.previousTransactionId)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceRequestRefundRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceRequestRefundRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceRequestRefundRequest.self, from: json.data(using: .utf8)!)

        XCTAssertNotNil(request.items)
        XCTAssertEqual(2, request.items.count)
        XCTAssertTrue(request.refundRiskingPreference)
        XCTAssertNotNil(request.requestInfo)
        XCTAssertEqual("USD", request.currency)
        XCTAssertEqual("USA", request.storefront)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionCancelRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionCancelRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionCancelRequest.self, from: json.data(using: .utf8)!)

        XCTAssertNotNil(request.requestInfo)
        XCTAssertEqual("USA", request.storefront)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionRevokeRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionRevokeRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionRevokeRequest.self, from: json.data(using: .utf8)!)

        XCTAssertNotNil(request.requestInfo)
        XCTAssertTrue(request.refundRiskingPreference)
        XCTAssertEqual(AdvancedCommerceRefundReason.legal, request.refundReason)
        XCTAssertEqual("FULL", request.rawRefundType)
        XCTAssertEqual("USA", request.storefront)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionPriceChangeRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionPriceChangeRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionPriceChangeRequest.self, from: json.data(using: .utf8)!)

        XCTAssertNotNil(request.items)
        XCTAssertNotNil(request.requestInfo)
        XCTAssertEqual("USD", request.currency)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceRequestRefundResponse() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceRequestRefundResponse.json")
        let jsonDecoder = getJsonDecoder()

        let response = try jsonDecoder.decode(AdvancedCommerceRequestRefundResponse.self, from: json.data(using: .utf8)!)

        XCTAssertNil(response.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info_value", response.signedTransactionInfo)

        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testAdvancedCommerceSubscriptionCancelResponse() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionCancelResponse.json")
        let jsonDecoder = getJsonDecoder()

        let response = try jsonDecoder.decode(AdvancedCommerceSubscriptionCancelResponse.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("signed_renewal_info", response.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", response.signedTransactionInfo)

        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testAdvancedCommerceSubscriptionRevokeResponse() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionRevokeResponse.json")
        let jsonDecoder = getJsonDecoder()

        let response = try jsonDecoder.decode(AdvancedCommerceSubscriptionRevokeResponse.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("signed_renewal_info", response.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", response.signedTransactionInfo)

        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testAdvancedCommerceSubscriptionPriceChangeResponse() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionPriceChangeResponse.json")
        let jsonDecoder = getJsonDecoder()

        let response = try jsonDecoder.decode(AdvancedCommerceSubscriptionPriceChangeResponse.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("signed_renewal_info", response.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", response.signedTransactionInfo)

        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testAdvancedCommerceSubscriptionChangeMetadataResponse() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionChangeMetadataResponse.json")
        let jsonDecoder = getJsonDecoder()

        let response = try jsonDecoder.decode(AdvancedCommerceSubscriptionChangeMetadataResponse.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("signed_renewal_info", response.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", response.signedTransactionInfo)

        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testAdvancedCommerceSubscriptionMigrateRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionMigrateRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionMigrateRequest.self, from: json.data(using: .utf8)!)

        XCTAssertNotNil(request.descriptors)
        XCTAssertNotNil(request.items)
        XCTAssertEqual("taxCode", request.taxCode)
        XCTAssertEqual("targetProductId", request.targetProductId)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionModifyInAppRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionModifyInAppRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionModifyInAppRequest.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("USD", request.currency)
        XCTAssertNotNil(request.descriptors)
        XCTAssertEqual("taxCode", request.taxCode)
        XCTAssertEqual("transactionId", request.transactionId)
        XCTAssertTrue(request.retainBillingCycle)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionReactivateInAppRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionReactivateInAppRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionReactivateInAppRequest.self, from: json.data(using: .utf8)!)

        XCTAssertNotNil(request.items)
        XCTAssertEqual("transactionId", request.transactionId)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionChangeMetadataRequest() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionChangeMetadataRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionChangeMetadataRequest.self, from: json.data(using: .utf8)!)

        XCTAssertNotNil(request.items)
        XCTAssertNotNil(request.requestInfo)

        TestingUtility.confirmCodableInternallyConsistent(request)
    }

    public func testAdvancedCommerceSubscriptionMigrateDescriptors() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionMigrateDescriptors.json")
        let jsonDecoder = getJsonDecoder()

        let descriptors = try jsonDecoder.decode(AdvancedCommerceSubscriptionMigrateDescriptors.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", descriptors.description)
        XCTAssertEqual("displayName", descriptors.displayName)

        TestingUtility.confirmCodableInternallyConsistent(descriptors)
    }

    public func testAdvancedCommerceSubscriptionModifyDescriptors() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionModifyDescriptors.json")
        let jsonDecoder = getJsonDecoder()

        let descriptors = try jsonDecoder.decode(AdvancedCommerceSubscriptionModifyDescriptors.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", descriptors.description)
        XCTAssertEqual("displayName", descriptors.displayName)
        XCTAssertEqual(AdvancedCommerceEffective.immediately, descriptors.effective)

        TestingUtility.confirmCodableInternallyConsistent(descriptors)
    }

    public func testAdvancedCommerceSubscriptionChangeMetadataDescriptors() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionChangeMetadataDescriptors.json")
        let jsonDecoder = getJsonDecoder()

        let descriptors = try jsonDecoder.decode(AdvancedCommerceSubscriptionChangeMetadataDescriptors.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", descriptors.description)
        XCTAssertEqual("displayName", descriptors.displayName)
        XCTAssertEqual(AdvancedCommerceEffective.immediately, descriptors.effective)

        TestingUtility.confirmCodableInternallyConsistent(descriptors)
    }

    public func testAdvancedCommerceSubscriptionMigrateItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionMigrateItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionMigrateItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", item.description)
        XCTAssertEqual("displayName", item.displayName)
        XCTAssertEqual("sku", item.sku)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionMigrateRenewalItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionMigrateRenewalItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionMigrateRenewalItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", item.description)
        XCTAssertEqual("displayName", item.displayName)
        XCTAssertEqual("sku", item.sku)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionModifyAddItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionModifyAddItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionModifyAddItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", item.description)
        XCTAssertEqual("displayName", item.displayName)
        XCTAssertEqual("sku", item.sku)
        XCTAssertEqual(12000, item.price)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionModifyChangeItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionModifyChangeItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionModifyChangeItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", item.description)
        XCTAssertEqual("displayName", item.displayName)
        XCTAssertEqual("sku", item.sku)
        XCTAssertEqual("currentSku", item.currentSku)
        XCTAssertEqual(13000, item.price)
        XCTAssertEqual(AdvancedCommerceEffective.immediately, item.effective)
        XCTAssertEqual(AdvancedCommerceReason.upgrade, item.reason)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionModifyRemoveItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionModifyRemoveItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionModifyRemoveItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("sku", item.sku)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionModifyPeriodChange() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionModifyPeriodChange.json")
        let jsonDecoder = getJsonDecoder()

        let periodChange = try jsonDecoder.decode(AdvancedCommerceSubscriptionModifyPeriodChange.self, from: json.data(using: .utf8)!)

        XCTAssertEqual(AdvancedCommercePeriod.p3M, periodChange.period)
        XCTAssertEqual(AdvancedCommerceEffective.immediately, periodChange.effective)

        TestingUtility.confirmCodableInternallyConsistent(periodChange)
    }

    public func testAdvancedCommerceSubscriptionPriceChangeItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionPriceChangeItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionPriceChangeItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("sku", item.sku)
        XCTAssertEqual(16000, item.price)
        XCTAssertEqual("dependentSKU", item.dependentSKUs?[0])

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionPriceChangeItemDependentSKUValidation() throws {
        let validSku = String(repeating: "A", count: 128)
        let tooLongSku = String(repeating: "A", count: 129)

        let item = try AdvancedCommerceSubscriptionPriceChangeItem(sku: "sku", price: 1000, dependentSKUs: [validSku])
        XCTAssertEqual(validSku, item.dependentSKUs?[0])

        XCTAssertThrowsError(try AdvancedCommerceSubscriptionPriceChangeItem(sku: "sku", price: 1000, dependentSKUs: [tooLongSku]))

        let nilListItem = try AdvancedCommerceSubscriptionPriceChangeItem(sku: "sku", price: 1000, dependentSKUs: nil)
        XCTAssertNil(nilListItem.dependentSKUs)
    }

    public func testAdvancedCommerceSubscriptionReactivateItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionReactivateItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionReactivateItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("sku", item.sku)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceSubscriptionChangeMetadataItem() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionChangeMetadataItem.json")
        let jsonDecoder = getJsonDecoder()

        let item = try jsonDecoder.decode(AdvancedCommerceSubscriptionChangeMetadataItem.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("description", item.description)
        XCTAssertEqual("displayName", item.displayName)
        XCTAssertEqual("sku", item.sku)
        XCTAssertEqual("currentSku", item.currentSku)
        XCTAssertEqual(AdvancedCommerceEffective.nextBillCycle, item.effective)

        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    public func testAdvancedCommerceRequestInfo() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceRequestInfo.json")
        let jsonDecoder = getJsonDecoder()

        let requestInfo = try jsonDecoder.decode(AdvancedCommerceRequestInfo.self, from: json.data(using: .utf8)!)

        XCTAssertEqual(UUID(uuidString: "550e8400-e29b-41d4-a716-446655440010"), requestInfo.requestReferenceId)
        XCTAssertEqual(UUID(uuidString: "660e8400-e29b-41d4-a716-446655440011"), requestInfo.appAccountToken)
        XCTAssertEqual("consistency_token_value", requestInfo.consistencyToken)

        TestingUtility.confirmCodableInternallyConsistent(requestInfo)
    }

    public func testAdvancedCommerceSubscriptionMigrateResponse() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionMigrateResponse.json")
        let jsonDecoder = getJsonDecoder()

        let response = try jsonDecoder.decode(AdvancedCommerceSubscriptionMigrateResponse.self, from: json.data(using: .utf8)!)

        XCTAssertEqual("signed_renewal_info_value", response.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info_value", response.signedTransactionInfo)

        TestingUtility.confirmCodableInternallyConsistent(response)
    }
}
