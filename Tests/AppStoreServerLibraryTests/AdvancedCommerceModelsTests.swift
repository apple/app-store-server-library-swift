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
        XCTAssertEqual(validDescription, try HelperValidationUtils.validateDescription(validDescription))

        let maxLengthDescription = String(repeating: "A", count: 45)
        XCTAssertEqual(maxLengthDescription, try HelperValidationUtils.validateDescription(maxLengthDescription))

        let tooLongDescription = String(repeating: "A", count: 46)
        XCTAssertThrowsError(try HelperValidationUtils.validateDescription(tooLongDescription))
    }

    public func testValidationUtilsDisplayName() throws {
        let validDisplayName = "Valid Name"
        XCTAssertEqual(validDisplayName, try HelperValidationUtils.validateDisplayName(validDisplayName))

        let maxLengthDisplayName = String(repeating: "A", count: 30)
        XCTAssertEqual(maxLengthDisplayName, try HelperValidationUtils.validateDisplayName(maxLengthDisplayName))

        let tooLongDisplayName = String(repeating: "A", count: 31)
        XCTAssertThrowsError(try HelperValidationUtils.validateDisplayName(tooLongDisplayName))
    }

    public func testValidationUtilsSku() throws {
        let validSku = "valid.sku.123"
        XCTAssertEqual(validSku, try HelperValidationUtils.validateSku(validSku))

        let maxLengthSku = String(repeating: "A", count: 128)
        XCTAssertEqual(maxLengthSku, try HelperValidationUtils.validateSku(maxLengthSku))

        let tooLongSku = String(repeating: "A", count: 129)
        XCTAssertThrowsError(try HelperValidationUtils.validateSku(tooLongSku))
    }

    public func testValidationUtilsPeriodCount() throws {
        XCTAssertEqual(1, try HelperValidationUtils.validatePeriodCount(1))
        XCTAssertEqual(6, try HelperValidationUtils.validatePeriodCount(6))
        XCTAssertEqual(12, try HelperValidationUtils.validatePeriodCount(12))

        XCTAssertThrowsError(try HelperValidationUtils.validatePeriodCount(0))
        XCTAssertThrowsError(try HelperValidationUtils.validatePeriodCount(13))
    }

    public func testValidationUtilsItems() throws {
        let validList = [try AdvancedCommerceOneTimeChargeItem(sku: "sku1", description: "desc", displayName: "name", price: 1000)]
        XCTAssertEqual(validList, try HelperValidationUtils.validateItems(validList))

        let emptyList: [AdvancedCommerceOneTimeChargeItem] = []
        XCTAssertThrowsError(try HelperValidationUtils.validateItems(emptyList))
    }

    public func testValidationUtilsMeasuresLengthInUnicodeCodePoints() throws {
        let nonBmpDescription = String(repeating: "\u{1F44D}", count: 45)
        XCTAssertEqual(nonBmpDescription, try HelperValidationUtils.validateDescription(nonBmpDescription))
        XCTAssertThrowsError(try HelperValidationUtils.validateDescription(nonBmpDescription + "\u{1F44D}"))

        let combiningDisplayName = String(repeating: "e\u{0301}", count: 15)
        XCTAssertEqual(combiningDisplayName, try HelperValidationUtils.validateDisplayName(combiningDisplayName))
        XCTAssertThrowsError(try HelperValidationUtils.validateDisplayName(String(repeating: "e\u{0301}", count: 16)))

        let combiningSku = String(repeating: "e\u{0301}", count: 64)
        XCTAssertEqual(combiningSku, try HelperValidationUtils.validateSku(combiningSku))
        XCTAssertThrowsError(try HelperValidationUtils.validateSku(combiningSku + "e"))
    }

    public func testValidationErrorsReportFieldName() throws {
        let requestInfo = AdvancedCommerceRequestInfo(requestReferenceId: UUID())
        let tooLongSku = String(repeating: "A", count: 129)

        assertValidationError(try HelperValidationUtils.validateItems([String]()), "items list cannot be empty")
        assertValidationError(try HelperValidationUtils.validateSku(tooLongSku), "SKU length cannot exceed 128 characters")
        assertValidationError(try AdvancedCommerceSubscriptionModifyInAppRequest(requestInfo: requestInfo, retainBillingCycle: true, transactionId: "transactionId", addItems: []), "addItems list cannot be empty")
        assertValidationError(try AdvancedCommerceSubscriptionModifyInAppRequest(requestInfo: requestInfo, retainBillingCycle: true, transactionId: "transactionId", changeItems: []), "changeItems list cannot be empty")
        assertValidationError(try AdvancedCommerceSubscriptionModifyInAppRequest(requestInfo: requestInfo, retainBillingCycle: true, transactionId: "transactionId", removeItems: []), "removeItems list cannot be empty")

        let migrateDescriptors = try AdvancedCommerceSubscriptionMigrateDescriptors(description: "description", displayName: "displayName")
        let migrateItem = try AdvancedCommerceSubscriptionMigrateItem(sku: "sku", description: "description", displayName: "displayName")
        assertValidationError(try AdvancedCommerceSubscriptionMigrateRequest(requestInfo: requestInfo, descriptors: migrateDescriptors, items: [], targetProductId: "targetProductId", taxCode: "taxCode"), "items list cannot be empty")
        assertValidationError(try AdvancedCommerceSubscriptionMigrateRequest(requestInfo: requestInfo, descriptors: migrateDescriptors, items: [migrateItem], targetProductId: "targetProductId", taxCode: "taxCode", renewalItems: []), "renewalItems list cannot be empty")

        assertValidationError(try AdvancedCommerceSubscriptionModifyChangeItem(sku: "sku", description: "description", displayName: "displayName", currentSku: tooLongSku, effective: .immediately, price: 1000, reason: .upgrade), "currentSKU length cannot exceed 128 characters")
        assertValidationError(try AdvancedCommerceSubscriptionModifyChangeItem(sku: tooLongSku, description: "description", displayName: "displayName", currentSku: "currentSku", effective: .immediately, price: 1000, reason: .upgrade), "SKU length cannot exceed 128 characters")
        assertValidationError(try AdvancedCommerceSubscriptionChangeMetadataItem(currentSku: tooLongSku, effective: .immediately), "currentSKU length cannot exceed 128 characters")
        assertValidationError(try AdvancedCommerceSubscriptionPriceChangeItem(sku: "sku", price: 1000, dependentSKUs: [tooLongSku]), "dependentSKUs length cannot exceed 128 characters")
    }

    public func testEncodingSubscriptionCreateRequestValidatesFieldsChangedAfterInitialization() throws {
        let offer = try AdvancedCommerceOffer(period: .p1M, periodCount: 3, price: 1000, reason: .acquisition)
        let item = try AdvancedCommerceSubscriptionCreateItem(sku: "sku", description: "description", displayName: "displayName", price: 2000, offer: offer)
        let descriptors = try AdvancedCommerceDescriptors(description: "description", displayName: "displayName")
        let validRequest = try AdvancedCommerceSubscriptionCreateRequest(requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID()), currency: "USD", descriptors: descriptors, items: [item], period: .p1M, taxCode: "taxCode")
        XCTAssertNoThrow(try getJsonEncoder().encode(validRequest))

        var request = validRequest
        request.descriptors.description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(request), "description length cannot exceed 45 characters")

        request = validRequest
        request.descriptors.displayName = String(repeating: "A", count: 31)
        assertValidationError(try getJsonEncoder().encode(request), "displayName length cannot exceed 30 characters")

        request = validRequest
        request.items = []
        assertValidationError(try getJsonEncoder().encode(request), "items list cannot be empty")

        request = validRequest
        request.items[0].description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(request), "description length cannot exceed 45 characters")

        request = validRequest
        request.items[0].sku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(request), "SKU length cannot exceed 128 characters")

        request = validRequest
        request.items[0].offer!.periodCount = 13
        assertValidationError(try getJsonEncoder().encode(request), "periodCount must be between 1 and 12")
    }

    public func testEncodingSubscriptionModifyInAppRequestValidatesFieldsChangedAfterInitialization() throws {
        let offer = try AdvancedCommerceOffer(period: .p1M, periodCount: 3, price: 1000, reason: .retention)
        let addItem = try AdvancedCommerceSubscriptionModifyAddItem(sku: "sku", description: "description", displayName: "displayName", price: 2000, offer: offer)
        let changeItem = try AdvancedCommerceSubscriptionModifyChangeItem(sku: "sku2", description: "description", displayName: "displayName", currentSku: "currentSku", effective: .immediately, price: 3000, reason: .applyOffer, offer: offer)
        let removeItem = try AdvancedCommerceSubscriptionModifyRemoveItem(sku: "sku3")
        let descriptors = try AdvancedCommerceSubscriptionModifyDescriptors(effective: .nextBillCycle, description: "description", displayName: "displayName")
        let validRequest = try AdvancedCommerceSubscriptionModifyInAppRequest(requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID()), retainBillingCycle: true, transactionId: "transactionId", addItems: [addItem], changeItems: [changeItem], descriptors: descriptors, removeItems: [removeItem])
        XCTAssertNoThrow(try getJsonEncoder().encode(validRequest))

        var request = validRequest
        request.addItems = []
        assertValidationError(try getJsonEncoder().encode(request), "addItems list cannot be empty")

        request = validRequest
        request.changeItems = []
        assertValidationError(try getJsonEncoder().encode(request), "changeItems list cannot be empty")

        request = validRequest
        request.removeItems = []
        assertValidationError(try getJsonEncoder().encode(request), "removeItems list cannot be empty")

        request = validRequest
        request.addItems![0].displayName = String(repeating: "A", count: 31)
        assertValidationError(try getJsonEncoder().encode(request), "displayName length cannot exceed 30 characters")

        request = validRequest
        request.addItems![0].offer!.periodCount = 0
        assertValidationError(try getJsonEncoder().encode(request), "periodCount must be between 1 and 12")

        request = validRequest
        request.changeItems![0].currentSku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(request), "currentSKU length cannot exceed 128 characters")

        request = validRequest
        request.changeItems![0].description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(request), "description length cannot exceed 45 characters")

        request = validRequest
        request.changeItems![0].offer!.periodCount = 13
        assertValidationError(try getJsonEncoder().encode(request), "periodCount must be between 1 and 12")

        request = validRequest
        request.removeItems![0].sku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(request), "SKU length cannot exceed 128 characters")

        request = validRequest
        request.descriptors!.description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(request), "description length cannot exceed 45 characters")
    }

    public func testEncodingSubscriptionMigrateRequestValidatesFieldsChangedAfterInitialization() throws {
        let descriptors = try AdvancedCommerceSubscriptionMigrateDescriptors(description: "description", displayName: "displayName")
        let item = try AdvancedCommerceSubscriptionMigrateItem(sku: "sku", description: "description", displayName: "displayName")
        let renewalItem = try AdvancedCommerceSubscriptionMigrateRenewalItem(sku: "sku2", description: "description", displayName: "displayName")
        let validRequest = try AdvancedCommerceSubscriptionMigrateRequest(requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID()), descriptors: descriptors, items: [item], targetProductId: "targetProductId", taxCode: "taxCode", renewalItems: [renewalItem])
        XCTAssertNoThrow(try getJsonEncoder().encode(validRequest))

        var request = validRequest
        request.items = []
        assertValidationError(try getJsonEncoder().encode(request), "items list cannot be empty")

        request = validRequest
        request.renewalItems = []
        assertValidationError(try getJsonEncoder().encode(request), "renewalItems list cannot be empty")

        request = validRequest
        request.items[0].sku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(request), "SKU length cannot exceed 128 characters")

        request = validRequest
        request.renewalItems![0].displayName = String(repeating: "A", count: 31)
        assertValidationError(try getJsonEncoder().encode(request), "displayName length cannot exceed 30 characters")

        request = validRequest
        request.descriptors.description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(request), "description length cannot exceed 45 characters")
    }

    public func testSubscriptionMigrateDescriptorsRequiresDescriptionAndDisplayName() throws {
        let validDescriptors = try AdvancedCommerceSubscriptionMigrateDescriptors(description: "description", displayName: "displayName")
        let node = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(validDescriptors)) as! [String: Any]
        XCTAssertEqual("description", node["description"] as? String)
        XCTAssertEqual("displayName", node["displayName"] as? String)

        TestingUtility.confirmRequiredKeys(AdvancedCommerceSubscriptionMigrateDescriptors.self, node, requiredKeys: ["description", "displayName"])
    }

    public func testEncodingOtherRequestsValidatesFieldsChangedAfterInitialization() throws {
        let requestInfo = AdvancedCommerceRequestInfo(requestReferenceId: UUID())

        var oneTimeChargeItem = try AdvancedCommerceOneTimeChargeItem(sku: "sku", description: "description", displayName: "displayName", price: 1000)
        oneTimeChargeItem.description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(AdvancedCommerceOneTimeChargeCreateRequest(requestInfo: requestInfo, currency: "USD", item: oneTimeChargeItem, taxCode: "taxCode")), "description length cannot exceed 45 characters")

        let refundItem = try AdvancedCommerceRequestRefundItem(sku: "sku", refundReason: .legal, refundType: .full, revoke: true)
        var refundRequest = try AdvancedCommerceRequestRefundRequest(requestInfo: requestInfo, items: [refundItem], refundRiskingPreference: true)
        XCTAssertNoThrow(try getJsonEncoder().encode(refundRequest))
        refundRequest.items[0].sku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(refundRequest), "SKU length cannot exceed 128 characters")
        refundRequest.items = []
        assertValidationError(try getJsonEncoder().encode(refundRequest), "items list cannot be empty")

        let priceChangeItem = try AdvancedCommerceSubscriptionPriceChangeItem(sku: "sku", price: 1000, dependentSKUs: ["dependentSKU"])
        var priceChangeRequest = try AdvancedCommerceSubscriptionPriceChangeRequest(requestInfo: requestInfo, items: [priceChangeItem])
        XCTAssertNoThrow(try getJsonEncoder().encode(priceChangeRequest))
        priceChangeRequest.items[0].dependentSKUs = [String(repeating: "A", count: 129)]
        assertValidationError(try getJsonEncoder().encode(priceChangeRequest), "dependentSKUs length cannot exceed 128 characters")
        priceChangeRequest.items[0].dependentSKUs = nil
        priceChangeRequest.items[0].sku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(priceChangeRequest), "SKU length cannot exceed 128 characters")
        priceChangeRequest.items = []
        assertValidationError(try getJsonEncoder().encode(priceChangeRequest), "items list cannot be empty")

        var reactivateItem = try AdvancedCommerceSubscriptionReactivateItem(sku: "sku")
        reactivateItem.sku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(AdvancedCommerceSubscriptionReactivateInAppRequest(requestInfo: requestInfo, transactionId: "transactionId", items: [reactivateItem])), "SKU length cannot exceed 128 characters")

        let changeMetadataItem = try AdvancedCommerceSubscriptionChangeMetadataItem(currentSku: "currentSku", effective: .immediately, sku: "sku", description: "description", displayName: "displayName")
        let changeMetadataDescriptors = try AdvancedCommerceSubscriptionChangeMetadataDescriptors(effective: .immediately, description: "description", displayName: "displayName")
        let validChangeMetadataRequest = AdvancedCommerceSubscriptionChangeMetadataRequest(requestInfo: requestInfo, descriptors: changeMetadataDescriptors, items: [changeMetadataItem])
        XCTAssertNoThrow(try getJsonEncoder().encode(validChangeMetadataRequest))
        var changeMetadataRequest = validChangeMetadataRequest
        changeMetadataRequest.items![0].sku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(changeMetadataRequest), "SKU length cannot exceed 128 characters")
        changeMetadataRequest = validChangeMetadataRequest
        changeMetadataRequest.items![0].currentSku = String(repeating: "A", count: 129)
        assertValidationError(try getJsonEncoder().encode(changeMetadataRequest), "currentSKU length cannot exceed 128 characters")
        changeMetadataRequest = validChangeMetadataRequest
        changeMetadataRequest.items![0].description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(changeMetadataRequest), "description length cannot exceed 45 characters")
        changeMetadataRequest = validChangeMetadataRequest
        changeMetadataRequest.descriptors!.displayName = String(repeating: "A", count: 31)
        assertValidationError(try getJsonEncoder().encode(changeMetadataRequest), "displayName length cannot exceed 30 characters")
    }

    public func testSubscriptionChangeMetadataRequestRequiresAtLeastOneItemWhenItemsAreIncluded() throws {
        let requestInfo = AdvancedCommerceRequestInfo(requestReferenceId: UUID())

        let emptyItemsRequest = AdvancedCommerceSubscriptionChangeMetadataRequest(requestInfo: requestInfo, items: [])
        assertValidationError(try getJsonEncoder().encode(emptyItemsRequest), "items list cannot be empty")

        let noItemsRequest = AdvancedCommerceSubscriptionChangeMetadataRequest(requestInfo: requestInfo, storefront: "USA")
        let node = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(noItemsRequest)) as! [String: Any]
        XCTAssertNil(node["items"])
        XCTAssertEqual("USA", node["storefront"] as? String)
    }

    public func testSubscriptionReactivateInAppRequestItemsValidation() throws {
        let requestInfo = AdvancedCommerceRequestInfo(requestReferenceId: UUID())
        let item = try AdvancedCommerceSubscriptionReactivateItem(sku: "sku")

        assertValidationError(try AdvancedCommerceSubscriptionReactivateInAppRequest(requestInfo: requestInfo, transactionId: "transactionId", items: []), "items list cannot be empty")
        var emptyItemsRequest = try AdvancedCommerceSubscriptionReactivateInAppRequest(requestInfo: requestInfo, transactionId: "transactionId", items: [item])
        emptyItemsRequest.items = []
        assertValidationError(try getJsonEncoder().encode(emptyItemsRequest), "items list cannot be empty")

        let noItemsRequest = try AdvancedCommerceSubscriptionReactivateInAppRequest(requestInfo: requestInfo, transactionId: "transactionId")
        XCTAssertNil(noItemsRequest.items)
        let noItemsNode = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(noItemsRequest)) as! [String: Any]
        XCTAssertNil(noItemsNode["items"])

        let validRequest = try AdvancedCommerceSubscriptionReactivateInAppRequest(requestInfo: requestInfo, transactionId: "transactionId", items: [item])
        XCTAssertEqual([item], validRequest.items)
        let validNode = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(validRequest)) as! [String: Any]
        XCTAssertEqual("sku", ((validNode["items"] as! [[String: Any]])[0])["SKU"] as? String)
    }

    public func testDecodingPayloadsAppliesRequestLimits() throws {
        let json = "{\"SKU\": \"sku\", \"description\": \"description\", \"displayName\": \"displayName\", \"offer\": {\"period\": \"P1M\", \"periodCount\": %d, \"price\": 1000, \"reason\": \"ACQUISITION\"}, \"price\": 2000}"

        assertValidationError(try getJsonDecoder().decode(AdvancedCommerceTransactionItem.self, from: String(format: json, 13).data(using: .utf8)!), "periodCount must be between 1 and 12")

        let item = try getJsonDecoder().decode(AdvancedCommerceTransactionItem.self, from: String(format: json, 12).data(using: .utf8)!)
        XCTAssertEqual(12, item.offer!.periodCount)
        TestingUtility.confirmCodableInternallyConsistent(item)
    }

    private func assertValidationError<T>(_ expression: @autoclosure () throws -> T, _ expectedDescription: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try expression(), file: file, line: line) { error in
            XCTAssertEqual(expectedDescription, (error as? HelperValidationUtils.ValidationError)?.description, file: file, line: line)
        }
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

    public func testAdvancedCommerceRequestRefundItemRefundAmountIs64Bit() throws {
        let refundAmount: Int64 = 5_000_000_000
        let item = try AdvancedCommerceRequestRefundItem(sku: "sku", refundReason: .legal, refundType: .custom, revoke: false, refundAmount: refundAmount)
        XCTAssertEqual(refundAmount, try encodeToDictionary(item)["refundAmount"] as? Int64)

        var json = TestingUtility.readJsonObject("resources/models/advancedCommerceRequestRefundItem.json")
        json["refundAmount"] = refundAmount
        let decoded = try getJsonDecoder().decode(AdvancedCommerceRequestRefundItem.self, from: JSONSerialization.data(withJSONObject: json))
        XCTAssertEqual(refundAmount, decoded.refundAmount)
        TestingUtility.confirmCodableInternallyConsistent(decoded)
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

    public func testResponsesWithoutRequiredFieldsFailToDecode() throws {
        TestingUtility.confirmRequiredKeys(AdvancedCommerceRequestRefundResponse.self, TestingUtility.readJsonObject("resources/models/advancedCommerceRequestRefundResponse.json"), requiredKeys: ["signedTransactionInfo"])
        TestingUtility.confirmRequiredKeys(AdvancedCommerceSubscriptionCancelResponse.self, TestingUtility.readJsonObject("resources/models/advancedCommerceSubscriptionCancelResponse.json"), requiredKeys: ["signedTransactionInfo", "signedRenewalInfo"])
        TestingUtility.confirmRequiredKeys(AdvancedCommerceSubscriptionChangeMetadataResponse.self, TestingUtility.readJsonObject("resources/models/advancedCommerceSubscriptionChangeMetadataResponse.json"), requiredKeys: ["signedTransactionInfo", "signedRenewalInfo"])
        TestingUtility.confirmRequiredKeys(AdvancedCommerceSubscriptionMigrateResponse.self, TestingUtility.readJsonObject("resources/models/advancedCommerceSubscriptionMigrateResponse.json"), requiredKeys: ["signedTransactionInfo", "signedRenewalInfo"])
        TestingUtility.confirmRequiredKeys(AdvancedCommerceSubscriptionPriceChangeResponse.self, TestingUtility.readJsonObject("resources/models/advancedCommerceSubscriptionPriceChangeResponse.json"), requiredKeys: ["signedTransactionInfo", "signedRenewalInfo"])
        TestingUtility.confirmRequiredKeys(AdvancedCommerceSubscriptionRevokeResponse.self, TestingUtility.readJsonObject("resources/models/advancedCommerceSubscriptionRevokeResponse.json"), requiredKeys: ["signedTransactionInfo", "signedRenewalInfo"])
    }

    public func testOfferAndDescriptorsWithoutARequiredFieldFailToDecode() throws {
        TestingUtility.confirmRequiredKeys(AdvancedCommerceOffer.self, TestingUtility.readJsonObject("resources/models/advancedCommerceOffer.json"), requiredKeys: ["price", "period", "periodCount", "reason"])
        TestingUtility.confirmRequiredKeys(AdvancedCommerceDescriptors.self, TestingUtility.readJsonObject("resources/models/advancedCommerceDescriptors.json"), requiredKeys: ["displayName", "description"])
    }

    public func testOfferAndDescriptorsOutsideTheRequestLimitsFailToDecode() throws {
        func offerJson(_ periodCount: Int) -> Data {
            return "{\"price\": 1000, \"period\": \"P1M\", \"periodCount\": \(periodCount), \"reason\": \"ACQUISITION\"}".data(using: .utf8)!
        }
        func descriptorsJson(displayName: Int, description: Int) -> Data {
            return "{\"displayName\": \"\(String(repeating: "A", count: displayName))\", \"description\": \"\(String(repeating: "A", count: description))\"}".data(using: .utf8)!
        }
        assertValidationError(try getJsonDecoder().decode(AdvancedCommerceOffer.self, from: offerJson(13)), "periodCount must be between 1 and 12")
        assertValidationError(try getJsonDecoder().decode(AdvancedCommerceOffer.self, from: offerJson(0)), "periodCount must be between 1 and 12")
        assertValidationError(try getJsonDecoder().decode(AdvancedCommerceDescriptors.self, from: descriptorsJson(displayName: 31, description: 45)), "displayName length cannot exceed 30 characters")
        assertValidationError(try getJsonDecoder().decode(AdvancedCommerceDescriptors.self, from: descriptorsJson(displayName: 30, description: 46)), "description length cannot exceed 45 characters")

        for periodCount in [1, 12] {
            let offer = try getJsonDecoder().decode(AdvancedCommerceOffer.self, from: offerJson(periodCount))
            XCTAssertEqual(Int32(periodCount), offer.periodCount)
            TestingUtility.confirmCodableInternallyConsistent(offer)
        }
        var offer = try getJsonDecoder().decode(AdvancedCommerceOffer.self, from: offerJson(12))
        let descriptors = try getJsonDecoder().decode(AdvancedCommerceDescriptors.self, from: descriptorsJson(displayName: 30, description: 45))
        XCTAssertEqual(30, descriptors.displayName.count)
        XCTAssertEqual(45, descriptors.description.count)
        TestingUtility.confirmCodableInternallyConsistent(descriptors)

        offer.periodCount = 13
        assertValidationError(try getJsonEncoder().encode(offer), "periodCount must be between 1 and 12")
        var tooLong = descriptors
        tooLong.displayName = String(repeating: "A", count: 31)
        assertValidationError(try getJsonEncoder().encode(tooLong), "displayName length cannot exceed 30 characters")

        let addItem = try AdvancedCommerceSubscriptionModifyAddItem(sku: "sku", description: "description", displayName: "displayName", price: 2000, offer: offer)
        let modifyRequest = try AdvancedCommerceSubscriptionModifyInAppRequest(requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID()), retainBillingCycle: true, transactionId: "transactionId", addItems: [addItem])
        assertValidationError(try getJsonEncoder().encode(modifyRequest), "periodCount must be between 1 and 12")
        let item = try AdvancedCommerceSubscriptionCreateItem(sku: "sku", description: "description", displayName: "displayName", price: 2000)
        let createRequest = try AdvancedCommerceSubscriptionCreateRequest(requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID()), currency: "USD", descriptors: tooLong, items: [item], period: .p1M, taxCode: "taxCode")
        assertValidationError(try getJsonEncoder().encode(createRequest), "displayName length cannot exceed 30 characters")
    }

    public func testOfferAndDescriptorsFieldsAreRequiredToBuildARequest() throws {
        let offer = try AdvancedCommerceOffer(period: .p1M, periodCount: 3, price: 1000, reason: .acquisition)
        XCTAssertEqual(["period", "periodCount", "price", "reason"], try encodeToDictionary(offer).keys.sorted())
        let rawOffer = try AdvancedCommerceOffer(rawPeriod: "P1M", periodCount: 3, price: 1000, rawReason: "ACQUISITION")
        XCTAssertEqual(offer, rawOffer)
        let descriptors = try AdvancedCommerceDescriptors(description: "description", displayName: "displayName")
        XCTAssertEqual(["description", "displayName"], try encodeToDictionary(descriptors).keys.sorted())

        assertValidationError(try AdvancedCommerceOffer(period: .p1M, periodCount: 13, price: 1000, reason: .acquisition), "periodCount must be between 1 and 12")
        assertValidationError(try AdvancedCommerceDescriptors(description: "description", displayName: String(repeating: "A", count: 31)), "displayName length cannot exceed 30 characters")
        assertValidationError(try AdvancedCommerceDescriptors(description: String(repeating: "A", count: 46), displayName: "displayName"), "description length cannot exceed 45 characters")

        let item = try AdvancedCommerceSubscriptionCreateItem(sku: "sku", description: "description", displayName: "displayName", price: 2000, offer: offer)
        let validRequest = try AdvancedCommerceSubscriptionCreateRequest(requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID()), currency: "USD", descriptors: descriptors, items: [item], period: .p1M, taxCode: "taxCode")
        XCTAssertNoThrow(try getJsonEncoder().encode(validRequest))

        var request = validRequest
        request.descriptors.description = String(repeating: "A", count: 46)
        assertValidationError(try getJsonEncoder().encode(request), "description length cannot exceed 45 characters")
    }

    private func encodeToDictionary(_ value: any Encodable) throws -> [String: Any] {
        return try JSONSerialization.jsonObject(with: getJsonEncoder().encode(value)) as! [String: Any]
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

    public func testOneTimeChargeCreateRequestDeserializationSetsOperationAndVersion() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceOneTimeChargeCreateRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceOneTimeChargeCreateRequest.self, from: json.data(using: .utf8)!)

        let encoded = try getJsonEncoder().encode(request)
        let node = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("CREATE_ONE_TIME_CHARGE", node["operation"] as? String)
        XCTAssertEqual("1", node["version"] as? String)
    }

    public func testSubscriptionCreateRequestDeserializationSetsOperationAndVersion() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionCreateRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionCreateRequest.self, from: json.data(using: .utf8)!)

        let encoded = try getJsonEncoder().encode(request)
        let node = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("CREATE_SUBSCRIPTION", node["operation"] as? String)
        XCTAssertEqual("1", node["version"] as? String)
    }

    public func testSubscriptionModifyInAppRequestDeserializationSetsOperationAndVersion() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionModifyInAppRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionModifyInAppRequest.self, from: json.data(using: .utf8)!)

        let encoded = try getJsonEncoder().encode(request)
        let node = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("MODIFY_SUBSCRIPTION", node["operation"] as? String)
        XCTAssertEqual("1", node["version"] as? String)
    }

    public func testSubscriptionReactivateInAppRequestDeserializationSetsOperationAndVersion() throws {
        let json = TestingUtility.readFile("resources/models/advancedCommerceSubscriptionReactivateInAppRequest.json")
        let jsonDecoder = getJsonDecoder()

        let request = try jsonDecoder.decode(AdvancedCommerceSubscriptionReactivateInAppRequest.self, from: json.data(using: .utf8)!)

        let encoded = try getJsonEncoder().encode(request)
        let node = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("REACTIVATE_SUBSCRIPTION", node["operation"] as? String)
        XCTAssertEqual("1", node["version"] as? String)
    }

    public func testAdvancedCommercePriceIncreaseInfoStatus() throws {
        XCTAssertEqual("SCHEDULED", AdvancedCommercePriceIncreaseInfoStatus.scheduled.rawValue)
        XCTAssertEqual("PENDING", AdvancedCommercePriceIncreaseInfoStatus.pending.rawValue)
        XCTAssertEqual("ACCEPTED", AdvancedCommercePriceIncreaseInfoStatus.accepted.rawValue)

        XCTAssertEqual(AdvancedCommercePriceIncreaseInfoStatus.scheduled, AdvancedCommercePriceIncreaseInfoStatus(rawValue: "SCHEDULED"))
        XCTAssertEqual(AdvancedCommercePriceIncreaseInfoStatus.pending, AdvancedCommercePriceIncreaseInfoStatus(rawValue: "PENDING"))
        XCTAssertEqual(AdvancedCommercePriceIncreaseInfoStatus.accepted, AdvancedCommercePriceIncreaseInfoStatus(rawValue: "ACCEPTED"))
        XCTAssertNil(AdvancedCommercePriceIncreaseInfoStatus(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePriceIncreaseInfoStatus.scheduled)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePriceIncreaseInfoStatus.pending)
        TestingUtility.confirmCodableInternallyConsistent(AdvancedCommercePriceIncreaseInfoStatus.accepted)
    }

    public func testBillingPlanType() throws {
        XCTAssertEqual("BILLED_UPFRONT", BillingPlanType.billedUpfront.rawValue)
        XCTAssertEqual("MONTHLY", BillingPlanType.monthly.rawValue)

        XCTAssertEqual(BillingPlanType.billedUpfront, BillingPlanType(rawValue: "BILLED_UPFRONT"))
        XCTAssertEqual(BillingPlanType.monthly, BillingPlanType(rawValue: "MONTHLY"))
        XCTAssertNil(BillingPlanType(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(BillingPlanType.billedUpfront)
        TestingUtility.confirmCodableInternallyConsistent(BillingPlanType.monthly)
    }

    public func testRenewalBillingPlanType() throws {
        XCTAssertEqual("BILLED_UPFRONT", RenewalBillingPlanType.billedUpfront.rawValue)
        XCTAssertEqual("MONTHLY", RenewalBillingPlanType.monthly.rawValue)

        XCTAssertEqual(RenewalBillingPlanType.billedUpfront, RenewalBillingPlanType(rawValue: "BILLED_UPFRONT"))
        XCTAssertEqual(RenewalBillingPlanType.monthly, RenewalBillingPlanType(rawValue: "MONTHLY"))
        XCTAssertNil(RenewalBillingPlanType(rawValue: "INVALID"))

        TestingUtility.confirmCodableInternallyConsistent(RenewalBillingPlanType.billedUpfront)
        TestingUtility.confirmCodableInternallyConsistent(RenewalBillingPlanType.monthly)
    }

    public func testTransactionCommitmentInfoBillingPeriodNumberValidation() throws {
        let info1 = try TransactionCommitmentInfo(billingPeriodNumber: 1)
        XCTAssertEqual(1, info1.billingPeriodNumber)

        let info12 = try TransactionCommitmentInfo(billingPeriodNumber: 12)
        XCTAssertEqual(12, info12.billingPeriodNumber)

        let infoNil = try TransactionCommitmentInfo(billingPeriodNumber: nil)
        XCTAssertNil(infoNil.billingPeriodNumber)

        XCTAssertThrowsError(try TransactionCommitmentInfo(billingPeriodNumber: 0))
        XCTAssertThrowsError(try TransactionCommitmentInfo(billingPeriodNumber: 13))
        XCTAssertThrowsError(try TransactionCommitmentInfo(billingPeriodNumber: -1))
    }
}
