// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat
import JWTKit

final class AppStoreServerAPIClientTests: XCTestCase {

    typealias RequestVerifier = @Sendable (HTTPClientRequest, Data?) throws -> ()
    
    public func testExtendRenewalDateForAllActiveSubscribers() async throws {
        let client = try await getClientWithBody("resources/models/extendRenewalDateForAllActiveSubscribersResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/subscriptions/extend/mass", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(45, decodedJson["extendByDays"] as! Int)
            XCTAssertEqual(1, decodedJson["extendReasonCode"] as! Int)
            XCTAssertEqual("fdf964a4-233b-486c-aac1-97d8d52688ac", decodedJson["requestIdentifier"] as! String)
            XCTAssertEqual(["USA", "MEX"], decodedJson["storefrontCountryCodes"] as! [String])
            XCTAssertEqual("com.example.productId", decodedJson["productId"] as! String)
        }
        
        let extendRenewalDateRequest = try MassExtendRenewalDateRequest(
            requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac",
            extendByDays: 45,
            extendReasonCode: .customerSatisfaction,
            productId: "com.example.productId",
            storefrontCountryCodes: ["USA", "MEX"]
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
        let client = try await getClientWithBody("resources/models/extendSubscriptionRenewalDateResponse.json") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/subscriptions/extend/4124214", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(45, decodedJson["extendByDays"] as! Int)
            XCTAssertEqual(1, decodedJson["extendReasonCode"] as! Int)
            XCTAssertEqual("fdf964a4-233b-486c-aac1-97d8d52688ac", decodedJson["requestIdentifier"] as! String)
        }
        
        let extendRenewalDateRequest = try ExtendRenewalDateRequest(
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

    public func testExtendSubscriptionRenewalDateWithUnknownExtendReasonCode() async throws {
        let client = try await getClientWithBody("resources/models/extendSubscriptionRenewalDateResponse.json") { request, body in
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(99, decodedJson["extendReasonCode"] as! Int)
        }

        let extendRenewalDateRequest = try ExtendRenewalDateRequest(
            extendByDays: 45,
            rawExtendReasonCode: 99,
            requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac")

        let response = await client.extendSubscriptionRenewalDate(originalTransactionId: "4124214", extendRenewalDateRequest: extendRenewalDateRequest)

        guard case .success = response else {
            XCTFail()
            return
        }
    }
    
    public func testGetAllSubscriptionStatuses() async throws {
        let client = try await getClientWithBody("resources/models/getAllSubscriptionStatusesResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/subscriptions/4321?status=2&status=1", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.getAllSubscriptionStatuses(anyTransactionId: "4321", status: [Status.expired, Status.active])
        
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
                    originalTransactionId: "3749183",
                    status: Status.active,
                    signedRenewalInfo: "signed_renewal_one",
                    signedTransactionInfo: "signed_transaction_one"
                ), LastTransactionsItem(
                    originalTransactionId: "5314314134",
                    status: Status.revoked,
                    signedRenewalInfo: "signed_renewal_two",
                    signedTransactionInfo: "signed_transaction_two"
                )
            ])
        let secondItem = SubscriptionGroupIdentifierItem(
            subscriptionGroupIdentifier: "sub_group_two",
            lastTransactions: [
                LastTransactionsItem(
                    originalTransactionId: "3413453",
                    status: Status.expired,
                    signedRenewalInfo: "signed_renewal_three",
                    signedTransactionInfo: "signed_transaction_three"
                )])
        XCTAssertEqual([item, secondItem], statusResponse.data)
        TestingUtility.confirmCodableInternallyConsistent(statusResponse)
    }
    
    public func testGetRefundHistory() async throws {
        let client = try await getClientWithBody("resources/models/getRefundHistoryResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v2/refund/lookup/555555?revision=revision_input", request.url)
            XCTAssertNil(request.body)
        }
        
        let response = await client.getRefundHistory(anyTransactionId: "555555", revision: "revision_input")
        
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
        let client = try await getClientWithBody("resources/models/getStatusOfSubscriptionRenewalDateExtensionsResponse.json") { request, body in
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
        let client = try await getClientWithBody("resources/models/getTestNotificationStatusResponse.json") { request, body in
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
        let client = try await getClientWithBody("resources/models/getNotificationHistoryResponse.json") { request, body in
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
            onlyFailures: true,
            transactionId: "999733843"
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
                sendAttempts: [
                    SendAttemptItem(
                        attemptDate: Date(timeIntervalSince1970: 1698148900),
                        sendAttemptResult: SendAttemptResult.noResponse
                    ),
                    SendAttemptItem(
                        attemptDate: Date(timeIntervalSince1970: 1698148950),
                        sendAttemptResult: SendAttemptResult.success
                    )
                ], signedPayload: "signed_payload_one"
            ),
            NotificationHistoryResponseItem(
                sendAttempts: [
                    SendAttemptItem(
                        attemptDate: Date(timeIntervalSince1970: 1698148800),
                        sendAttemptResult: SendAttemptResult.circularRedirect
                    )
                ], signedPayload: "signed_payload_two"
            )
        ]
        XCTAssertEqual(expectedNotificationHistory, notificationHistoryResponse.notificationHistory)
        TestingUtility.confirmCodableInternallyConsistent(notificationHistoryResponse)
    }
    
    public func testGetNotificationHistoryWithMicrosecondValues() async throws {
        let client = try await getClientWithBody("resources/models/getNotificationHistoryResponse.json") { request, body in
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(1698148900000, decodedJson["startDate"] as! Int)
            XCTAssertEqual(1698148950000, decodedJson["endDate"] as! Int)
        }

        let notificationHistoryRequest = NotificationHistoryRequest(
            startDate: Date(timeIntervalSince1970: 1698148900).advanced(by: 0.000_9), // 900 microseconds
            endDate: Date(timeIntervalSince1970: 1698148950).advanced(by: 0.000_001), // 1 microsecond
            notificationType: NotificationTypeV2.subscribed,
            notificationSubtype: Subtype.initialBuy,
            onlyFailures: true,
            transactionId: "999733843"
        )

        let _ = await client.getNotificationHistory(paginationToken: "a036bc0e-52b8-4bee-82fc-8c24cb6715d6", notificationHistoryRequest: notificationHistoryRequest)
    }

    public func testGetNotificationHistoryWithUnknownNotificationTypeAndSubtype() async throws {
        let client = try await getClientWithBody("resources/models/getNotificationHistoryResponse.json") { request, body in
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("NEW_NOTIFICATION_TYPE", decodedJson["notificationType"] as! String)
            XCTAssertEqual("NEW_SUBTYPE", decodedJson["notificationSubtype"] as! String)
        }

        let notificationHistoryRequest = NotificationHistoryRequest(
            startDate: Date(timeIntervalSince1970: 1698148900),
            endDate: Date(timeIntervalSince1970: 1698148950),
            rawNotificationType: "NEW_NOTIFICATION_TYPE",
            rawNotificationSubtype: "NEW_SUBTYPE"
        )

        let response = await client.getNotificationHistory(paginationToken: nil, notificationHistoryRequest: notificationHistoryRequest)

        guard case .success = response else {
            XCTFail()
            return
        }
    }
    
    public func testGetTransactionHistoryV1() async throws {
        let client = try await getClientWithBody("resources/models/transactionHistoryResponse.json") { request, body in
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
        
        let response = await client.getTransactionHistory(anyTransactionId: "1234", revision: "revision_input", transactionHistoryRequest: request)
        
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
        let client = try await getClientWithBody("resources/models/transactionHistoryResponse.json") { request, body in
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
        
        let response = await client.getTransactionHistory(anyTransactionId: "1234", revision: "revision_input", transactionHistoryRequest: request, version: .v2)
        
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
        let client = try await getClientWithBody("resources/models/transactionInfoResponse.json") { request, body in
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
    
    public func testPathParametersArePercentEncoded() async throws {
        let client = try await getClientWithBody("resources/models/transactionInfoResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/..%2F..%2Fv1%2Fnotifications%2Ftest%3Ffoo%3Dbar%23fragment", request.url)
        }

        let response = await client.getTransactionInfo(transactionId: "../../v1/notifications/test?foo=bar#fragment")

        guard case .success = response else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testMultiplePathParametersArePercentEncoded() async throws {
        let client = try await getClientWithBody("resources/models/getDefaultMessageResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/default/com.example%2Fproduct/en%20US", request.url)
        }

        let response = await client.getDefaultMessage(productId: "com.example/product", locale: "en US")

        guard case .success = response else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testDotAndEmptyPathParametersAreRejected() async throws {
        let client = try await getClientWithBody("resources/models/transactionInfoResponse.json") { request, body in
            XCTAssertTrue(false)
        }

        for pathParameter in ["..", ".", ""] {
            guard case .failure(let failure) = await client.getTransactionInfo(transactionId: pathParameter) else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertNil(failure.statusCode)
            guard case .failure = await client.getDefaultMessage(productId: "com.example", locale: pathParameter) else {
                XCTAssertTrue(false)
                return
            }
        }
    }

    public func testLookUpOrderId() async throws {
        let client = try await getClientWithBody("resources/models/lookupOrderIdResponse.json") { request, body in
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
        let client = try await getClientWithBody("resources/models/requestTestNotificationResponse.json") { request, body in
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
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/consumption/49571273", request.url)
            XCTAssertEqual(["application/json"], request.headers["Content-Type"])
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(true, decodedJson["customerConsented"] as! Bool)
            XCTAssertEqual(1, decodedJson["consumptionStatus"] as! Int)
            XCTAssertEqual(2, decodedJson["platform"] as! Int)
            XCTAssertEqual(false, decodedJson["sampleContentProvided"] as! Bool)
            XCTAssertEqual(3, decodedJson["deliveryStatus"] as! Int)
            XCTAssertEqual("7389a31a-fb6d-4569-a2a6-db7d85d84813", decodedJson["appAccountToken"] as! String)
            XCTAssertEqual(4, decodedJson["accountTenure"] as! Int)
            XCTAssertEqual(5, decodedJson["playTime"] as! Int)
            XCTAssertEqual(6, decodedJson["lifetimeDollarsRefunded"] as! Int)
            XCTAssertEqual(7, decodedJson["lifetimeDollarsPurchased"] as! Int)
            XCTAssertEqual(4, decodedJson["userStatus"] as! Int)
            XCTAssertEqual(3, decodedJson["refundPreference"] as! Int)
        }

        let consumptionRequest = ConsumptionRequestV1(
            accountTenure: AccountTenure.thirtyDaysToNinetyDays,
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813"),
            consumptionStatus: ConsumptionStatus.notConsumed,
            customerConsented: true,
            deliveryStatus: DeliveryStatusV1.didNotDeliverDueToServerOutage,
            lifetimeDollarsPurchased: LifetimeDollarsPurchased.twoThousandDollarsOrGreater,
            lifetimeDollarsRefunded: LifetimeDollarsRefunded.oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents,
            platform: Platform.nonApple,
            playTime: PlayTime.oneDayToFourDays,
            sampleContentProvided: false,
            userStatus: UserStatus.limitedAccess,
            refundPreference: RefundPreferenceV1.noPreference
        )
        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)

        let response = await client.sendConsumptionData(transactionId: "49571273", consumptionRequest: consumptionRequest)
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }
    
    public func testSendConsumptionDataWithNullAppAccountToken() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
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

        let consumptionRequest = ConsumptionRequestV1(
            accountTenure: AccountTenure.thirtyDaysToNinetyDays,
            appAccountToken: nil,
            consumptionStatus: ConsumptionStatus.notConsumed,
            customerConsented: true,
            deliveryStatus: DeliveryStatusV1.didNotDeliverDueToServerOutage,
            lifetimeDollarsPurchased: LifetimeDollarsPurchased.twoThousandDollarsOrGreater,
            lifetimeDollarsRefunded: LifetimeDollarsRefunded.oneThousandDollarsToOneThousandNineHundredNinetyNineDollarsAndNinetyNineCents,
            platform: Platform.nonApple,
            playTime: PlayTime.oneDayToFourDays,
            sampleContentProvided: false,
            userStatus: UserStatus.limitedAccess
        )

        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)

        let response = await client.sendConsumptionData(transactionId: "49571273", consumptionRequest: consumptionRequest)
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testSendConsumptionInformation() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v2/transactions/consumption/49571273", request.url)
            XCTAssertEqual(["application/json"], request.headers["Content-Type"])
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(true, decodedJson["customerConsented"] as! Bool)
            XCTAssertEqual(false, decodedJson["sampleContentProvided"] as! Bool)
            XCTAssertEqual("DELIVERED", decodedJson["deliveryStatus"] as! String)
            XCTAssertEqual(50000, decodedJson["consumptionPercentage"] as! Int)
            XCTAssertEqual("GRANT_FULL", decodedJson["refundPreference"] as! String)
        }

        let consumptionRequest = try ConsumptionRequest(
            customerConsented: true,
            deliveryStatus: DeliveryStatus.delivered,
            sampleContentProvided: false,
            consumptionPercentage: 50000,
            refundPreference: RefundPreference.grantFull
        )
        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)

        let response = await client.sendConsumptionInformation(transactionId: "49571273", consumptionRequest: consumptionRequest)
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testSendConsumptionInformationWithMinimalFields() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v2/transactions/consumption/49571273", request.url)
            XCTAssertEqual(["application/json"], request.headers["Content-Type"])
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual(true, decodedJson["customerConsented"] as! Bool)
            XCTAssertEqual(false, decodedJson["sampleContentProvided"] as! Bool)
            XCTAssertEqual("UNDELIVERED_QUALITY_ISSUE", decodedJson["deliveryStatus"] as! String)
            XCTAssertNil(decodedJson["consumptionPercentage"])
            XCTAssertNil(decodedJson["refundPreference"])
        }

        let consumptionRequest = try ConsumptionRequest(
            customerConsented: true,
            deliveryStatus: DeliveryStatus.undeliveredQualityIssue,
            sampleContentProvided: false
        )
        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)

