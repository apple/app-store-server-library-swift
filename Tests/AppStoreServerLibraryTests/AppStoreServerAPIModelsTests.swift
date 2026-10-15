// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

final class AppStoreServerAPIModelsTests: XCTestCase {

    public func testSendAttemptResultUnsupportedCharset() throws {
        XCTAssertEqual("UNSUPPORTED_CHARSET", SendAttemptResult.unsupportedCharset.rawValue)
        XCTAssertEqual(SendAttemptResult.unsupportedCharset, SendAttemptResult(rawValue: "UNSUPPORTED_CHARSET"))

        let json = "{\"attemptDate\": 1698148900000, \"sendAttemptResult\": \"UNSUPPORTED_CHARSET\"}"
        let sendAttemptItem = try getJsonDecoder().decode(SendAttemptItem.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(SendAttemptResult.unsupportedCharset, sendAttemptItem.sendAttemptResult)
        XCTAssertEqual("UNSUPPORTED_CHARSET", sendAttemptItem.rawSendAttemptResult)

        let encoded = try getJsonEncoder().encode(SendAttemptItem(sendAttemptResult: .unsupportedCharset))
        let decodedJson = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("UNSUPPORTED_CHARSET", decodedJson["sendAttemptResult"] as! String)
    }

    public func testDeliveryStatusV1DidNotDeliverDueToInGameCurrencyChange() throws {
        XCTAssertEqual(4, DeliveryStatusV1.didNotDeliverDueToInGameCurrencyChange.rawValue)
        XCTAssertEqual(DeliveryStatusV1.didNotDeliverDueToInGameCurrencyChange, DeliveryStatusV1(rawValue: 4))

        let consumptionRequest = makeConsumptionRequestV1(deliveryStatus: .didNotDeliverDueToInGameCurrencyChange)
        XCTAssertEqual(4, consumptionRequest.rawDeliveryStatus)
        XCTAssertEqual(DeliveryStatusV1.didNotDeliverDueToInGameCurrencyChange, consumptionRequest.deliveryStatus)
    }

    public func testConsumptionRequestDeliveryStatusSetter() throws {
        var consumptionRequest = try ConsumptionRequest(customerConsented: true, deliveryStatus: .delivered, sampleContentProvided: false)
        XCTAssertEqual(DeliveryStatus.delivered, consumptionRequest.deliveryStatus)
        XCTAssertEqual("DELIVERED", consumptionRequest.rawDeliveryStatus)

        consumptionRequest.deliveryStatus = .undeliveredOther
        XCTAssertEqual(DeliveryStatus.undeliveredOther, consumptionRequest.deliveryStatus)
        XCTAssertEqual("UNDELIVERED_OTHER", consumptionRequest.rawDeliveryStatus)

        consumptionRequest.deliveryStatus = nil
        XCTAssertEqual("UNDELIVERED_OTHER", consumptionRequest.rawDeliveryStatus)

        let encoded = try getJsonEncoder().encode(consumptionRequest)
        let decodedJson = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("UNDELIVERED_OTHER", decodedJson["deliveryStatus"] as! String)
        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)
    }

