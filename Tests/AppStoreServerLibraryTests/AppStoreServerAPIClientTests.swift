// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat
import JWTKit

final class AppStoreServerAPIClientTests: XCTestCase {
    
    typealias RequestVerifier = (HTTPClientRequest, Data?) throws -> ()
    
    public func testExtendRenewalDateForAllActiveSubscribers() async throws {
        let client = try getClientWithBody("resources/models/extendRenewalDateForAllActiveSubscribersResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/subscriptions/extend/mass", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(45, decodedJson["extendByDays"] as! Int)
            XCTAssertEqual(1, decodedJson["extendReasonCode"] as! Int)
            XCTAssertEqual("fdf964a4-233b-486c-aac1-97d8d52688ac", decodedJson["requestIdentifier"] as! String)
            XCTAssertEqual(["USA", "MEX"], decodedJson["storefrontCountryCodes"] as! [String])
            XCTAssertEqual("com.example.productId", decodedJson["productId"] as! String)
        }
        
        let extendRenewalDateRequest = MassExtendRenewalDateRequest(
            extendByDays: 45,
            extendReasonCode: .customerSatisfaction,
            requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac",
            storefrontCountryCodes: ["USA", "MEX"],
            productId: "com.example.productId"
        )
        
        TestingUtility.confirmCodableInternallyConsistent(extendRenewalDateRequest)
        
        let response = await client.extendRenewalDateForAllActiveSubscribers(massExtendRenewalDateRequest: extendRenewalDateRequest)
        
        guard case .success(let massExtendRenewalDateResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("758883e8-151b-47b7-abd0-60c4d804c2f5", massExtendRenewalDateResponse.requestIdentifier)
        TestingUtility.confirmCodableInternallyConsistent(massExtendRenewalDateResponse)
    }
    
    public func testExtendSubscriptionRenewalDate() async throws {
        let client = try getClientWithBody("resources/models/extendSubscriptionRenewalDateResponse.json") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/subscriptions/extend/4124214", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(45, decodedJson["extendByDays"] as! Int)
            XCTAssertEqual(1, decodedJson["extendReasonCode"] as! Int)
            XCTAssertEqual("fdf964a4-233b-486c-aac1-97d8d52688ac", decodedJson["requestIdentifier"] as! String)
        }
        
        let extendRenewalDateRequest = ExtendRenewalDateRequest(
            extendByDays: 45,
            extendReasonCode: ExtendReasonCode.customerSatisfaction,
            requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac")
        
        TestingUtility.confirmCodableInternallyConsistent(extendRenewalDateRequest)
        
        let response = await client.extendSubscriptionRenewalDate(originalTransactionId: "4124214", extendRenewalDateRequest: extendRenewalDateRequest)
        
        guard case .success(let extendRenewalDateResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("2312412", extendRenewalDateResponse.originalTransactionId)
        XCTAssertEqual("9993", extendRenewalDateResponse.webOrderLineItemId)
        XCTAssertEqual(true, extendRenewalDateResponse.success)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), extendRenewalDateResponse.effectiveDate)
        TestingUtility.confirmCodableInternallyConsistent(extendRenewalDateResponse)
    }
    