        let response = await client.sendConsumptionInformation(transactionId: "49571273", consumptionRequest: consumptionRequest)
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testSendConsumptionInformationConsumptionPercentageOutOfRangeError() async throws {
        let body = TestingUtility.readFile("resources/models/consumptionPercentageOutOfRangeError.json")
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let consumptionRequest = try ConsumptionRequest(
            customerConsented: true,
            deliveryStatus: DeliveryStatus.delivered,
            sampleContentProvided: false,
            consumptionPercentage: 100000
        )
        let result = await client.sendConsumptionInformation(transactionId: "49571273", consumptionRequest: consumptionRequest)
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.consumptionPercentageOutOfRange, failure.apiError)
        XCTAssertEqual(4000207, failure.rawApiError)
        XCTAssertEqual("Invalid request. The consumption percentage is outside the valid range.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    
    public func testHeaders() async throws {
        let client = try await getClientWithBody("resources/models/transactionInfoResponse.json") { request, body in
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
            let payloadString = String(decoding: payloadData, as: UTF8.self)
            XCTAssertNotNil(payloadString.range(of: #""iat":[0-9]+[,}]"#, options: .regularExpression))
            XCTAssertNotNil(payloadString.range(of: #""exp":[0-9]+[,}]"#, options: .regularExpression))
            let issuedAt = (payload["iat"] as! NSNumber).int64Value
            let expiration = (payload["exp"] as! NSNumber).int64Value
            XCTAssertLessThanOrEqual(abs(issuedAt - Int64(Date().timeIntervalSince1970)), 60)
            XCTAssertLessThanOrEqual(abs(expiration - issuedAt - 300), 1)
        }
        
        let _ = await client.getTransactionInfo(transactionId: "1234")
    }
    
    public func testAPIError() async throws {
        let body = TestingUtility.readFile("resources/models/apiException.json")
        let client = try await getAppStoreServerAPIClient(body, .internalServerError, nil)
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(500, failure.statusCode)
        XCTAssertEqual(APIError.generalInternal, failure.apiError)
        XCTAssertEqual(5000000, failure.rawApiError)
        XCTAssertEqual("An unknown error occurred.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }
    
    public func testAPITooManyRequests() async throws {
        let body = TestingUtility.readFile("resources/models/apiTooManyRequestsException.json")
        let client = try await getAppStoreServerAPIClient(body, .tooManyRequests, nil)
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(429, failure.statusCode)
        XCTAssertEqual(APIError.rateLimitExceeded, failure.apiError)
        XCTAssertEqual(4290000, failure.rawApiError)
        XCTAssertEqual("Rate limit exceeded.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
        XCTAssertNil(failure.retryAfter)
    }

    public func testAPITooManyRequestsWithRetryAfter() async throws {
        let body = TestingUtility.readFile("resources/models/apiTooManyRequestsException.json")
        let client = try await getAppStoreServerAPIClient(body, .tooManyRequests, nil, [("Retry-After", "1698148900000")])
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(429, failure.statusCode)
        XCTAssertEqual(APIError.rateLimitExceeded, failure.apiError)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900), failure.retryAfter)
        XCTAssertEqual(["1698148900000"], failure.headers["retry-after"])
    }

    public func testAPITooManyRequestsWithMalformedRetryAfter() async throws {
        let body = TestingUtility.readFile("resources/models/apiTooManyRequestsException.json")
        let rawRetryAfterValues = ["", " ", "not-a-number", "1698148900000.0", "+1698148900000",
                                   "-1698148900000", "1698148900000abc", "99999999999999999999",
                                   "Wed, 21 Oct 2015 07:28:00 GMT"]
        for rawRetryAfter in rawRetryAfterValues {
            let client = try await getAppStoreServerAPIClient(body, .tooManyRequests, nil, [("Retry-After", rawRetryAfter)])
            let result = await client.getTransactionInfo(transactionId: "1234")
            guard case .failure(let failure) = result else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertEqual(429, failure.statusCode)
            XCTAssertNil(failure.retryAfter, "Expected no retryAfter for raw value \"\(rawRetryAfter)\"")
        }
    }
    
    public func testAPIUnknownError() async throws {
        let body = TestingUtility.readFile("resources/models/apiUnknownError.json")
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertNil(failure.apiError)
        XCTAssertEqual(9990000, failure.rawApiError)
        XCTAssertEqual("Testing error.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testAPIErrorWithoutErrorMessage() async throws {
        let client = try await getAppStoreServerAPIClient("{\"errorCode\": 4000006}", .badRequest, nil)
        let result = await client.getTransactionInfo(transactionId: "1234")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.invalidTransactionId, failure.apiError)
        XCTAssertEqual(4000006, failure.rawApiError)
        XCTAssertNil(failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testErrorPayloadInitializer() throws {
        let errorPayload = ErrorPayload(errorCode: 4000006, errorMessage: "Invalid transaction id.")
        XCTAssertEqual(4000006, errorPayload.errorCode)
        XCTAssertEqual("Invalid transaction id.", errorPayload.errorMessage)
        TestingUtility.confirmCodableInternallyConsistent(errorPayload)
        let emptyErrorPayload = ErrorPayload()
        XCTAssertNil(emptyErrorPayload.errorCode)
        XCTAssertNil(emptyErrorPayload.errorMessage)
    }

    public func testAPIErrorCodes() async throws {
        XCTAssertEqual(APIError.invalidRefundPreference, APIError(rawValue: 4000044))
        XCTAssertEqual(APIError.consumptionPercentageOutOfRange, APIError(rawValue: 4000207))
        XCTAssertEqual(APIError.undeliveredConsumptionPercentageNonZero, APIError(rawValue: 4000208))
        XCTAssertEqual(APIError.consumptionPercentageAutoRenewableSubscription, APIError(rawValue: 4000209))
        XCTAssertEqual(APIError.advancedCommerceTransactionNotSupported, APIError(rawValue: 4000210))
        XCTAssertEqual(APIError.invalidAssignedTransactionNotSupported, APIError(rawValue: 4000227))
        XCTAssertEqual(APIError.assignedSubscriptionExtensionIneligible, APIError(rawValue: 4030028))
        XCTAssertEqual(APIError.invalidCurrency, APIError(rawValue: 4000053))
        XCTAssertEqual(APIError.nullRequestInfo, APIError(rawValue: 4000079))
        XCTAssertEqual(APIError.repeatedRequestReferenceId, APIError(rawValue: 4000097))
        XCTAssertEqual(APIError.removalAllNotAllowed, APIError(rawValue: 4000168))
        XCTAssertEqual(APIError.freeTrialOfferMustUsePeriodCountOfOne, APIError(rawValue: 4000223))
        XCTAssertEqual(APIError.unauthorized, APIError(rawValue: 4010000))
        XCTAssertEqual(APIError.subscriptionDoesNotExist, APIError(rawValue: 4030008))
        XCTAssertEqual(APIError.migrationNotAllowedWhenPriceIncreaseCommunicated, APIError(rawValue: 4030027))
        XCTAssertEqual(APIError.productNotFound, APIError(rawValue: 4040016))
    }

    public func testAPIErrorHasOneNamePerErrorCode() async throws {
        XCTAssertEqual(APIError.appTransactionDoesNotExist, APIError(rawValue: 4040019))
        XCTAssertEqual(4040019, APIError.appTransactionDoesNotExist.rawValue)
        XCTAssertEqual(APIError.transactionIdIsNotOriginalTransactionId, APIError(rawValue: 4000187))
        XCTAssertEqual(4000187, APIError.transactionIdIsNotOriginalTransactionId.rawValue)
        switch APIError(rawValue: 4040019) {
        case .appTransactionDoesNotExist:
            break
        default:
            XCTFail()
        }
        switch APIError(rawValue: 4000187) {
        case .transactionIdIsNotOriginalTransactionId:
            break
        default:
            XCTFail()
        }
    }

    public func testQueryParameterWithPlusIsPercentEncoded() async throws {
        let client = try await getClientWithBody("resources/models/getRefundHistoryResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v2/refund/lookup/555555?revision=revision%2Binput%20with%26symbols%3D", request.url)
        }

        let response = await client.getRefundHistory(anyTransactionId: "555555", revision: "revision+input with&symbols=")

        guard case .success = response else {
            XCTAssertTrue(false)
            return
        }
    }
    
    public func testDecodingWithUnknownEnumValue() async throws {
        let client = try await getClientWithBody("resources/models/transactionHistoryResponseWithMalformedEnvironment.json") { request, body in
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
        
        let response = await client.getTransactionHistory(anyTransactionId: "1234", revision: "revision_input", transactionHistoryRequest: request, version: .v2)
        
        guard case .success(let historyResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertNil(historyResponse.environment)
        XCTAssertEqual("LocalTestingxxx", historyResponse.rawEnvironment)
    }
    
    public func testDecodingWithMalformedJson() async throws {
        let client = try await getClientWithBody("resources/models/transactionHistoryResponseWithMalformedAppAppleId.json") { request, body in
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
        
        let response = await client.getTransactionHistory(anyTransactionId: "1234", revision: "revision_input", transactionHistoryRequest: request)
        
        guard case .failure(let failure) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertNil(failure.statusCode)
        XCTAssertNil(failure.rawApiError)
        XCTAssertNil(failure.apiError)
        XCTAssertNil(failure.errorMessage)
        XCTAssertNotNil(failure.causedBy)
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
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/49571273/appAccountToken", request.url)
            XCTAssertEqual(["application/json"], request.headers["Content-Type"])
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("7389a31a-fb6d-4569-a2a6-db7d85d84813", decodedJson["appAccountToken"] as! String)
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
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813")!
        )
        let result = await client.setAppAccountToken(originalTransactionId: "1234", updateAppAccountTokenRequest: updateAppAccountTokenRequest)
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.invalidAppAccountTokenUUID, failure.apiError)
        XCTAssertEqual(4000183, failure.rawApiError)
        XCTAssertEqual("Invalid request. The app account token field must be a valid UUID.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testFamilySharedTransactionNotSupportedError() async throws {
        let body = TestingUtility.readFile("resources/models/familyTransactionNotSupportedError.json")
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813")!
        )
        let result = await client.setAppAccountToken(originalTransactionId: "1234", updateAppAccountTokenRequest: updateAppAccountTokenRequest)
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.familyTransactionNotSupported, failure.apiError)
        XCTAssertEqual(4000185, failure.rawApiError)
        XCTAssertEqual("Invalid request. Family Sharing transactions aren't supported by this endpoint.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testTransactionIdNotOriginalTransactionIdError() async throws {
        let body = TestingUtility.readFile("resources/models/transactionIdNotOriginalTransactionId.json")
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(
            appAccountToken: UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813")!
        )
        let result = await client.setAppAccountToken(originalTransactionId: "1234", updateAppAccountTokenRequest: updateAppAccountTokenRequest)
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.transactionIdIsNotOriginalTransactionId, failure.apiError)
        XCTAssertEqual(4000187, failure.rawApiError)
        XCTAssertEqual("Invalid request. The transaction ID provided is not an original transaction ID.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testUploadImage() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/image/a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", request.url)
            XCTAssertEqual("image/png", request.headers.first(name: "Content-Type"))
            XCTAssertNotNil(body)
            XCTAssertEqual(Data([1, 2, 3]), body)
        }

        let result = await client.uploadImage(imageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, image: Data([1, 2, 3]))
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testDeleteImage() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.DELETE, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/image/a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", request.url)
        }

        let result = await client.deleteImage(imageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testGetImageList() async throws {
        let client = try await getClientWithBody("resources/models/getImageListResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/image/list", request.url)
        }

        let result = await client.getImageList()
        guard case .success(let response) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(1, response.imageIdentifiers?.count)
        XCTAssertEqual(UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, response.imageIdentifiers?[0].imageIdentifier)
        XCTAssertEqual(ImageState.approved, response.imageIdentifiers?[0].imageState)
        XCTAssertEqual(ImageSize.fullSize, response.imageIdentifiers?[0].imageSize)
    }

    public func testUploadMessage() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/message/a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("Header text", decodedJson["header"] as! String)
            XCTAssertEqual("Body text", decodedJson["body"] as! String)
        }

        let uploadMessageRequestBody = try UploadMessageRequestBody(header: "Header text", body: "Body text", image: nil, headerPosition: nil)
        let result = await client.uploadMessage(messageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, uploadMessageRequestBody: uploadMessageRequestBody)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testUploadMessageWithImage() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/message/a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("Header text", decodedJson["header"] as! String)
            XCTAssertEqual("Body text", decodedJson["body"] as! String)
            let image = decodedJson["image"] as! [String: Any]
            XCTAssertEqual("b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901", image["imageIdentifier"] as! String)
            XCTAssertEqual("Alt text", image["altText"] as! String)
        }

        let image = try UploadMessageImage(imageIdentifier: UUID(uuidString: "b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901")!, altText: "Alt text")
        let uploadMessageRequestBody = try UploadMessageRequestBody(header: "Header text", body: "Body text", image: image, headerPosition: nil)
        let result = await client.uploadMessage(messageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, uploadMessageRequestBody: uploadMessageRequestBody)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testDeleteMessage() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.DELETE, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/message/a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", request.url)
        }

        let result = await client.deleteMessage(messageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testGetMessageList() async throws {
        let client = try await getClientWithBody("resources/models/getMessageListResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/message/list", request.url)
        }

        let result = await client.getMessageList()
        guard case .success(let response) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(1, response.messageIdentifiers?.count)
        XCTAssertEqual(UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, response.messageIdentifiers?[0].messageIdentifier)
        XCTAssertEqual(MessageState.approved, response.messageIdentifiers?[0].messageState)
    }

    public func testConfigureDefaultMessage() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/default/com.example.product/en-US", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", decodedJson["messageIdentifier"] as! String)
        }

        let defaultConfigurationRequest = DefaultConfigurationRequest(messageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!)
        let result = await client.configureDefaultMessage(productId: "com.example.product", locale: "en-US", defaultConfigurationRequest: defaultConfigurationRequest)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testDeleteDefaultMessage() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.DELETE, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/default/com.example.product/en-US", request.url)
        }