    public func testUpdateAppAccountTokenRequestEncodesLowercaseUUID() throws {
        let updateAppAccountTokenRequest = UpdateAppAccountTokenRequest(appAccountToken: UUID(uuidString: "7389A31A-FB6D-4569-A2A6-DB7D85D84813")!)
        let encoded = try getJsonEncoder().encode(updateAppAccountTokenRequest)
        let decodedJson = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("7389a31a-fb6d-4569-a2a6-db7d85d84813", decodedJson["appAccountToken"] as! String)

        let json = "{\"appAccountToken\": \"7389A31A-FB6D-4569-A2A6-DB7D85D84813\"}"
        let decoded = try getJsonDecoder().decode(UpdateAppAccountTokenRequest.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813"), decoded.appAccountToken)
        TestingUtility.confirmCodableInternallyConsistent(updateAppAccountTokenRequest)
    }

    public func testDateFieldsUseMillisecondsWithAnyEncoderAndDecoder() throws {
        let request = NotificationHistoryRequest(startDate: Date(timeIntervalSince1970: 1698148900.1239), endDate: Date(timeIntervalSince1970: 1698148950), onlyFailures: true)
        let plainData = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: plainData) as! NSDictionary
        XCTAssertEqual(1698148900123, json["startDate"] as! Int64)
        XCTAssertEqual(1698148950000, json["endDate"] as! Int64)
        XCTAssertEqual(try JSONSerialization.jsonObject(with: getJsonEncoder().encode(request)) as! NSDictionary, json)
        let decoded = try JSONDecoder().decode(NotificationHistoryRequest.self, from: plainData)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900.123), decoded.startDate)
        XCTAssertEqual(try getJsonDecoder().decode(NotificationHistoryRequest.self, from: plainData), decoded)

        let item = SendAttemptItem(attemptDate: Date(timeIntervalSince1970: 1698148900.5), sendAttemptResult: .success)
        let itemJson = try JSONSerialization.jsonObject(with: JSONEncoder().encode(item)) as! [String: Any]
        XCTAssertEqual(1698148900500, itemJson["attemptDate"] as! Int64)
        let itemDecoded = try JSONDecoder().decode(SendAttemptItem.self, from: "{\"attemptDate\": 1698148900500.25}".data(using: .utf8)!)
        XCTAssertEqual(Date(timeIntervalSince1970: 1698148900500.25 / 1000.0), itemDecoded.attemptDate)
        let noDate = try JSONSerialization.jsonObject(with: JSONEncoder().encode(SendAttemptItem(sendAttemptResult: .success))) as! [String: Any]
        XCTAssertNil(noDate["attemptDate"])
        XCTAssertNil(try JSONDecoder().decode(SendAttemptItem.self, from: "{}".data(using: .utf8)!).attemptDate)

        let transactionData = TestingUtility.readFile("resources/models/signedTransaction.json").data(using: .utf8)!
        let transaction = try JSONDecoder().decode(JWSTransactionDecodedPayload.self, from: transactionData)
        XCTAssertEqual(try getJsonDecoder().decode(JWSTransactionDecodedPayload.self, from: transactionData), transaction)
        XCTAssertEqual(try JSONSerialization.jsonObject(with: getJsonEncoder().encode(transaction)) as! NSDictionary,
                       try JSONSerialization.jsonObject(with: JSONEncoder().encode(transaction)) as! NSDictionary)
    }

    public func testExtendRenewalDateRequestLimits() throws {
        let identifier128 = String(repeating: "a", count: 128)
        let identifier129 = String(repeating: "a", count: 129)
        for days: Int32 in [1, 90] {
            XCTAssertEqual(days, try ExtendRenewalDateRequest(extendByDays: days, extendReasonCode: .customerSatisfaction, requestIdentifier: identifier128).extendByDays)
            XCTAssertEqual(days, try ExtendRenewalDateRequest(extendByDays: days, rawExtendReasonCode: 99, requestIdentifier: identifier128).extendByDays)
            XCTAssertEqual(days, try MassExtendRenewalDateRequest(requestIdentifier: identifier128, extendByDays: days, extendReasonCode: .customerSatisfaction, productId: "com.example.productId").extendByDays)
            XCTAssertEqual(days, try MassExtendRenewalDateRequest(requestIdentifier: identifier128, extendByDays: days, rawExtendReasonCode: 99, productId: "com.example.productId").extendByDays)
        }
        for days: Int32 in [0, 91] {
            assertThrows(ExtendRenewalDateRequest.ValidationError.extendByDaysOutOfRange, try ExtendRenewalDateRequest(extendByDays: days, extendReasonCode: .customerSatisfaction, requestIdentifier: "id"))
            assertThrows(ExtendRenewalDateRequest.ValidationError.extendByDaysOutOfRange, try ExtendRenewalDateRequest(extendByDays: days, rawExtendReasonCode: 99, requestIdentifier: "id"))
            assertThrows(MassExtendRenewalDateRequest.ValidationError.extendByDaysOutOfRange, try MassExtendRenewalDateRequest(requestIdentifier: "id", extendByDays: days, extendReasonCode: .customerSatisfaction, productId: "com.example.productId"))
            assertThrows(MassExtendRenewalDateRequest.ValidationError.extendByDaysOutOfRange, try MassExtendRenewalDateRequest(requestIdentifier: "id", extendByDays: days, rawExtendReasonCode: 99, productId: "com.example.productId"))
        }
        assertThrows(ExtendRenewalDateRequest.ValidationError.requestIdentifierTooLong, try ExtendRenewalDateRequest(extendByDays: 45, extendReasonCode: .customerSatisfaction, requestIdentifier: identifier129))
        assertThrows(ExtendRenewalDateRequest.ValidationError.requestIdentifierTooLong, try ExtendRenewalDateRequest(extendByDays: 45, rawExtendReasonCode: 99, requestIdentifier: identifier129))
        assertThrows(MassExtendRenewalDateRequest.ValidationError.requestIdentifierTooLong, try MassExtendRenewalDateRequest(requestIdentifier: identifier129, extendByDays: 45, extendReasonCode: .customerSatisfaction, productId: "com.example.productId"))
        assertThrows(MassExtendRenewalDateRequest.ValidationError.requestIdentifierTooLong, try MassExtendRenewalDateRequest(requestIdentifier: identifier129, extendByDays: 45, rawExtendReasonCode: 99, productId: "com.example.productId"))

        XCTAssertEqual(["USA", "CA"], try MassExtendRenewalDateRequest(requestIdentifier: "id", extendByDays: 45, extendReasonCode: .customerSatisfaction, productId: "com.example.productId", storefrontCountryCodes: ["USA", "CA"]).storefrontCountryCodes)
        XCTAssertNil(try MassExtendRenewalDateRequest(requestIdentifier: "id", extendByDays: 45, extendReasonCode: .customerSatisfaction, productId: "com.example.productId", storefrontCountryCodes: nil).storefrontCountryCodes)
        assertThrows(MassExtendRenewalDateRequest.ValidationError.storefrontCountryCodeTooLong, try MassExtendRenewalDateRequest(requestIdentifier: "id", extendByDays: 45, extendReasonCode: .customerSatisfaction, productId: "com.example.productId", storefrontCountryCodes: ["USA", "ABCD"]))
        assertThrows(MassExtendRenewalDateRequest.ValidationError.storefrontCountryCodeTooLong, try MassExtendRenewalDateRequest(requestIdentifier: "id", extendByDays: 45, rawExtendReasonCode: 99, productId: "com.example.productId", storefrontCountryCodes: ["ABCD"]))
    }

    public func testConsumptionRequestConsumptionPercentageLimits() throws {
        for percentage: Int32 in [0, 100000] {
            XCTAssertEqual(percentage, try ConsumptionRequest(customerConsented: true, deliveryStatus: .delivered, sampleContentProvided: false, consumptionPercentage: percentage).consumptionPercentage)
            XCTAssertEqual(percentage, try ConsumptionRequest(customerConsented: true, rawDeliveryStatus: "DELIVERED", sampleContentProvided: false, consumptionPercentage: percentage).consumptionPercentage)
        }
        XCTAssertNil(try ConsumptionRequest(customerConsented: true, deliveryStatus: .delivered, sampleContentProvided: false).consumptionPercentage)
        for percentage: Int32 in [-1, 100001] {
            assertThrows(ConsumptionRequest.ValidationError.consumptionPercentageOutOfRange, try ConsumptionRequest(customerConsented: true, deliveryStatus: .delivered, sampleContentProvided: false, consumptionPercentage: percentage))
            assertThrows(ConsumptionRequest.ValidationError.consumptionPercentageOutOfRange, try ConsumptionRequest(customerConsented: true, rawDeliveryStatus: "DELIVERED", sampleContentProvided: false, consumptionPercentage: percentage))
        }
    }

    private func assertThrows<E: Error & Equatable, T>(_ expected: E, _ expression: @autoclosure () throws -> T, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try expression(), file: file, line: line) { error in
            XCTAssertEqual(expected, error as? E, file: file, line: line)
        }
    }

    public func testJWSTransactionDecodedPayloadReencodesLowercaseAppAccountToken() throws {
        let json = TestingUtility.readFile("resources/models/signedTransaction.json")
        let transaction = try getJsonDecoder().decode(JWSTransactionDecodedPayload.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(UUID(uuidString: "7e3fb20b-4cdb-47cc-936d-99d65f608138"), transaction.appAccountToken)
        let encoded = try getJsonEncoder().encode(transaction)
        let decodedJson = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("7e3fb20b-4cdb-47cc-936d-99d65f608138", decodedJson["appAccountToken"] as? String)
    }

    public func testConsumptionRequestV1EncodesLowercaseAppAccountToken() throws {
        var consumptionRequest = makeConsumptionRequestV1(appAccountToken: UUID(uuidString: "7389A31A-FB6D-4569-A2A6-DB7D85D84813")!)
        var encoded = try getJsonEncoder().encode(consumptionRequest)
        var decodedJson = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("7389a31a-fb6d-4569-a2a6-db7d85d84813", decodedJson["appAccountToken"] as! String)
        XCTAssertEqual(UUID(uuidString: "7389a31a-fb6d-4569-a2a6-db7d85d84813"), consumptionRequest.appAccountToken)
        TestingUtility.confirmCodableInternallyConsistent(consumptionRequest)

        consumptionRequest.appAccountToken = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440000")!
        encoded = try getJsonEncoder().encode(consumptionRequest)
        decodedJson = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("550e8400-e29b-41d4-a716-446655440000", decodedJson["appAccountToken"] as! String)

        consumptionRequest.appAccountToken = nil
        encoded = try getJsonEncoder().encode(consumptionRequest)
        decodedJson = try JSONSerialization.jsonObject(with: encoded) as! [String: Any]
        XCTAssertEqual("", decodedJson["appAccountToken"] as! String)
    }

    public func testConsumptionRequestV1RequiredFields() throws {
        let consumptionRequest = makeConsumptionRequestV1()
        let json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(consumptionRequest)) as! [String: Any]
        XCTAssertEqual(true, json["customerConsented"] as? Bool)
        XCTAssertEqual(1, json["consumptionStatus"] as? Int)
        XCTAssertEqual(1, json["platform"] as? Int)
        XCTAssertEqual(false, json["sampleContentProvided"] as? Bool)
        XCTAssertEqual(0, json["deliveryStatus"] as? Int)
        XCTAssertEqual("", json["appAccountToken"] as? String)
        XCTAssertEqual(0, json["accountTenure"] as? Int)
        XCTAssertEqual(0, json["playTime"] as? Int)
        XCTAssertEqual(0, json["lifetimeDollarsRefunded"] as? Int)
        XCTAssertEqual(0, json["lifetimeDollarsPurchased"] as? Int)
        XCTAssertEqual(0, json["userStatus"] as? Int)
        XCTAssertNil(json["refundPreference"])

        var jsonWithRefundPreference = json
        jsonWithRefundPreference["refundPreference"] = 1
        TestingUtility.confirmRequiredKeys(ConsumptionRequestV1.self, jsonWithRefundPreference, requiredKeys: ["customerConsented", "consumptionStatus", "platform", "sampleContentProvided", "deliveryStatus", "appAccountToken", "accountTenure", "playTime", "lifetimeDollarsRefunded", "lifetimeDollarsPurchased", "userStatus"])
    }

    public func testConsumptionRequestV1RequiredEnumSetters() throws {
        var consumptionRequest = makeConsumptionRequestV1()
        consumptionRequest.consumptionStatus = .fullyConsumed
        XCTAssertEqual(3, consumptionRequest.rawConsumptionStatus)
        consumptionRequest.consumptionStatus = nil
        XCTAssertEqual(3, consumptionRequest.rawConsumptionStatus)
        XCTAssertEqual(ConsumptionStatus.fullyConsumed, consumptionRequest.consumptionStatus)

        let unknownValues = ConsumptionRequestV1(rawAccountTenure: 99, appAccountToken: nil, rawConsumptionStatus: 99, customerConsented: true, rawDeliveryStatus: 99, rawLifetimeDollarsPurchased: 99, rawLifetimeDollarsRefunded: 99, rawPlatform: 99, rawPlayTime: 99, sampleContentProvided: true, rawUserStatus: 99)
        XCTAssertNil(unknownValues.consumptionStatus)
        XCTAssertEqual(99, unknownValues.rawConsumptionStatus)
        XCTAssertNil(unknownValues.userStatus)
        XCTAssertEqual(99, unknownValues.rawUserStatus)
        TestingUtility.confirmCodableInternallyConsistent(unknownValues)
    }

    public func testExtendRenewalDateRequestRequiredFields() throws {
        let request = try ExtendRenewalDateRequest(extendByDays: 45, extendReasonCode: .customerSatisfaction, requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac")
        let json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(request)) as! [String: Any]
        XCTAssertEqual(45, json["extendByDays"] as? Int)
        XCTAssertEqual(1, json["extendReasonCode"] as? Int)
        XCTAssertEqual("fdf964a4-233b-486c-aac1-97d8d52688ac", json["requestIdentifier"] as? String)
        TestingUtility.confirmRequiredKeys(ExtendRenewalDateRequest.self, json, requiredKeys: ["extendByDays", "extendReasonCode", "requestIdentifier"])
    }

    public func testMassExtendRenewalDateRequestRequiredFields() throws {
        let request = try MassExtendRenewalDateRequest(requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac", extendByDays: 45, extendReasonCode: .customerSatisfaction, productId: "com.example.productId")
        XCTAssertNil(request.storefrontCountryCodes)
        var json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(request)) as! [String: Any]
        XCTAssertEqual(45, json["extendByDays"] as? Int)
        XCTAssertEqual(1, json["extendReasonCode"] as? Int)
        XCTAssertEqual("fdf964a4-233b-486c-aac1-97d8d52688ac", json["requestIdentifier"] as? String)
        XCTAssertEqual("com.example.productId", json["productId"] as? String)
        XCTAssertNil(json["storefrontCountryCodes"])
        json["storefrontCountryCodes"] = ["USA", "MEX"]
        TestingUtility.confirmRequiredKeys(MassExtendRenewalDateRequest.self, json, requiredKeys: ["extendByDays", "extendReasonCode", "requestIdentifier", "productId"])
    }

    public func testNotificationHistoryRequestRequiredFields() throws {
        let request = NotificationHistoryRequest(startDate: Date(timeIntervalSince1970: 1698148900), endDate: Date(timeIntervalSince1970: 1698148950))
        var json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(request)) as! [String: Any]
        XCTAssertEqual(1698148900000, json["startDate"] as? Int)
        XCTAssertEqual(1698148950000, json["endDate"] as? Int)
        XCTAssertEqual(2, json.count)
        json["notificationType"] = "SUBSCRIBED"
        json["notificationSubtype"] = "INITIAL_BUY"
        json["transactionId"] = "999733843"
        json["onlyFailures"] = true
        TestingUtility.confirmRequiredKeys(NotificationHistoryRequest.self, json, requiredKeys: ["startDate", "endDate"])
    }

    public func testExtendRenewalDateRequestUnknownExtendReasonCode() throws {
        var request = try ExtendRenewalDateRequest(extendByDays: 45, rawExtendReasonCode: 99, requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac")
        XCTAssertNil(request.extendReasonCode)
        XCTAssertEqual(99, request.rawExtendReasonCode)
        let json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(request)) as! [String: Any]
        XCTAssertEqual(99, json["extendReasonCode"] as? Int)
        let decoded = try getJsonDecoder().decode(ExtendRenewalDateRequest.self, from: JSONSerialization.data(withJSONObject: json))
        XCTAssertEqual(request, decoded)
        XCTAssertNil(decoded.extendReasonCode)
        XCTAssertEqual(99, decoded.rawExtendReasonCode)

        request.extendReasonCode = .serviceIssueOrOutage
        XCTAssertEqual(ExtendReasonCode.serviceIssueOrOutage, request.extendReasonCode)
        XCTAssertEqual(3, request.rawExtendReasonCode)
        request.extendReasonCode = nil
        XCTAssertEqual(3, request.rawExtendReasonCode)

        let typed = try ExtendRenewalDateRequest(extendByDays: 45, extendReasonCode: .other, requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac")
        XCTAssertEqual(ExtendReasonCode.other, typed.extendReasonCode)
        XCTAssertEqual(2, typed.rawExtendReasonCode)
        XCTAssertEqual(typed, try ExtendRenewalDateRequest(extendByDays: 45, rawExtendReasonCode: 2, requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac"))
        TestingUtility.confirmCodableInternallyConsistent(typed)
    }

    public func testMassExtendRenewalDateRequestUnknownExtendReasonCode() throws {
        var request = try MassExtendRenewalDateRequest(requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac", extendByDays: 45, rawExtendReasonCode: 99, productId: "com.example.productId")
        XCTAssertNil(request.extendReasonCode)
        XCTAssertEqual(99, request.rawExtendReasonCode)
        let json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(request)) as! [String: Any]
        XCTAssertEqual(99, json["extendReasonCode"] as? Int)
        let decoded = try getJsonDecoder().decode(MassExtendRenewalDateRequest.self, from: JSONSerialization.data(withJSONObject: json))
        XCTAssertEqual(request, decoded)
        XCTAssertNil(decoded.extendReasonCode)
        XCTAssertEqual(99, decoded.rawExtendReasonCode)

        request.extendReasonCode = .customerSatisfaction
        XCTAssertEqual(ExtendReasonCode.customerSatisfaction, request.extendReasonCode)
        XCTAssertEqual(1, request.rawExtendReasonCode)
        request.extendReasonCode = nil
        XCTAssertEqual(1, request.rawExtendReasonCode)

        let typed = try MassExtendRenewalDateRequest(requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac", extendByDays: 45, extendReasonCode: .serviceIssueOrOutage, productId: "com.example.productId", storefrontCountryCodes: ["USA"])
        XCTAssertEqual(ExtendReasonCode.serviceIssueOrOutage, typed.extendReasonCode)
        XCTAssertEqual(3, typed.rawExtendReasonCode)
        XCTAssertEqual(typed, try MassExtendRenewalDateRequest(requestIdentifier: "fdf964a4-233b-486c-aac1-97d8d52688ac", extendByDays: 45, rawExtendReasonCode: 3, productId: "com.example.productId", storefrontCountryCodes: ["USA"]))
        TestingUtility.confirmCodableInternallyConsistent(typed)
    }

    public func testNotificationHistoryRequestUnknownNotificationTypeAndSubtype() throws {
        let startDate = Date(timeIntervalSince1970: 1698148900)
        let endDate = Date(timeIntervalSince1970: 1698148950)
        var request = NotificationHistoryRequest(startDate: startDate, endDate: endDate, rawNotificationType: "NEW_NOTIFICATION_TYPE", rawNotificationSubtype: "NEW_SUBTYPE")
        XCTAssertNil(request.notificationType)
        XCTAssertNil(request.notificationSubtype)
        XCTAssertEqual("NEW_NOTIFICATION_TYPE", request.rawNotificationType)
        XCTAssertEqual("NEW_SUBTYPE", request.rawNotificationSubtype)
        let json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(request)) as! [String: Any]
        XCTAssertEqual("NEW_NOTIFICATION_TYPE", json["notificationType"] as? String)
        XCTAssertEqual("NEW_SUBTYPE", json["notificationSubtype"] as? String)
        let decoded = try getJsonDecoder().decode(NotificationHistoryRequest.self, from: JSONSerialization.data(withJSONObject: json))
        XCTAssertEqual(request, decoded)
        XCTAssertEqual("NEW_NOTIFICATION_TYPE", decoded.rawNotificationType)
        XCTAssertEqual("NEW_SUBTYPE", decoded.rawNotificationSubtype)

        request.notificationType = .subscribed
        request.notificationSubtype = .initialBuy
        XCTAssertEqual(NotificationTypeV2.subscribed, request.notificationType)
        XCTAssertEqual(Subtype.initialBuy, request.notificationSubtype)
        XCTAssertEqual("SUBSCRIBED", request.rawNotificationType)
        XCTAssertEqual("INITIAL_BUY", request.rawNotificationSubtype)
        request.notificationType = nil
        request.notificationSubtype = nil
        XCTAssertNil(request.rawNotificationType)
        XCTAssertNil(request.rawNotificationSubtype)

        let subtypeOnly = NotificationHistoryRequest(startDate: startDate, endDate: endDate, rawNotificationSubtype: "NEW_SUBTYPE", transactionId: "999733843")
        XCTAssertNil(subtypeOnly.rawNotificationType)
        XCTAssertEqual("NEW_SUBTYPE", subtypeOnly.rawNotificationSubtype)
        XCTAssertEqual("999733843", subtypeOnly.transactionId)
        let neither = NotificationHistoryRequest(startDate: startDate, endDate: endDate, onlyFailures: true)
        XCTAssertNil(neither.rawNotificationType)
        XCTAssertNil(neither.rawNotificationSubtype)

        let typed = NotificationHistoryRequest(startDate: startDate, endDate: endDate, notificationType: .didRenew, notificationSubtype: .billingRecovery)
        XCTAssertEqual(NotificationTypeV2.didRenew, typed.notificationType)
        XCTAssertEqual(Subtype.billingRecovery, typed.notificationSubtype)
        XCTAssertEqual("DID_RENEW", typed.rawNotificationType)
        XCTAssertEqual("BILLING_RECOVERY", typed.rawNotificationSubtype)
        XCTAssertEqual(typed, NotificationHistoryRequest(startDate: startDate, endDate: endDate, rawNotificationType: "DID_RENEW", rawNotificationSubtype: "BILLING_RECOVERY"))
        TestingUtility.confirmCodableInternallyConsistent(typed)
    }

    public func testExternalPurchaseTokenRequiredFields() throws {
        let token = ExternalPurchaseToken(externalPurchaseId: "b2158121-7af9-49d4-9561-1f588205523e", tokenCreationDate: Date(timeIntervalSince1970: 1698148950), appAppleId: 55555, bundleId: "com.example", tokenType: nil)
        var json = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(token)) as! [String: Any]
        XCTAssertEqual("b2158121-7af9-49d4-9561-1f588205523e", json["externalPurchaseId"] as? String)
        XCTAssertEqual(1698148950000, json["tokenCreationDate"] as? Int64)
        XCTAssertEqual(55555, json["appAppleId"] as? Int64)
        XCTAssertEqual("com.example", json["bundleId"] as? String)
        XCTAssertEqual(4, json.count)
        json["tokenType"] = "ACQUISITION"
        json["tokenExpirationDate"] = 1698149000000
        TestingUtility.confirmRequiredKeys(ExternalPurchaseToken.self, json, requiredKeys: ["externalPurchaseId", "tokenCreationDate", "appAppleId", "bundleId"])
    }

    public func testDecodedModelsCheckTheirDocumentedLimits() throws {
        XCTAssertEqual(12, try decode(TransactionCommitmentInfo.self, "{\"billingPeriodNumber\": 12}").billingPeriodNumber)
        XCTAssertEqual(1, try decode(TransactionCommitmentInfo.self, "{\"billingPeriodNumber\": 1}").billingPeriodNumber)
        XCTAssertEqual(100000, try decode(JWSTransactionDecodedPayload.self, "{\"revocationPercentage\": 100000}").revocationPercentage)
        XCTAssertEqual(0, try decode(JWSTransactionDecodedPayload.self, "{\"revocationPercentage\": 0}").revocationPercentage)
        XCTAssertEqual(["USA"], try decode(Summary.self, "{\"storefrontCountryCodes\": [\"USA\"]}").storefrontCountryCodes)
        let requestIdentifier = String(repeating: "a", count: 128)
        XCTAssertEqual(requestIdentifier, try decode(MassExtendRenewalDateResponse.self, "{\"requestIdentifier\": \"\(requestIdentifier)\"}").requestIdentifier)
        XCTAssertEqual(requestIdentifier, try decode(MassExtendRenewalDateStatusResponse.self, "{\"requestIdentifier\": \"\(requestIdentifier)\"}").requestIdentifier)
        let realtimeURL = String(repeating: "a", count: 256)
        XCTAssertEqual(realtimeURL, try decode(RealtimeUrlResponse.self, "{\"realtimeURL\": \"\(realtimeURL)\"}").realtimeURL)

        XCTAssertThrowsError(try decode(TransactionCommitmentInfo.self, "{\"billingPeriodNumber\": 0}"))
        XCTAssertThrowsError(try decode(TransactionCommitmentInfo.self, "{\"billingPeriodNumber\": 13}"))
        XCTAssertThrowsError(try decode(JWSTransactionDecodedPayload.self, "{\"revocationPercentage\": -1}"))
        XCTAssertThrowsError(try decode(JWSTransactionDecodedPayload.self, "{\"revocationPercentage\": 100001}"))
        XCTAssertThrowsError(try decode(Summary.self, "{\"storefrontCountryCodes\": [\"USAA\"]}"))
        XCTAssertThrowsError(try decode(MassExtendRenewalDateResponse.self, "{\"requestIdentifier\": \"\(requestIdentifier)a\"}"))
        XCTAssertThrowsError(try decode(MassExtendRenewalDateStatusResponse.self, "{\"requestIdentifier\": \"\(requestIdentifier)a\"}"))
        XCTAssertThrowsError(try decode(RealtimeUrlResponse.self, "{\"realtimeURL\": \"\(realtimeURL)a\"}"))

        var info = try TransactionCommitmentInfo(billingPeriodNumber: 12)
        info.billingPeriodNumber = 13
        XCTAssertThrowsError(try getJsonEncoder().encode(info))
    }

    private func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
        return try getJsonDecoder().decode(type, from: json.data(using: .utf8)!)
    }

    public func testSummaryRequestIdentifierIsUUID() throws {
        let json = "{\"bundleId\": \"com.example\", \"requestIdentifier\": \"EFB27071-45A4-4ACA-9854-2A1E9146F265\"}"
        let summary = try getJsonDecoder().decode(Summary.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(UUID(uuidString: "efb27071-45a4-4aca-9854-2a1e9146f265"), summary.requestIdentifier)
        let encoded = try JSONSerialization.jsonObject(with: getJsonEncoder().encode(summary)) as! [String: Any]
        XCTAssertEqual("efb27071-45a4-4aca-9854-2a1e9146f265", encoded["requestIdentifier"] as? String)

        let invalid = "{\"bundleId\": \"com.example\", \"requestIdentifier\": \"not-a-uuid\"}"
        XCTAssertThrowsError(try getJsonDecoder().decode(Summary.self, from: invalid.data(using: .utf8)!))
    }

    public func testInitWithoutEnumParametersIsNotAmbiguous() throws {
        let summary = try Summary(bundleId: "com.example")
        XCTAssertEqual("com.example", summary.bundleId)
        XCTAssertNil(summary.rawEnvironment)
        let payload = try JWSTransactionDecodedPayload(transactionId: "23456")
        XCTAssertEqual("23456", payload.transactionId)
        XCTAssertNil(payload.rawType)
    }

    private func makeConsumptionRequestV1(deliveryStatus: DeliveryStatusV1 = .deliveredAndWorkingProperly, appAccountToken: UUID? = nil) -> ConsumptionRequestV1 {
        return ConsumptionRequestV1(accountTenure: .undeclared, appAccountToken: appAccountToken, consumptionStatus: .notConsumed, customerConsented: true, deliveryStatus: deliveryStatus, lifetimeDollarsPurchased: .undeclared, lifetimeDollarsRefunded: .undeclared, platform: .apple, playTime: .undeclared, sampleContentProvided: false, userStatus: .undeclared)
    }
}