    public func testGetAllSubscriptionStatuses() async throws {
        let client = try getClientWithBody("resources/models/getAllSubscriptionStatusesResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/subscriptions/4321?status=2&status=1", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.getAllSubscriptionStatuses(transactionId: "4321", status: [Status.expired, Status.active])
        
        guard case .success(let statusResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(AppStoreEnvironment.localTesting, statusResponse.environment)
        XCTAssertEqual("LocalTesting", statusResponse.rawEnvironment)
        XCTAssertEqual("com.example", statusResponse.bundleId)
        XCTAssertEqual(5454545, statusResponse.appAppleId)
        
        let item = SubscriptionGroupIdentifierItem(
            subscriptionGroupIdentifier: "sub_group_one",
            lastTransactions: [
                LastTransactionsItem(
                    status: Status.active,
                    originalTransactionId: "3749183",
                    signedTransactionInfo: "signed_transaction_one",
                    signedRenewalInfo: "signed_renewal_one"
                ), LastTransactionsItem(
                    status: Status.revoked,
                    originalTransactionId: "5314314134",
                    signedTransactionInfo: "signed_transaction_two",
                    signedRenewalInfo: "signed_renewal_two"
                )
            ])
        let secondItem = SubscriptionGroupIdentifierItem(
            subscriptionGroupIdentifier: "sub_group_two",
            lastTransactions: [
                LastTransactionsItem(
                    status: Status.expired,
                    originalTransactionId: "3413453",
                    signedTransactionInfo: "signed_transaction_three",
                    signedRenewalInfo: "signed_renewal_three"
                )])
        XCTAssertEqual([item, secondItem], statusResponse.data)
        TestingUtility.confirmCodableInternallyConsistent(statusResponse)
    }
    
    public func testGetRefundHistory() async throws {
        let client = try getClientWithBody("resources/models/getRefundHistoryResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v2/refund/lookup/555555?revision=revision_input", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.getRefundHistory(transactionId: "555555", revision: "revision_input")
        
        guard case .success(let refundHistoryResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(["signed_transaction_one", "signed_transaction_two"], refundHistoryResponse.signedTransactions)
        XCTAssertEqual("revision_output", refundHistoryResponse.revision)
        XCTAssertEqual(true, refundHistoryResponse.hasMore)
        TestingUtility.confirmCodableInternallyConsistent(refundHistoryResponse)
    }
    
    public func testGetStatusOfSubscriptionRenewalDateExtensions() async throws {
        let client = try getClientWithBody("resources/models/getStatusOfSubscriptionRenewalDateExtensionsResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/subscriptions/extend/mass/20fba8a0-2b80-4a7d-a17f-85c1854727f8/com.example.product", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.getStatusOfSubscriptionRenewalDateExtensions(requestIdentifier: "com.example.product", productId: "20fba8a0-2b80-4a7d-a17f-85c1854727f8")
        
        guard case .success(let massExtendRenewalDateStatusResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("20fba8a0-2b80-4a7d-a17f-85c1854727f8", massExtendRenewalDateStatusResponse.requestIdentifier)
        XCTAssertEqual(true, massExtendRenewalDateStatusResponse.complete)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), massExtendRenewalDateStatusResponse.completeDate)
        XCTAssertEqual(30, massExtendRenewalDateStatusResponse.succeededCount)
        XCTAssertEqual(2, massExtendRenewalDateStatusResponse.failedCount)
        TestingUtility.confirmCodableInternallyConsistent(massExtendRenewalDateStatusResponse)
    }
    
    public func testGetTestNotificationStatus() async throws {
        let client = try getClientWithBody("resources/models/getTestNotificationStatusResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/notifications/test/8cd2974c-f905-492a-bf9a-b2f47c791d19", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.getTestNotificationStatus(testNotificationToken: "8cd2974c-f905-492a-bf9a-b2f47c791d19")
        
        guard case .success(let checkTestNotificationResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_payload", checkTestNotificationResponse.signedPayload)
        let sendAttemptItems = [
            SendAttemptItem(
                attemptDate: Date(timeIntervalSince1970: 1698148900),
                sendAttemptResult: SendAttemptResult.noResponse
            ), SendAttemptItem(
                attemptDate: Date(timeIntervalSince1970: 1698148950),
                sendAttemptResult: SendAttemptResult.success
            )
        ]
        XCTAssertEqual(sendAttemptItems, checkTestNotificationResponse.sendAttempts)
        TestingUtility.confirmCodableInternallyConsistent(checkTestNotificationResponse)
    }
    
    public func testGetNotificationHistory() async throws {
        let client = try getClientWithBody("resources/models/getNotificationHistoryResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/notifications/history?paginationToken=a036bc0e-52b8-4bee-82fc-8c24cb6715d6", request.url)
            
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(1698148900000, decodedJson["startDate"] as! Int)
            XCTAssertEqual(1698148950000, decodedJson["endDate"] as! Int)
            XCTAssertEqual("SUBSCRIBED", decodedJson["notificationType"] as! String)
            XCTAssertEqual("INITIAL_BUY", decodedJson["notificationSubtype"] as! String)
            XCTAssertEqual("999733843", decodedJson["transactionId"] as! String)
            XCTAssertEqual(true, decodedJson["onlyFailures"] as! Bool)
        }
        
        let notificationHistoryRequest = NotificationHistoryRequest(
            startDate: Date(timeIntervalSince1970: 1698148900),
            endDate: Date(timeIntervalSince1970: 1698148950),
            notificationType: NotificationTypeV2.subscribed,
            notificationSubtype: Subtype.initialBuy,
            transactionId: "999733843",
            onlyFailures: true
        )
        
        TestingUtility.confirmCodableInternallyConsistent(notificationHistoryRequest)
        
        let response = await client.getNotificationHistory(paginationToken: "a036bc0e-52b8-4bee-82fc-8c24cb6715d6", notificationHistoryRequest: notificationHistoryRequest)
        
        guard case .success(let notificationHistoryResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("57715481-805a-4283-8499-1c19b5d6b20a", notificationHistoryResponse.paginationToken)
        XCTAssertEqual(true, notificationHistoryResponse.hasMore)
        let expectedNotificationHistory = [
            NotificationHistoryResponseItem(
                signedPayload: "signed_payload_one", sendAttempts: [
                    SendAttemptItem(
                        attemptDate: Date(timeIntervalSince1970: 1698148900),
                        sendAttemptResult: SendAttemptResult.noResponse
                    ),
                    SendAttemptItem(
                        attemptDate: Date(timeIntervalSince1970: 1698148950),
                        sendAttemptResult: SendAttemptResult.success
                    )
                ]
            ),
            NotificationHistoryResponseItem(
                signedPayload: "signed_payload_two", sendAttempts: [
                    SendAttemptItem(
                        attemptDate: Date(timeIntervalSince1970: 1698148800),
                        sendAttemptResult: SendAttemptResult.circularRedirect
                    )
                ]
            )
        ]
        XCTAssertEqual(expectedNotificationHistory, notificationHistoryResponse.notificationHistory)
        TestingUtility.confirmCodableInternallyConsistent(notificationHistoryResponse)
    }
    
    public func testGetNotificationHistoryWithMicrosecondValues() async throws {
        let client = try getClientWithBody("resources/models/getNotificationHistoryResponse.json") { request, body in
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(1698148900000, decodedJson["startDate"] as! Int)
            XCTAssertEqual(1698148950000, decodedJson["endDate"] as! Int)
        }

        let notificationHistoryRequest = NotificationHistoryRequest(
            startDate: Date(timeIntervalSince1970: 1698148900).advanced(by: 0.000_9), // 900 microseconds
            endDate: Date(timeIntervalSince1970: 1698148950).advanced(by: 0.000_001), // 1 microsecond
            notificationType: NotificationTypeV2.subscribed,
            notificationSubtype: Subtype.initialBuy,
            transactionId: "999733843",
            onlyFailures: true
        )

        let _ = await client.getNotificationHistory(paginationToken: "a036bc0e-52b8-4bee-82fc-8c24cb6715d6", notificationHistoryRequest: notificationHistoryRequest)
    }
    
    public func testGetTransactionHistoryV1() async throws {
        let client = try getClientWithBody("resources/models/transactionHistoryResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            let url = request.url
            let urlComponents = URLComponents(string: url)
            XCTAssertEqual("/inApps/v1/history/1234", urlComponents?.path)
            let params: [String: [String]] = (urlComponents?.queryItems?.reduce(into: [String:[String]](), { dict, item in
                dict[item.name, default: []].append(item.value!)
            }))!
            XCTAssertEqual(["revision_input"], params["revision"])
            XCTAssertEqual(["123455"], params["startDate"])
            XCTAssertEqual(["123456"], params["endDate"])
            XCTAssertEqual(["com.example.1", "com.example.2"], params["productId"])
            XCTAssertEqual(["CONSUMABLE", "AUTO_RENEWABLE"], params["productType"])
            XCTAssertEqual(["ASCENDING"], params["sort"])
            XCTAssertEqual(["sub_group_id", "sub_group_id_2"], params["subscriptionGroupIdentifier"])
            XCTAssertEqual(["FAMILY_SHARED"], params["inAppOwnershipType"])
            XCTAssertEqual(["false"], params["revoked"])
            XCTAssertNil(request.body)
        }
        
        let request = TransactionHistoryRequest(
            startDate: Date(timeIntervalSince1970: 123.455),
            endDate: Date(timeIntervalSince1970: 123.456),
            productIds: ["com.example.1", "com.example.2"],
            productTypes: [.consumable, .autoRenewable],
            sort: TransactionHistoryRequest.Order.ascending,
            subscriptionGroupIdentifiers: ["sub_group_id", "sub_group_id_2"],
            inAppOwnershipType: InAppOwnershipType.familyShared,
            revoked: false
        )
        
        let response = await client.getTransactionHistory(transactionId: "1234", revision: "revision_input", transactionHistoryRequest: request)
        
        guard case .success(let historyResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("revision_output", historyResponse.revision)
        XCTAssertEqual(true, historyResponse.hasMore)
        XCTAssertEqual("com.example", historyResponse.bundleId)
        XCTAssertEqual(323232, historyResponse.appAppleId)
        XCTAssertEqual(AppStoreEnvironment.localTesting, historyResponse.environment)
        XCTAssertEqual("LocalTesting", historyResponse.rawEnvironment)
        XCTAssertEqual(["signed_transaction_value", "signed_transaction_value2"], historyResponse.signedTransactions)
        TestingUtility.confirmCodableInternallyConsistent(historyResponse)
    }
    
    public func testGetTransactionHistoryV2() async throws {
        let client = try getClientWithBody("resources/models/transactionHistoryResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            let url = request.url
            let urlComponents = URLComponents(string: url)
            XCTAssertEqual("/inApps/v2/history/1234", urlComponents?.path)
            let params: [String: [String]] = (urlComponents?.queryItems?.reduce(into: [String:[String]](), { dict, item in
                dict[item.name, default: []].append(item.value!)
            }))!
            XCTAssertEqual(["revision_input"], params["revision"])
            XCTAssertEqual(["123455"], params["startDate"])
            XCTAssertEqual(["123456"], params["endDate"])
            XCTAssertEqual(["com.example.1", "com.example.2"], params["productId"])
            XCTAssertEqual(["CONSUMABLE", "AUTO_RENEWABLE"], params["productType"])
            XCTAssertEqual(["ASCENDING"], params["sort"])
            XCTAssertEqual(["sub_group_id", "sub_group_id_2"], params["subscriptionGroupIdentifier"])
            XCTAssertEqual(["FAMILY_SHARED"], params["inAppOwnershipType"])
            XCTAssertEqual(["false"], params["revoked"])
            XCTAssertNil(request.body)
        }
        
        let request = TransactionHistoryRequest(
            startDate: Date(timeIntervalSince1970: 123.455),
            endDate: Date(timeIntervalSince1970: 123.456),
            productIds: ["com.example.1", "com.example.2"],
            productTypes: [.consumable, .autoRenewable],
            sort: TransactionHistoryRequest.Order.ascending,
            subscriptionGroupIdentifiers: ["sub_group_id", "sub_group_id_2"],
            inAppOwnershipType: InAppOwnershipType.familyShared,
            revoked: false
        )
        
        let response = await client.getTransactionHistory(transactionId: "1234", revision: "revision_input", transactionHistoryRequest: request, version: .v2)
        
        guard case .success(let historyResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("revision_output", historyResponse.revision)
        XCTAssertEqual(true, historyResponse.hasMore)
        XCTAssertEqual("com.example", historyResponse.bundleId)
        XCTAssertEqual(323232, historyResponse.appAppleId)
        XCTAssertEqual(AppStoreEnvironment.localTesting, historyResponse.environment)
        XCTAssertEqual("LocalTesting", historyResponse.rawEnvironment)
        XCTAssertEqual(["signed_transaction_value", "signed_transaction_value2"], historyResponse.signedTransactions)
        TestingUtility.confirmCodableInternallyConsistent(historyResponse)
    }
    
    public func testGetTransactionInfo() async throws {
        let client = try getClientWithBody("resources/models/transactionInfoResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/1234", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.getTransactionInfo(transactionId: "1234")
        
        guard case .success(let transactionInfoResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_transaction_info_value", transactionInfoResponse.signedTransactionInfo)
        TestingUtility.confirmCodableInternallyConsistent(transactionInfoResponse)
    }
    
    public func testLookUpOrderId() async throws {
        let client = try getClientWithBody("resources/models/lookupOrderIdResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/lookup/W002182", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.lookUpOrderId(orderId: "W002182")
        
        guard case .success(let orderLookupResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(OrderLookupStatus.invalid, orderLookupResponse.status)
        XCTAssertEqual(1, orderLookupResponse.rawStatus)
        XCTAssertEqual(["signed_transaction_one", "signed_transaction_two"], orderLookupResponse.signedTransactions)
        TestingUtility.confirmCodableInternallyConsistent(orderLookupResponse)
    }
    
    public func testRequestTestNotification() async throws {
        let client = try getClientWithBody("resources/models/requestTestNotificationResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/notifications/test", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.requestTestNotification()
        
        guard case .success(let sendTestNotificationResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("ce3af791-365e-4c60-841b-1674b43c1609", sendTestNotificationResponse.testNotificationToken)
        TestingUtility.confirmCodableInternallyConsistent(sendTestNotificationResponse)
    }
    
    public func testSendConsumptionData() async throws {
        let client = try getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/consumption/49571273", request.url)
            XCTAssertEqual(["application/json"], request.headers["Content-Type"])
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(true, decodedJson["customerConsented"] as! Bool)
            XCTAssertEqual(1, decodedJson["consumptionStatus"] as! Int)
            XCTAssertEqual(2, decodedJson["platform"] as! Int)
            XCTAssertEqual(false, decodedJson["sampleContentProvided"] as! Bool)
            XCTAssertEqual(3, decodedJson["deliveryStatus"] as! Int)
            XCTAssertEqual("7389A31A-FB6D-4569-A2A6-DB7D85D84813", decodedJson["appAccountToken"] as! String)
            XCTAssertEqual(4, decodedJson["accountTenure"] as! Int)
            XCTAssertEqual(5, decodedJson["playTime"] as! Int)
            XCTAssertEqual(6, decodedJson["lifetimeDollarsRefunded"] as! Int)
            XCTAssertEqual(7, decodedJson["lifetimeDollarsPurchased"] as! Int)
            XCTAssertEqual(4, decodedJson["userStatus"] as! Int)
            XCTAssertEqual(3, decodedJson["refundPreference"] as! Int)
        }
        
        let consumptionRequest = ConsumptionRequest(
            customerConsented: true,
            consumptionStatus: ConsumptionStatus.notConsumed,
            platform: Platform.nonApple,
            sampleContentProvided: false,
            deliveryStatus: DeliveryStatus.didNotDeliverDueToServerOutage,
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813"),
            accountTenure: AccountTenure.thirtyDaysToNinetyDays,
            playTime: PlayTime.oneDayToFourDays,
            lifetimeDollarsRefunded: LifetimeDollarsRefunded.oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents,
            lifetimeDollarsPurchased: LifetimeDollarsPurchased.twoThousandDollarsOrGreater,
            userStatus: UserStatus.limitedAccess,
            refundPreference: RefundPreference.noPreference
        )
        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)
        
        let response = await client.sendConsumptionData(transactionId: "49571273", consumptionRequest: consumptionRequest)
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }
    
    public func testSendConsumptionDataWithNullAppAccountToken() async throws {
        let client = try getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/consumption/49571273", request.url)
            XCTAssertEqual(["application/json"], request.headers["Content-Type"])
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(true, decodedJson["customerConsented"] as! Bool)
            XCTAssertEqual(1, decodedJson["consumptionStatus"] as! Int)
            XCTAssertEqual(2, decodedJson["platform"] as! Int)
            XCTAssertEqual(false, decodedJson["sampleContentProvided"] as! Bool)
            XCTAssertEqual(3, decodedJson["deliveryStatus"] as! Int)
            XCTAssertEqual("", decodedJson["appAccountToken"] as! String)
            XCTAssertEqual(4, decodedJson["accountTenure"] as! Int)
            XCTAssertEqual(5, decodedJson["playTime"] as! Int)
            XCTAssertEqual(6, decodedJson["lifetimeDollarsRefunded"] as! Int)
            XCTAssertEqual(7, decodedJson["lifetimeDollarsPurchased"] as! Int)
            XCTAssertEqual(4, decodedJson["userStatus"] as! Int)
        }
        
        let consumptionRequest = ConsumptionRequest(
            customerConsented: true,
            consumptionStatus: ConsumptionStatus.notConsumed,
            platform: Platform.nonApple,
            sampleContentProvided: false,
            deliveryStatus: DeliveryStatus.didNotDeliverDueToServerOutage,
            appAccountToken: nil,
            accountTenure: AccountTenure.thirtyDaysToNinetyDays,
            playTime: PlayTime.oneDayToFourDays,
            lifetimeDollarsRefunded: LifetimeDollarsRefunded.oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents,
            lifetimeDollarsPurchased: LifetimeDollarsPurchased.twoThousandDollarsOrGreater,
            userStatus: UserStatus.limitedAccess
        )
        
        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)
        
        let response = await client.sendConsumptionData(transactionId: "49571273", consumptionRequest: consumptionRequest)
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }
    
    public func testHeaders() async throws {
        let client = try getClientWithBody("resources/models/transactionInfoResponse.json") { request, body in
            let headers = request.headers
            XCTAssertTrue(headers.first(name: "User-Agent")!.starts(with: "app-store-server-library/swift"))
            XCTAssertEqual("application/json", headers.first(name: "Accept"))
            let authorization = headers.first(name: "Authorization")!
            XCTAssertTrue(authorization.starts(with: "Bearer "))
            let tokenComponents = authorization[authorization.index(authorization.startIndex, offsetBy: 7)...]
                .components(separatedBy: ".")
            guard let headerData = Data(base64Encoded: base64URLToBase64(tokenComponents[0])),
                  let payloadData = Data(base64Encoded: base64URLToBase64(tokenComponents[1])) else {
                XCTAssertTrue(false)
                return
            }
            let header = try JSONSerialization.jsonObject(with: headerData) as! [String: Any]
            let payload = try JSONSerialization.jsonObject(with: payloadData) as! [String: Any]
            
            XCTAssertEqual("appstoreconnect-v1", payload["aud"] as! String)
            XCTAssertEqual("issuerId", payload["iss"] as! String)
            XCTAssertEqual("keyId", header["kid"] as! String)
            XCTAssertEqual("com.example", payload["bid"] as! String)
            XCTAssertEqual("ES256", header["alg"] as! String)
        }
        
        let _ = await client.getTransactionInfo(transactionId: "1234")
    }
    
    public func testAPIError() async throws {
        let body = TestingUtility.readFile("resources/models/apiException.json")
        let client = try getAppStoreServerAPIClient(body, .internalServerError, nil)
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(500, statusCode)
        XCTAssertEqual(APIError.generalInternal, apiError)
        XCTAssertEqual(5000000, rawApiError)
        XCTAssertEqual("An unknown error occurred.", errorMessage)
        XCTAssertNil(causedBy)
    }
    
    public func testAPITooManyRequests() async throws {
        let body = TestingUtility.readFile("resources/models/apiTooManyRequestsException.json")
        let client = try getAppStoreServerAPIClient(body, .tooManyRequests, nil)
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(429, statusCode)
        XCTAssertEqual(APIError.rateLimitExceeded, apiError)
        XCTAssertEqual(4290000, rawApiError)
        XCTAssertEqual("Rate limit exceeded.", errorMessage)
        XCTAssertNil(causedBy)
    }
    
    public func testAPIUnknownError() async throws {
        let body = TestingUtility.readFile("resources/models/apiUnknownError.json")
        let client = try getAppStoreServerAPIClient(body, .badRequest, nil)
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, statusCode)
        XCTAssertNil(apiError)
        XCTAssertEqual(9990000, rawApiError)
        XCTAssertEqual("Testing error.", errorMessage)
        XCTAssertNil(causedBy)
    }
    
    public func testDecodingWithUnknownEnumValue() async throws {
        let client = try getClientWithBody("resources/models/transactionHistoryResponseWithMalformedEnvironment.json") { request, body in
        }
        
        let request = TransactionHistoryRequest(
            startDate: Date(timeIntervalSince1970: 123.455),
            endDate: Date(timeIntervalSince1970: 123.456),
            productIds: ["com.example.1", "com.example.2"],
            productTypes: [.consumable, .autoRenewable],
            sort: TransactionHistoryRequest.Order.ascending,
            subscriptionGroupIdentifiers: ["sub_group_id", "sub_group_id_2"],
            inAppOwnershipType: InAppOwnershipType.familyShared,
            revoked: false
        )
        
        let response = await client.getTransactionHistory(transactionId: "1234", revision: "revision_input", transactionHistoryRequest: request, version: .v2)
        
        guard case .success(let historyResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertNil(historyResponse.environment)
        XCTAssertEqual("LocalTestingxxx", historyResponse.rawEnvironment)
    }
    
    public func testDecodingWithMalformedJson() async throws {
        let client = try getClientWithBody("resources/models/transactionHistoryResponseWithMalformedAppAppleId.json") { request, body in
        }
        
        let request = TransactionHistoryRequest(
            startDate: Date(timeIntervalSince1970: 123.455),
            endDate: Date(timeIntervalSince1970: 123.456),
            productIds: ["com.example.1", "com.example.2"],
            productTypes: [.consumable, .autoRenewable],
            sort: TransactionHistoryRequest.Order.ascending,
            subscriptionGroupIdentifiers: ["sub_group_id", "sub_group_id_2"],
            inAppOwnershipType: InAppOwnershipType.familyShared,
            revoked: false
        )
        
        let response = await client.getTransactionHistory(transactionId: "1234", revision: "revision_input", transactionHistoryRequest: request)
        
        guard case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertNil(statusCode)
        XCTAssertNil(rawApiError)
        XCTAssertNil(apiError)
        XCTAssertNil(errorMessage)
        XCTAssertNotNil(causedBy)
    }
    
    public func testXcodeEnvironmentForAppStoreServerAPIClient() async throws {
        let key = getSigningKey()
        do {
            let client = try AppStoreServerAPIClient(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "com.example", environment: AppStoreEnvironment.xcode)
            XCTAssertTrue(false)
            return
        } catch (let e) {
            XCTAssertEqual(AppStoreServerAPIClient.ConfigurationError.invalidEnvironment, e as! AppStoreServerAPIClient.ConfigurationError)
        }
    }

    public func testSetAppAccountToken() async throws {
        let client = try getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/49571273/appAccountToken", request.url)
            XCTAssertEqual(["application/json"], request.headers["Content-Type"])
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("7389A31A-FB6D-4569-A2A6-DB7D85D84813", decodedJson["appAccountToken"] as! String)
        }
        
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813")!
        )
        TestingUtility.confirmCodableInternallyConsistent(updateAppAccountTokenRequest)
        
        let response = await client.setAppAccountToken(originalTransactionId: "49571273", updateAppAccountTokenRequest: updateAppAccountTokenRequest)
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }


    public func testInvalidAppAccountTokenUUIDError() async throws {
        let body = TestingUtility.readFile("resources/models/invalidAppAccountTokenUUIDError.json")
        let client = try getAppStoreServerAPIClient(body, .badRequest, nil)
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813")!
        )
        let result = await client.setAppAccountToken(originalTransactionId: "1234", updateAppAccountTokenRequest: updateAppAccountTokenRequest)
        guard case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, statusCode)
        XCTAssertNotNil(apiError)
        XCTAssertEqual(4000183, rawApiError)
        XCTAssertEqual("Invalid request. The app account token field must be a valid UUID.", errorMessage)
        XCTAssertNil(causedBy)
    }

    public func testFamilySharedTransactionNotSupportedError() async throws {
        let body = TestingUtility.readFile("resources/models/familyTransactionNotSupportedError.json")
        let client = try getAppStoreServerAPIClient(body, .badRequest, nil)
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813")!
        )
        let result = await client.setAppAccountToken(originalTransactionId: "1234", updateAppAccountTokenRequest: updateAppAccountTokenRequest)
        guard case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, statusCode)
        XCTAssertNotNil(apiError)
        XCTAssertEqual(4000185, rawApiError)
        XCTAssertEqual("Invalid request. Family Sharing transactions aren't supported by this endpoint.", errorMessage)
        XCTAssertNil(causedBy)
    }

    public func testTransactionIdNotOriginalTransactionIdError() async throws {
        let body = TestingUtility.readFile("resources/models/transactionIdNotOriginalTransactionId.json")
        let client = try getAppStoreServerAPIClient(body, .badRequest, nil)
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813")!
        )
        let result = await client.setAppAccountToken(originalTransactionId: "1234", updateAppAccountTokenRequest: updateAppAccountTokenRequest)
        guard case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, statusCode)
        XCTAssertNotNil(apiError)
        XCTAssertEqual(4000187, rawApiError)
        XCTAssertEqual("Invalid request. The transaction ID provided is not an original transaction ID.", errorMessage)
        XCTAssertNil(causedBy)
    }
    
    public func getClientWithBody(_ path: String, _ requestVerifier: @escaping RequestVerifier) throws -> AppStoreServerAPIClient {
        let body = TestingUtility.readFile(path)
        return try getAppStoreServerAPIClient(body, requestVerifier)
    }
    
    private func getAppStoreServerAPIClient(_ body: String, _ requestVerifier: @escaping RequestVerifier) throws -> AppStoreServerAPIClient {
        return try getAppStoreServerAPIClient(body, .ok, requestVerifier)
    }
    
    private func getAppStoreServerAPIClient(_ body: String, _ status: HTTPResponseStatus, _ requestVerifier: RequestVerifier?) throws -> AppStoreServerAPIClient {
        let key = getSigningKey()
        let client = try AppStoreServerAPIClientTest(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "com.example", environment: AppStoreEnvironment.localTesting) { request, requestBody in
            try requestVerifier.map { try $0(request, requestBody) }
            let headers = [("Content-Type", "application/json")]
            let bufferedBody = HTTPClientResponse.Body.bytes(.init(string: body))
            return HTTPClientResponse(version: .http1_1, status: status, headers: HTTPHeaders(headers), body: bufferedBody)
        }
        return client
    }
    
    private func getSigningKey() -> String {
        return TestingUtility.readFile("resources/certs/testSigningKey.p8")
    }
    
    class AppStoreServerAPIClientTest: AppStoreServerAPIClient {
        
        private var requestOverride: ((HTTPClientRequest, Data?) throws -> HTTPClientResponse)?
        
        public init(signingKey: String, keyId: String, issuerId: String, bundleId: String, environment: AppStoreEnvironment, requestOverride: @escaping (HTTPClientRequest, Data?) throws -> HTTPClientResponse) throws {
            try super.init(signingKey: signingKey, keyId: keyId, issuerId: issuerId, bundleId: bundleId, environment: environment)
            self.requestOverride = requestOverride
        }
        
        internal override func executeRequest(_ urlRequest: HTTPClientRequest, _ body: Data?) async throws -> HTTPClientResponse {
            return try requestOverride!(urlRequest, body)
        }
    }
}