        let result = await client.deleteDefaultMessage(productId: "com.example.product", locale: "en-US")
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testGetDefaultMessage() async throws {
        let client = try await getClientWithBody("resources/models/getDefaultMessageResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/default/com.example.product/en-US", request.url)
        }

        let result = await client.getDefaultMessage(productId: "com.example.product", locale: "en-US")
        guard case .success(let response) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, response.messageIdentifier)
        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testUploadImageWithImageSize() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/image/a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890?imageSize=FULL_SIZE", request.url)
            XCTAssertEqual("image/png", request.headers.first(name: "Content-Type"))
            XCTAssertNotNil(body)
            XCTAssertEqual(Data([1, 2, 3]), body)
        }

        let result = await client.uploadImage(imageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, image: Data([1, 2, 3]), imageSize: ImageSize.fullSize)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testConfigureRealtimeURL() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/realtime/url", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("https://example.com/realtime", decodedJson["realtimeURL"] as! String)
        }

        let realtimeUrlRequest = try RealtimeUrlRequest(realtimeURL: "https://example.com/realtime")
        TestingUtility.confirmCodableInternallyConsistent(realtimeUrlRequest)
        let result = await client.configureRealtimeURL(realtimeUrlRequest: realtimeUrlRequest)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testDeleteRealtimeURL() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.DELETE, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/realtime/url", request.url)
        }

        let result = await client.deleteRealtimeURL()
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testGetRealtimeURL() async throws {
        let client = try await getClientWithBody("resources/models/getRealtimeUrlResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/realtime/url", request.url)
        }

        let result = await client.getRealtimeURL()
        guard case .success(let response) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("https://example.com/realtime", response.realtimeURL)
        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testInitiatePerformanceTest() async throws {
        let client = try await getClientWithBody("resources/models/performanceTestResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/performanceTest", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("70000500092808", decodedJson["originalTransactionId"] as! String)
        }

        let performanceTestRequest = PerformanceTestRequest(originalTransactionId: "70000500092808")
        TestingUtility.confirmCodableInternallyConsistent(performanceTestRequest)
        let result = await client.initiatePerformanceTest(performanceTestRequest: performanceTestRequest)
        guard case .success(let response) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(10, response.config.maxConcurrentRequests)
        XCTAssertEqual(100, response.config.totalRequests)
        XCTAssertEqual(60000, response.config.totalDuration)
        XCTAssertEqual(500, response.config.responseTimeThreshold)
        XCTAssertEqual(95, response.config.successRateThreshold)
        XCTAssertEqual(UUID(uuidString: "c4b87a1d-2e3f-4a5b-9c6d-7e8f9a0b1c2d"), response.requestId)
        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testGetPerformanceTestResults() async throws {
        let client = try await getClientWithBody("resources/models/performanceTestResultResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/performanceTest/result/c4b87a1d-2e3f-4a5b-9c6d-7e8f9a0b1c2d", request.url)
        }

        let result = await client.getPerformanceTestResults(requestId: UUID(uuidString: "C4B87A1D-2E3F-4A5B-9C6D-7E8F9A0B1C2D")!)
        guard case .success(let response) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(10, response.config.maxConcurrentRequests)
        XCTAssertEqual(100, response.config.totalRequests)
        XCTAssertEqual(60000, response.config.totalDuration)
        XCTAssertEqual(500, response.config.responseTimeThreshold)
        XCTAssertEqual(95, response.config.successRateThreshold)
        XCTAssertEqual("https://example.com/retention", response.target)
        XCTAssertEqual(PerformanceTestStatus.pass, response.result)
        XCTAssertEqual("PASS", response.rawResult)
        XCTAssertEqual(98, response.successRate)
        XCTAssertEqual(0, response.numPending)
        XCTAssertEqual(120, response.responseTimes.average)
        XCTAssertEqual(100, response.responseTimes.p50)
        XCTAssertEqual(200, response.responseTimes.p90)
        XCTAssertEqual(250, response.responseTimes.p95)
        XCTAssertEqual(400, response.responseTimes.p99)
        XCTAssertEqual([SendAttemptResult.timedOut: Int32(1), SendAttemptResult.noResponse: Int32(1)], response.failures)
        XCTAssertEqual(["TIMED_OUT": Int32(1), "NO_RESPONSE": Int32(1)], response.rawFailures)
        TestingUtility.confirmCodableInternallyConsistent(response)
    }

    public func testGetPerformanceTestResultsWithoutRequiredFieldFails() async throws {
        var body = TestingUtility.readJsonObject("resources/models/performanceTestResultResponse.json")
        body.removeValue(forKey: "result")
        let client = try await getAppStoreServerAPIClient(String(decoding: try JSONSerialization.data(withJSONObject: body), as: UTF8.self)) { request, body in
            XCTAssertEqual(.GET, request.method)
        }

        let result = await client.getPerformanceTestResults(requestId: UUID(uuidString: "C4B87A1D-2E3F-4A5B-9C6D-7E8F9A0B1C2D")!)
        guard case .failure(let failure) = result else {
            XCTFail()
            return
        }
        XCTAssertNil(failure.statusCode)
        XCTAssertNil(failure.apiError)
        guard case DecodingError.keyNotFound(let key, _) = failure.causedBy! else {
            XCTFail()
            return
        }
        XCTAssertEqual("result", key.stringValue)
    }

    public func testUploadMessageWithBulletPoints() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.PUT, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/messaging/message/a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890", request.url)
            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("Header text", decodedJson["header"] as! String)
            XCTAssertEqual("Body text", decodedJson["body"] as! String)
            XCTAssertEqual("ABOVE_IMAGE", decodedJson["headerPosition"] as! String)
            let image = decodedJson["image"] as! [String: Any]
            XCTAssertEqual("b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901", image["imageIdentifier"] as! String)
            XCTAssertEqual("Alt text", image["altText"] as! String)
            let bulletPoints = decodedJson["bulletPoints"] as! [[String: Any]]
            XCTAssertEqual(1, bulletPoints.count)
            XCTAssertEqual("Bullet text", bulletPoints[0]["text"] as! String)
            XCTAssertEqual("c3d4e5f6-a7b8-9012-c3d4-e5f6a7b89012", bulletPoints[0]["imageIdentifier"] as! String)
            XCTAssertEqual("Bullet alt text", bulletPoints[0]["altText"] as! String)
        }

        let image = try UploadMessageImage(imageIdentifier: UUID(uuidString: "b2c3d4e5-f6a7-8901-b2c3-d4e5f6a78901")!, altText: "Alt text")
        let bulletPoint = try BulletPoint(altText: "Bullet alt text", imageIdentifier: UUID(uuidString: "c3d4e5f6-a7b8-9012-c3d4-e5f6a7b89012")!, text: "Bullet text")
        let uploadMessageRequestBody = try UploadMessageRequestBody(header: "Header text", body: "Body text", image: image, bulletPoints: [bulletPoint], headerPosition: HeaderPosition.aboveImage)
        TestingUtility.confirmCodableInternallyConsistent(uploadMessageRequestBody)
        let result = await client.uploadMessage(messageIdentifier: UUID(uuidString: "a1b2c3d4-e5f6-7890-a1b2-c3d4e5f67890")!, uploadMessageRequestBody: uploadMessageRequestBody)
        guard case .success = result else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testGetAppTransactionInfo() async throws {
         let client = try await getClientWithBody("resources/models/appTransactionInfoResponse.json") { request, body in
             XCTAssertEqual(.GET, request.method)
             XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/appTransactions/1234", request.url)
             XCTAssertNil(request.body)
         }

         let response = await client.getAppTransactionInfo(anyTransactionId: "1234")

         guard case .success(let appTransactionInfoResponse) = response else {
             XCTAssertTrue(false)
             return
         }
         XCTAssertEqual("signed_app_transaction_info_value", appTransactionInfoResponse.signedAppTransactionInfo)
         TestingUtility.confirmCodableInternallyConsistent(appTransactionInfoResponse)
     }

     public func testGetAppTransactionInfoInvalidTransactionId() async throws {
         let body = TestingUtility.readFile("resources/models/invalidTransactionIdError.json")
         let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
         let result = await client.getAppTransactionInfo(anyTransactionId: "invalid_id")
         guard case .failure(let failure) = result else {
             XCTAssertTrue(false)
             return
         }
         XCTAssertEqual(400, failure.statusCode)
         XCTAssertEqual(APIError.invalidTransactionId, failure.apiError)
         XCTAssertEqual(4000006, failure.rawApiError)
         XCTAssertEqual("Invalid transaction id.", failure.errorMessage)
         XCTAssertNil(failure.causedBy)
     }

     public func testGetAppTransactionInfoTransactionIdNotFound() async throws {
         let body = TestingUtility.readFile("resources/models/transactionIdNotFoundError.json")
         let client = try await getAppStoreServerAPIClient(body, .notFound, nil)
         let result = await client.getAppTransactionInfo(anyTransactionId: "not_found_id")
         guard case .failure(let failure) = result else {
             XCTAssertTrue(false)
             return
         }
         XCTAssertEqual(404, failure.statusCode)
         XCTAssertEqual(APIError.transactionIdNotFound, failure.apiError)
         XCTAssertEqual(4040010, failure.rawApiError)
         XCTAssertEqual("Transaction id not found.", failure.errorMessage)
         XCTAssertNil(failure.causedBy)
     }

     public func testGetAppTransactionInfoAppTransactionDoesNotExist() async throws {
         let body = TestingUtility.readFile("resources/models/appTransactionDoesNotExistError.json")
         let client = try await getAppStoreServerAPIClient(body, .notFound, nil)
         let result = await client.getAppTransactionInfo(anyTransactionId: "no_app_transaction")
         guard case .failure(let failure) = result else {
             XCTAssertTrue(false)
             return
         }
         XCTAssertEqual(404, failure.statusCode)
         XCTAssertEqual(APIError.appTransactionDoesNotExist, failure.apiError)
         XCTAssertEqual(4040019, failure.rawApiError)
         XCTAssertEqual("No AppTransaction exists for the customer.", failure.errorMessage)
         XCTAssertNil(failure.causedBy)
     }

    public func testFinishTransaction() async throws {
        let client = try await getAppStoreServerAPIClient("") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/inApps/v1/transactions/1234/finish", request.url)
            XCTAssertNil(request.body)
        }

        let response = await client.finishTransaction(transactionId: "1234")
        guard case .success(_) = response else {
            XCTAssertTrue(false)
            return
        }
    }

    public func testChangeSubscriptionPrice() async throws {
        let client = try await getClientWithBody("resources/models/advancedCommerceSubscriptionPriceChangeResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/advancedCommerce/v1/subscription/changePrice/4124214", request.url)

            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("7c80bb86-f892-4b21-a919-1357811d6c4f", (decodedJson["requestInfo"] as! [String: Any])["requestReferenceId"] as! String)
            XCTAssertEqual("USD", decodedJson["currency"] as! String)
            XCTAssertEqual("USA", decodedJson["storefront"] as! String)
            let item = (decodedJson["items"] as! [[String: Any]])[0]
            XCTAssertEqual("AD_FREE_1M", item["SKU"] as! String)
            XCTAssertEqual(12990, item["price"] as! Int)
            XCTAssertEqual(["ADVANCED_FEATURES_1M"], item["dependentSKUs"] as! [String])
        }

        let subscriptionPriceChangeRequest = try AdvancedCommerceSubscriptionPriceChangeRequest(
            requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "7c80bb86-f892-4b21-a919-1357811d6c4f")!),
            items: [try AdvancedCommerceSubscriptionPriceChangeItem(sku: "AD_FREE_1M", price: 12990, dependentSKUs: ["ADVANCED_FEATURES_1M"])],
            currency: "USD",
            storefront: "USA"
        )

        TestingUtility.confirmCodableInternallyConsistent(subscriptionPriceChangeRequest)

        let response = await client.changeSubscriptionPrice(transactionId: "4124214", subscriptionPriceChangeRequest: subscriptionPriceChangeRequest)

        guard case .success(let priceChangeResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_renewal_info", priceChangeResponse.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", priceChangeResponse.signedTransactionInfo)
    }

    public func testCancelSubscription() async throws {
        let client = try await getClientWithBody("resources/models/advancedCommerceSubscriptionCancelResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/advancedCommerce/v1/subscription/cancel/4124214", request.url)

            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("932c6903-0ab8-4469-9f21-015f6fab013c", (decodedJson["requestInfo"] as! [String: Any])["requestReferenceId"] as! String)
            XCTAssertEqual("USA", decodedJson["storefront"] as! String)
        }

        let subscriptionCancelRequest = AdvancedCommerceSubscriptionCancelRequest(
            requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "932c6903-0ab8-4469-9f21-015f6fab013c")!),
            storefront: "USA"
        )

        TestingUtility.confirmCodableInternallyConsistent(subscriptionCancelRequest)

        let response = await client.cancelSubscription(transactionId: "4124214", subscriptionCancelRequest: subscriptionCancelRequest)

        guard case .success(let cancelResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_renewal_info", cancelResponse.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", cancelResponse.signedTransactionInfo)
    }

    public func testCancelSubscriptionNotEligibleError() async throws {
        let body = TestingUtility.readFile("resources/models/subscriptionNotEligibleError.json")
        let client = try await getAppStoreServerAPIClient(body, .forbidden, nil)
        let subscriptionCancelRequest = AdvancedCommerceSubscriptionCancelRequest(
            requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "932c6903-0ab8-4469-9f21-015f6fab013c")!),
            storefront: "USA"
        )
        let result = await client.cancelSubscription(transactionId: "4124214", subscriptionCancelRequest: subscriptionCancelRequest)
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(403, failure.statusCode)
        XCTAssertEqual(APIError.subscriptionNotEligible, failure.apiError)
        XCTAssertEqual(4030010, failure.rawApiError)
        XCTAssertEqual("The subscription isn't eligible for the requested changes.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testRevokeSubscription() async throws {
        let client = try await getClientWithBody("resources/models/advancedCommerceSubscriptionRevokeResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/advancedCommerce/v1/subscription/revoke/4124214", request.url)

            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("932c6903-0ab8-4469-9f21-015f6fab013c", (decodedJson["requestInfo"] as! [String: Any])["requestReferenceId"] as! String)
            XCTAssertEqual("UNINTENDED_PURCHASE", decodedJson["refundReason"] as! String)
            XCTAssertEqual(true, decodedJson["refundRiskingPreference"] as! Bool)
            XCTAssertEqual("PRORATED", decodedJson["refundType"] as! String)
            XCTAssertEqual("USA", decodedJson["storefront"] as! String)
        }

        let subscriptionRevokeRequest = AdvancedCommerceSubscriptionRevokeRequest(
            requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "932c6903-0ab8-4469-9f21-015f6fab013c")!),
            refundReason: AdvancedCommerceRefundReason.unintendedPurchase,
            refundRiskingPreference: true,
            refundType: AdvancedCommerceRefundType.prorated,
            storefront: "USA"
        )

        TestingUtility.confirmCodableInternallyConsistent(subscriptionRevokeRequest)

        let response = await client.revokeSubscription(transactionId: "4124214", subscriptionRevokeRequest: subscriptionRevokeRequest)

        guard case .success(let revokeResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_renewal_info", revokeResponse.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", revokeResponse.signedTransactionInfo)
    }

    public func testRequestTransactionRefund() async throws {
        let client = try await getClientWithBody("resources/models/advancedCommerceRequestRefundResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/advancedCommerce/v1/transaction/requestRefund/4124214", request.url)

            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("932c6903-0ab8-4469-9f21-015f6fab013c", (decodedJson["requestInfo"] as! [String: Any])["requestReferenceId"] as! String)
            XCTAssertEqual(true, decodedJson["refundRiskingPreference"] as! Bool)
            XCTAssertEqual("USD", decodedJson["currency"] as! String)
            XCTAssertEqual("USA", decodedJson["storefront"] as! String)
            let item = (decodedJson["items"] as! [[String: Any]])[0]
            XCTAssertEqual("AD_FREE_1M", item["SKU"] as! String)
            XCTAssertEqual("UNSATISFIED_WITH_PURCHASE", item["refundReason"] as! String)
            XCTAssertEqual("FULL", item["refundType"] as! String)
            XCTAssertEqual(true, item["revoke"] as! Bool)
        }

        let requestRefundRequest = try AdvancedCommerceRequestRefundRequest(
            requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "932c6903-0ab8-4469-9f21-015f6fab013c")!),
            items: [try AdvancedCommerceRequestRefundItem(sku: "AD_FREE_1M", refundReason: AdvancedCommerceRefundReason.unsatisfiedWithPurchase, refundType: AdvancedCommerceRefundType.full, revoke: true)],
            refundRiskingPreference: true,
            currency: "USD",
            storefront: "USA"
        )

        TestingUtility.confirmCodableInternallyConsistent(requestRefundRequest)

        let response = await client.requestTransactionRefund(transactionId: "4124214", requestRefundRequest: requestRefundRequest)

        guard case .success(let requestRefundResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_transaction_info_value", requestRefundResponse.signedTransactionInfo)
    }

    public func testChangeSubscriptionMetadata() async throws {
        let client = try await getClientWithBody("resources/models/advancedCommerceSubscriptionChangeMetadataResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/advancedCommerce/v1/subscription/changeMetadata/4124214", request.url)

            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("932c6903-0ab8-4469-9f21-015f6fab013c", (decodedJson["requestInfo"] as! [String: Any])["requestReferenceId"] as! String)
            let descriptors = decodedJson["descriptors"] as! [String: Any]
            XCTAssertEqual("NEXT_BILL_CYCLE", descriptors["effective"] as! String)
            XCTAssertEqual("Remove ads and unlock advanced features.", descriptors["description"] as! String)
            XCTAssertEqual("Ad-free package", descriptors["displayName"] as! String)
            let item = (decodedJson["items"] as! [[String: Any]])[0]
            XCTAssertEqual("AD_FREE_1M", item["currentSKU"] as! String)
            XCTAssertEqual("NEXT_BILL_CYCLE", item["effective"] as! String)
            XCTAssertEqual("AD_FREE_1M_V2", item["SKU"] as! String)
            XCTAssertEqual("USA", decodedJson["storefront"] as! String)
            XCTAssertEqual("C003-00-1", decodedJson["taxCode"] as! String)
        }

        let subscriptionChangeMetadataRequest = AdvancedCommerceSubscriptionChangeMetadataRequest(
            requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "932c6903-0ab8-4469-9f21-015f6fab013c")!),
            descriptors: try AdvancedCommerceSubscriptionChangeMetadataDescriptors(effective: AdvancedCommerceEffective.nextBillCycle, description: "Remove ads and unlock advanced features.", displayName: "Ad-free package"),
            items: [try AdvancedCommerceSubscriptionChangeMetadataItem(currentSku: "AD_FREE_1M", effective: AdvancedCommerceEffective.nextBillCycle, sku: "AD_FREE_1M_V2")],
            storefront: "USA",
            taxCode: "C003-00-1"
        )

        TestingUtility.confirmCodableInternallyConsistent(subscriptionChangeMetadataRequest)

        let response = await client.changeSubscriptionMetadata(transactionId: "4124214", subscriptionChangeMetadataRequest: subscriptionChangeMetadataRequest)

        guard case .success(let changeMetadataResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_renewal_info", changeMetadataResponse.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info", changeMetadataResponse.signedTransactionInfo)
    }

    public func testMigrateSubscriptionToAdvancedCommerceAPI() async throws {
        let client = try await getClientWithBody("resources/models/advancedCommerceSubscriptionMigrateResponse.json") { request, body in
            XCTAssertEqual(.POST, request.method)
            XCTAssertEqual("https://local-testing-base-url/advancedCommerce/v1/subscription/migrate/4124214", request.url)

            let decodedJson = try! JSONSerialization.jsonObject(with: body!) as! [String: Any]
            XCTAssertEqual("932c6903-0ab8-4469-9f21-015f6fab013c", (decodedJson["requestInfo"] as! [String: Any])["requestReferenceId"] as! String)
            let descriptors = decodedJson["descriptors"] as! [String: Any]
            XCTAssertEqual("Remove ads and unlock advanced features.", descriptors["description"] as! String)
            XCTAssertEqual("Ad-free package", descriptors["displayName"] as! String)
            let item = (decodedJson["items"] as! [[String: Any]])[0]
            XCTAssertEqual("AD_FREE_1M", item["SKU"] as! String)
            XCTAssertEqual("Remove ads for the service.", item["description"] as! String)
            XCTAssertEqual("Ad-free monthly plan", item["displayName"] as! String)
            XCTAssertEqual("com.example.base", decodedJson["targetProductId"] as! String)
            XCTAssertEqual("C003-00-1", decodedJson["taxCode"] as! String)
            XCTAssertEqual("USA", decodedJson["storefront"] as! String)
        }

        let subscriptionMigrateRequest = try AdvancedCommerceSubscriptionMigrateRequest(
            requestInfo: AdvancedCommerceRequestInfo(requestReferenceId: UUID(uuidString: "932c6903-0ab8-4469-9f21-015f6fab013c")!),
            descriptors: try AdvancedCommerceSubscriptionMigrateDescriptors(description: "Remove ads and unlock advanced features.", displayName: "Ad-free package"),
            items: [try AdvancedCommerceSubscriptionMigrateItem(sku: "AD_FREE_1M", description: "Remove ads for the service.", displayName: "Ad-free monthly plan")],
            targetProductId: "com.example.base",
            taxCode: "C003-00-1",
            storefront: "USA"
        )

        TestingUtility.confirmCodableInternallyConsistent(subscriptionMigrateRequest)

        let response = await client.migrateSubscriptionToAdvancedCommerceAPI(transactionId: "4124214", subscriptionMigrateRequest: subscriptionMigrateRequest)

        guard case .success(let migrateResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual("signed_renewal_info_value", migrateResponse.signedRenewalInfo)
        XCTAssertEqual("signed_transaction_info_value", migrateResponse.signedTransactionInfo)
    }

    public func testGetCustomerGroups() async throws {
        let client = try await getClientWithBody("resources/models/getCustomerGroupsResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/groups/v1/currentGroups/1234", request.url)
            XCTAssertNil(request.body)
        }

        let response = await client.getCustomerGroups(anyTransactionId: "1234")

        guard case .success(let customerGroupsResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        let expectedGroups = [
            GroupEntry(
                groupId: "900000000000000000",
                groupType: GroupType.organization,
                roles: [
                    RoleEntry(productId: "example.productId.one", role: Role.admin),
                    RoleEntry(productId: "example.productId.two", role: Role.none)
                ]
            ),
            GroupEntry(
                groupId: "900000000000000001",
                groupType: GroupType.consumer
            )
        ]
        XCTAssertEqual(expectedGroups, customerGroupsResponse.groups)
        let organizationGroup = customerGroupsResponse.groups![0]
        XCTAssertEqual(GroupType.organization, organizationGroup.groupType)
        XCTAssertEqual("ORGANIZATION", organizationGroup.rawGroupType)
        XCTAssertEqual(Role.admin, organizationGroup.roles![0].role)
        XCTAssertEqual("ADMIN", organizationGroup.roles![0].rawRole)
        XCTAssertEqual(Role.none, organizationGroup.roles![1].role)
        XCTAssertEqual("NONE", organizationGroup.roles![1].rawRole)
        let consumerGroup = customerGroupsResponse.groups![1]
        XCTAssertEqual(GroupType.consumer, consumerGroup.groupType)
        XCTAssertEqual("CONSUMER", consumerGroup.rawGroupType)
        XCTAssertNil(consumerGroup.roles)
        TestingUtility.confirmCodableInternallyConsistent(customerGroupsResponse)
    }

    public func testGetCustomerGroupsWithUnknownValues() async throws {
        let client = try await getClientWithBody("resources/models/getCustomerGroupsResponseWithUnknownValues.json") { request, body in
        }

        let response = await client.getCustomerGroups(anyTransactionId: "1234")

        guard case .success(let customerGroupsResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(1, customerGroupsResponse.groups?.count)
        let group = customerGroupsResponse.groups![0]
        XCTAssertEqual("900000000000000002", group.groupId)
        XCTAssertNil(group.groupType)
        XCTAssertEqual("UNKNOWN_GROUP_TYPE", group.rawGroupType)
        XCTAssertEqual(1, group.roles?.count)
        let role = group.roles![0]
        XCTAssertEqual("example.productId.three", role.productId)
        XCTAssertNil(role.role)
        XCTAssertEqual("UNKNOWN_ROLE", role.rawRole)
        TestingUtility.confirmCodableInternallyConsistent(customerGroupsResponse)

        var updatedGroup = group
        updatedGroup.groupType = GroupType.consumer
        XCTAssertEqual("CONSUMER", updatedGroup.rawGroupType)
        var updatedRole = role
        updatedRole.role = Role.admin
        XCTAssertEqual("ADMIN", updatedRole.rawRole)
    }

    public func testGetCustomerGroupsInvalidTransactionId() async throws {
        let body = TestingUtility.readFile("resources/models/invalidTransactionIdError.json")
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let result = await client.getCustomerGroups(anyTransactionId: "invalid_id")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.invalidTransactionId, failure.apiError)
        XCTAssertEqual(4000006, failure.rawApiError)
        XCTAssertEqual("Invalid transaction id.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testGetCustomerGroupsTransactionIdNotFound() async throws {
        let body = TestingUtility.readFile("resources/models/transactionIdNotFoundError.json")
        let client = try await getAppStoreServerAPIClient(body, .notFound, nil)
        let result = await client.getCustomerGroups(anyTransactionId: "not_found_id")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(404, failure.statusCode)
        XCTAssertEqual(APIError.transactionIdNotFound, failure.apiError)
        XCTAssertEqual(4040010, failure.rawApiError)
        XCTAssertEqual("Transaction id not found.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testGetGroupMembers() async throws {
        let client = try await getClientWithBody("resources/models/getGroupMembersResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            let urlComponents = URLComponents(string: request.url)
            XCTAssertEqual("/groups/v1/group/900000000000000000", urlComponents?.path)
            let params: [String: [String]] = (urlComponents?.queryItems?.reduce(into: [String:[String]](), { dict, item in
                dict[item.name, default: []].append(item.value!)
            }))!
            XCTAssertEqual(["pagination_token_input"], params["paginationToken"])
            XCTAssertEqual(["50"], params["limit"])
            XCTAssertEqual(2, params.count)
            XCTAssertNil(request.body)
        }

        let response = await client.getGroupMembers(groupId: "900000000000000000", paginationToken: "pagination_token_input", limit: 50)

        guard case .success(let groupMembersResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        let expectedMembers = [
            GroupMemberEntry(appTransactionId: "700000000000000000"),
            GroupMemberEntry(appTransactionId: "700000000000000001")
        ]
        XCTAssertEqual(expectedMembers, groupMembersResponse.members)
        XCTAssertEqual("pagination_token_output", groupMembersResponse.paginationToken)
        XCTAssertEqual(true, groupMembersResponse.hasMore)
        TestingUtility.confirmCodableInternallyConsistent(groupMembersResponse)
    }

    public func testGetGroupMembersWithoutOptionalParameters() async throws {
        let client = try await getClientWithBody("resources/models/getGroupMembersResponse.json") { request, body in
            XCTAssertEqual(.GET, request.method)
            XCTAssertEqual("https://local-testing-base-url/groups/v1/group/900000000000000000", request.url)
            XCTAssertNil(request.body)
        }

        let response = await client.getGroupMembers(groupId: "900000000000000000")

        guard case .success(let groupMembersResponse) = response else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(2, groupMembersResponse.members?.count)
    }

    public func testGetGroupMembersInvalidGroupId() async throws {
        let body = TestingUtility.readFile("resources/models/invalidGroupIdError.json")
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let result = await client.getGroupMembers(groupId: "invalid_group_id")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.invalidGroupId, failure.apiError)
        XCTAssertEqual(4000225, failure.rawApiError)
        XCTAssertEqual("Invalid request. The group ID is invalid.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testGetGroupMembersInvalidLimit() async throws {
        let body = TestingUtility.readFile("resources/models/invalidLimitError.json")
        let client = try await getAppStoreServerAPIClient(body, .badRequest, nil)
        let result = await client.getGroupMembers(groupId: "900000000000000000", limit: 101)
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(400, failure.statusCode)
        XCTAssertEqual(APIError.invalidLimit, failure.apiError)
        XCTAssertEqual(4000004, failure.rawApiError)
        XCTAssertEqual("Invalid request limit.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func testGetGroupMembersGroupNotFound() async throws {
        let body = TestingUtility.readFile("resources/models/groupNotFoundError.json")
        let client = try await getAppStoreServerAPIClient(body, .notFound, nil)
        let result = await client.getGroupMembers(groupId: "900000000000000009")
        guard case .failure(let failure) = result else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(404, failure.statusCode)
        XCTAssertEqual(APIError.groupNotFound, failure.apiError)
        XCTAssertEqual(4040022, failure.rawApiError)
        XCTAssertEqual("Group not found.", failure.errorMessage)
        XCTAssertNil(failure.causedBy)
    }

    public func getClientWithBody(_ path: String, _ requestVerifier: @escaping RequestVerifier) async throws -> AppStoreServerAPIClient {
        let body = TestingUtility.readFile(path)
        return try await getAppStoreServerAPIClient(body, requestVerifier)
    }

    private func getAppStoreServerAPIClient(_ body: String, _ requestVerifier: @escaping RequestVerifier) async throws -> AppStoreServerAPIClient {
        return try await getAppStoreServerAPIClient(body, .ok, requestVerifier)
    }

    private func getAppStoreServerAPIClient(_ body: String, _ status: HTTPResponseStatus, _ requestVerifier: RequestVerifier?) async throws -> AppStoreServerAPIClient {
        return try await getAppStoreServerAPIClient(body, status, requestVerifier, [])
    }

    private func getAppStoreServerAPIClient(_ body: String, _ status: HTTPResponseStatus, _ requestVerifier: RequestVerifier?, _ responseHeaders: [(String, String)]) async throws -> AppStoreServerAPIClient {
        let key = getSigningKey()
        let client = try AppStoreServerAPIClient(signingKey: key, keyId: "keyId", issuerId: "issuerId", bundleId: "com.example", environment: AppStoreEnvironment.localTesting)
        await client.setExecuteRequestOverride { request, requestBody in
            try requestVerifier.map { try $0(request, requestBody) }
            let headers = [("Content-Type", "application/json")] + responseHeaders
            let bufferedBody = HTTPClientResponse.Body.bytes(.init(string: body))
            return HTTPClientResponse(version: .http1_1, status: status, headers: HTTPHeaders(headers), body: bufferedBody)
        }
        return client
    }

    private func getSigningKey() -> String {
        return TestingUtility.readFile("resources/certs/testSigningKey.p8")
    }
}
