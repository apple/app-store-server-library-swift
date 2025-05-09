// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import Crypto
import JWTKit
import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat

public class AppStoreServerAPIClient {

    public enum ConfigurationError: Error, Hashable, Sendable {
        /// Xcode is not a supported environment for an AppStoreServerAPIClient
        case invalidEnvironment
    }
    
    private static let userAgent = "app-store-server-library/swift/3.0.0"
    private static let productionUrl = "https://api.storekit.itunes.apple.com"
    private static let sandboxUrl = "https://api.storekit-sandbox.itunes.apple.com"
    private static let localTestingUrl = "https://local-testing-base-url"
    private static let appStoreConnectAudience = "appstoreconnect-v1"
    
    private let signingKey: P256.Signing.PrivateKey
    private let keyId: String
    private let issuerId: String
    private let bundleId: String
    private let url: String
    private let client: HTTPClient
    ///Create an App Store Server API client
    ///
    ///- Parameter signingKey: Your private key downloaded from App Store Connect
    ///- Parameter issuerId: Your issuer ID from the Keys page in App Store Connect
    ///- Parameter bundleId: Your app’s bundle ID
    ///- Parameter environment: The environment to target
    public init(signingKey: String, keyId: String, issuerId: String, bundleId: String, environment: AppStoreEnvironment) throws {
        self.signingKey = try P256.Signing.PrivateKey(pemRepresentation: signingKey)
        self.keyId = keyId
        self.issuerId = issuerId
        self.bundleId = bundleId
        switch(environment) {
        case .xcode:
            throw ConfigurationError.invalidEnvironment
        case .production:
            self.url = AppStoreServerAPIClient.productionUrl
            break
        case .localTesting:
            self.url = AppStoreServerAPIClient.localTestingUrl
            break
        case .sandbox:
            self.url = AppStoreServerAPIClient.sandboxUrl
            break
        }
        self.client = .init()
    }
    
    deinit {
        try? self.client.syncShutdown()
    }
    
    private func makeRequest<T: Encodable>(path: String, method: HTTPMethod, queryParameters: [String: [String]], body: T?) async -> APIResult<Data> {
        do {
            var queryItems: [URLQueryItem] = []
            for (parameter, values) in queryParameters {
                for val in values {
                    queryItems.append(URLQueryItem(name: parameter, value: val))
                }
            }
            var urlComponents = URLComponents(string: self.url)
            urlComponents?.path = path
            if !queryItems.isEmpty {
                urlComponents?.queryItems = queryItems
            }
            
            guard let url = urlComponents?.url else {
                return APIResult.failure(statusCode: nil, rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: nil)
            }
            
            var urlRequest = HTTPClientRequest(url: url.absoluteString)
            let token = try await generateToken()
            urlRequest.headers.add(name: "User-Agent", value: AppStoreServerAPIClient.userAgent)
            urlRequest.headers.add(name: "Authorization", value: "Bearer \(token)")
            urlRequest.headers.add(name: "Accept", value: "application/json")
            urlRequest.method = method
            
            let requestBody: Data?
            if let b = body {
                let jsonEncoder = getJsonEncoder()
                let encodedBody = try jsonEncoder.encode(b)
                requestBody = encodedBody
                urlRequest.body = .bytes(.init(data: encodedBody))
                urlRequest.headers.add(name: "Content-Type", value: "application/json")
            } else {
                requestBody = nil
            }
            
            let response = try await executeRequest(urlRequest, requestBody)
            var body = try await response.body.collect(upTo: 1024 * 1024)
            guard let data = body.readData(length: body.readableBytes) else {
                throw APIFetchError()
            }
            if response.status.code >= 200 && response.status.code < 300 {
                return APIResult.success(response: data)
            } else if let decodedBody = try? getJsonDecoder().decode(ErrorPayload.self, from: data), let errorCode = decodedBody.errorCode, let errorMessage = decodedBody.errorMessage {
                return APIResult.failure(statusCode: Int(response.status.code), rawApiError: errorCode, apiError: APIError.init(rawValue: errorCode), errorMessage: errorMessage, causedBy: nil)
            } else {
                return APIResult.failure(statusCode: Int(response.status.code), rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: nil)
            }
        } catch (let error) {
            return APIResult.failure(statusCode: nil, rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: error)
        }
    }
    
    // requestBody passed for testing purposes
    internal func executeRequest(_ urlRequest: HTTPClientRequest, _ requestBody: Data?) async throws -> HTTPClientResponse {
        return try await self.client.execute(urlRequest, timeout: .seconds(30))
    }
    
    private func makeRequestWithResponseBody<T: Encodable, R: Decodable>(path: String, method: HTTPMethod, queryParameters: [String: [String]], body: T?) async -> APIResult<R> {
        let response = await makeRequest(path: path, method: method, queryParameters: queryParameters, body: body)
        switch response {
        case .success(let data):
            let decoder = getJsonDecoder()
            do {
                let decodedBody = try decoder.decode(R.self, from: data)
                return APIResult.success(response: decodedBody)
            } catch (let error) {
                return APIResult.failure(statusCode: nil, rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: error)
            }
        case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let error):
            return APIResult.failure(statusCode: statusCode, rawApiError: rawApiError, apiError: apiError, errorMessage: errorMessage, causedBy: error)
        }
    }
    
    private func makeRequestWithoutResponseBody<T: Encodable>(path: String, method: HTTPMethod, queryParameters: [String: [String]], body: T?) async -> APIResult<Void> {
        let response = await makeRequest(path: path, method: method, queryParameters: queryParameters, body: body)
        switch response {
            case .success:
                return APIResult.success(response: ())
            case .failure(let statusCode, let rawApiError, let apiError, let errorMessage, let causedBy):
                return APIResult.failure(statusCode: statusCode, rawApiError: rawApiError, apiError: apiError, errorMessage: errorMessage, causedBy: causedBy)
        }
    }
        
    private func generateToken() async throws -> String {
        let keys = JWTKeyCollection()
        let payload = AppStoreServerAPIJWT(
            exp: .init(value: Date().addingTimeInterval(5 * 60)), // 5 minutes
            iss: .init(value: self.issuerId),
            bid: self.bundleId,
            aud: .init(value: AppStoreServerAPIClient.appStoreConnectAudience),
            iat: .init(value: Date())
        )
        try await keys.add(ecdsa: ECDSA.PrivateKey<P256>(backing: signingKey))
        return try await keys.sign(payload, header: ["typ": "JWT", "kid": .string(self.keyId)])
    }
    
    ///Uses a subscription’s product identifier to extend the renewal date for all of its eligible active subscribers.
    ///
    ///- Parameter massExtendRenewalDateRequest: The request body for extending a subscription renewal date for all of its active subscribers.
    ///- Returns: A response that indicates the server successfully received the subscription-renewal-date extension request, or information about the failure
    ///[Extend Subscription Renewal Dates for All Active Subscribers](https://developer.apple.com/documentation/appstoreserverapi/extend_subscription_renewal_dates_for_all_active_subscribers)
    public func extendRenewalDateForAllActiveSubscribers(massExtendRenewalDateRequest: MassExtendRenewalDateRequest) async -> APIResult<MassExtendRenewalDateResponse> {
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/mass", method: .POST, queryParameters: [:], body: massExtendRenewalDateRequest)
    }
    
    ///Extends the renewal date of a customer’s active subscription using the original transaction identifier.
    ///
    ///- Parameter originalTransactionId:    The original transaction identifier of the subscription receiving a renewal date extension.
    ///- Parameter extendRenewalDateRequest:  The request body containing subscription-renewal-extension data.
    ///- Returns: A response that indicates whether an individual renewal-date extension succeeded, and related details, or information about the failure
    ///[Extend a Subscription Renewal Date](https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date)
    public func extendSubscriptionRenewalDate(originalTransactionId: String, extendRenewalDateRequest: ExtendRenewalDateRequest) async -> APIResult<ExtendRenewalDateResponse> {
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/" + originalTransactionId, method: .PUT, queryParameters: [:], body: extendRenewalDateRequest)
    }
    
    ///Get the statuses for all of a customer’s auto-renewable subscriptions in your app.
    ///- Parameter transactionId: The identifier of a transaction that belongs to the customer, and which may be an original transaction identifier.
    ///- Parameter status: An optional filter that indicates the status of subscriptions to include in the response. Your query may specify more than one status query parameter.
    ///- Returns: A response that contains status information for all of a customer’s auto-renewable subscriptions in your app, or information about the failure
    ///[Get All Subscription Statuses](https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses)
    public func getAllSubscriptionStatuses(transactionId: String, status: [Status]? = nil) async -> APIResult<StatusResponse> {
        let request: String? = nil
        var queryParams: [String: [String]] = [:]
        if let innerStatus = status {
            queryParams["status"] = innerStatus.map { (input) -> String in
                String(input.rawValue)
            }
        }

        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/" + transactionId, method: .GET, queryParameters: queryParams, body: request)
    }
    
    ///Get a paginated list of all of a customer’s refunded in-app purchases for your app.
    ///
    ///- Parameter transactionId: The identifier of a transaction that belongs to the customer, and which may be an original transaction identifier.
    ///- Parameter revision:      A token you provide to get the next set of up to 20 transactions. All responses include a revision token. Use the revision token from the previous RefundHistoryResponse.
    ///- Returns: A response that contains status information for all of a customer’s auto-renewable subscriptions in your app, or information about the failure
    ///[Get Refund History](https://developer.apple.com/documentation/appstoreserverapi/get_refund_history)
    public func getRefundHistory(transactionId: String, revision: String?) async -> APIResult<RefundHistoryResponse> {
        let request: String? = nil
        var queryParams: [String: [String]] = [:]
        if let innerRevision = revision {
            queryParams["revision"] = [innerRevision]
        }
        
        return await makeRequestWithResponseBody(path: "/inApps/v2/refund/lookup/" + transactionId, method: .GET, queryParameters: queryParams, body: request)
    }
    
    ///Checks whether a renewal date extension request completed, and provides the final count of successful or failed extensions.
    ///
    ///- Parameter requestIdentifier: The UUID that represents your request to the Extend Subscription Renewal Dates for All Active Subscribers endpoint.
    ///- Parameter productId:         The product identifier of the auto-renewable subscription that you request a renewal-date extension for.
    ///- Returns: A response that indicates the current status of a request to extend the subscription renewal date to all eligible subscribers, or information about the failure
    ///[Get Status of Subscription Renewal Date Extensions](https://developer.apple.com/documentation/appstoreserverapi/get_status_of_subscription_renewal_date_extensions)
    public func getStatusOfSubscriptionRenewalDateExtensions(requestIdentifier: String, productId: String) async -> APIResult<MassExtendRenewalDateStatusResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/mass/" + productId + "/" + requestIdentifier, method: .GET, queryParameters: [:], body: request)
    }
    
    ///Check the status of the test App Store server notification sent to your server.
    ///
    ///- Parameter testNotificationToken: The test notification token received from the Request a Test Notification endpoint
    ///- Returns: A response that contains the contents of the test notification sent by the App Store server and the result from your server, or information about the failure
    ///[Get Test Notification Status](https://developer.apple.com/documentation/appstoreserverapi/get_test_notification_status)
    public func getTestNotificationStatus(testNotificationToken: String) async -> APIResult<CheckTestNotificationResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/test/" + testNotificationToken, method: .GET, queryParameters: [:], body: request)
    }

    ///See `getTransactionHistory(transactionId: String, revision: String?, transactionHistoryRequest: TransactionHistoryRequest, version: GetTransactionHistoryVersion)`
    @available(*, deprecated)
    public func getTransactionHistory(transactionId: String, revision: String?, transactionHistoryRequest: TransactionHistoryRequest) async -> APIResult<HistoryResponse> {
        return await self.getTransactionHistory(transactionId: transactionId, revision: revision, transactionHistoryRequest: transactionHistoryRequest, version: .v1)
    }
    
    ///Get a customer’s in-app purchase transaction history for your app.
    ///
    ///- Parameter transactionId: The identifier of a transaction that belongs to the customer, and which may be an original transaction identifier.
    ///- Parameter revision:      A token you provide to get the next set of up to 20 transactions. All responses include a revision token. Note: For requests that use the revision token, include the same query parameters from the initial request. Use the revision token from the previous HistoryResponse.
    ///- Parameter version:      The version of the Get Transaction History endpoint to use. V2 is recommended.
    ///- Returns: A response that contains the customer’s transaction history for an app, or information about the failure
    ///[Get Transaction History](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)
    public func getTransactionHistory(transactionId: String, revision: String?, transactionHistoryRequest: TransactionHistoryRequest, version: GetTransactionHistoryVersion) async -> APIResult<HistoryResponse> {
        let request: String? = nil
        var queryParams: [String: [String]] = [:]
        if let innerRevision = revision {
            queryParams["revision"] = [innerRevision]
        }
        if let innerStartDate = transactionHistoryRequest.startDate {
            queryParams["startDate"] = [String(Int64((innerStartDate.timeIntervalSince1970 * 1000).rounded()))]
        }
        if let innerEndDate = transactionHistoryRequest.endDate {
            queryParams["endDate"] = [String(Int64((innerEndDate.timeIntervalSince1970 * 1000).rounded()))]
        }
        if let innerProductIds = transactionHistoryRequest.productIds {
            queryParams["productId"] = innerProductIds
        }
        if let innerProductTypes = transactionHistoryRequest.productTypes {
            queryParams["productType"] = innerProductTypes.map { (input) -> String in
                input.rawValue
            }
        }
        if let innerSort = transactionHistoryRequest.sort {
            queryParams["sort"] = [innerSort.rawValue]
        }
        if let innerSubscriptionGroupIdentifiers = transactionHistoryRequest.subscriptionGroupIdentifiers {
            queryParams["subscriptionGroupIdentifier"] = innerSubscriptionGroupIdentifiers
        }
        if let innerInAppOwnershipType = transactionHistoryRequest.inAppOwnershipType {
            queryParams["inAppOwnershipType"] = [innerInAppOwnershipType.rawValue]
        }
        if let innerRevoked = transactionHistoryRequest.revoked {
            queryParams["revoked"] = [String(innerRevoked)]
        }
        return await makeRequestWithResponseBody(path: "/inApps/" + version.rawValue + "/history/" + transactionId, method: .GET, queryParameters: queryParams, body: request)
    }
    ///Get information about a single transaction for your app.
    ///- Parameter transactionId: The identifier of a transaction that belongs to the customer, and which may be an original transaction identifier.
    ///- Returns: A response that contains signed transaction information for a single transaction.
    ///[Get Transaction Info](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_info)
    public func getTransactionInfo(transactionId: String) async -> APIResult<TransactionInfoResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/transactions/" + transactionId, method: .GET, queryParameters: [:], body: request)
    }
    
    ///Get a customer’s in-app purchases from a receipt using the order ID.
    ///- Parameter orderId: The order ID for in-app purchases that belong to the customer.
    ///- Returns: A response that includes the order lookup status and an array of signed transactions for the in-app purchases in the order, or information about the failure
    ///[Look Up Order ID](https://developer.apple.com/documentation/appstoreserverapi/look_up_order_id)
    public func lookUpOrderId(orderId: String) async -> APIResult<OrderLookupResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/lookup/" + orderId, method: .GET, queryParameters: [:], body: request)
    }
    
    ///Ask App Store Server Notifications to send a test notification to your server.
    ///
    ///- Returns: A response that contains the test notification token, or information about the failure
    ///
    ///[Request a Test Notification](https://developer.apple.com/documentation/appstoreserverapi/request_a_test_notification)
    public func requestTestNotification() async -> APIResult<SendTestNotificationResponse> {
        let body: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/test", method: .POST, queryParameters: [:], body: body)
    }
    
    ///Get a list of notifications that the App Store server attempted to send to your server.
    ///
    ///- Parameter paginationToken: An optional token you use to get the next set of up to 20 notification history records. All responses that have more records available include a paginationToken. Omit this parameter the first time you call this endpoint.
    ///- Parameter notificationHistoryRequest: The request body that includes the start and end dates, and optional query constraints.
    ///- Returns: A response that contains the App Store Server Notifications history for your app.
    ///[Get Notification History](https://developer.apple.com/documentation/appstoreserverapi/get_notification_history)
    public func getNotificationHistory(paginationToken: String?, notificationHistoryRequest: NotificationHistoryRequest) async -> APIResult<NotificationHistoryResponse> {
        var queryParams: [String: [String]] = [:]
        if let innerPaginationToken = paginationToken {
            queryParams["paginationToken"] = [innerPaginationToken]
        }
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/history", method: .POST, queryParameters: queryParams, body: notificationHistoryRequest)
    }

    ///Send consumption information about a consumable in-app purchase to the App Store after your server receives a consumption request notification.
    ///
    ///- Parameter transactionId: The transaction identifier for which you’re providing consumption information. You receive this identifier in the CONSUMPTION_REQUEST notification the App Store sends to your server.
    ///- Parameter consumptionRequest :   The request body containing consumption information.
    ///- Returns: Success, or information about the failure
    ///[Send Consumption Information](https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information)
    public func sendConsumptionData(transactionId: String, consumptionRequest: ConsumptionRequest) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/transactions/consumption/" + transactionId, method: .PUT, queryParameters: [:], body: consumptionRequest)
    }
    
    internal struct AppStoreServerAPIJWT: JWTPayload, Equatable {
        var exp: ExpirationClaim
        var iss: IssuerClaim
        var bid: String
        var aud: AudienceClaim
        var iat: IssuedAtClaim
        func verify(using algorithm: some JWTAlgorithm) async throws {
            fatalError("Do not attempt to locally verify a JWT")
        }
    }
    
    private struct APIFetchError: Error {}
}

public enum APIResult<T> {
    case success(response: T)
    case failure(statusCode: Int?, rawApiError: Int64?, apiError: APIError?, errorMessage: String?, causedBy: Error?)
}

extension APIResult: Sendable where T: Sendable {}

public enum APIError: Int64, Hashable, Sendable {
    ///An error that indicates an invalid request.
    ///
    ///[GeneralBadRequestError](https://developer.apple.com/documentation/appstoreserverapi/generalbadrequesterror)
    case generalBadRequest = 4000000

    ///An error that indicates an invalid app identifier.
    ///
    ///[InvalidAppIdentifierError](https://developer.apple.com/documentation/appstoreserverapi/invalidappidentifiererror)
    case invalidAppIdentifier = 4000002

    ///An error that indicates an invalid request revision.
    ///
    ///[InvalidRequestRevisionError](https://developer.apple.com/documentation/appstoreserverapi/invalidrequestrevisionerror)
    case invalidRequestRevision = 4000005

    ///An error that indicates an invalid transaction identifier.
    ///
    ///[InvalidTransactionIdError](https://developer.apple.com/documentation/appstoreserverapi/invalidtransactioniderror)
    case invalidTransactionId = 4000006

    ///An error that indicates an invalid original transaction identifier.
    ///
    ///[InvalidOriginalTransactionIdError](https://developer.apple.com/documentation/appstoreserverapi/invalidoriginaltransactioniderror)
    case invalidOriginalTransactionId = 4000008

    ///An error that indicates an invalid extend-by-days value.
    ///
    ///[InvalidExtendByDaysError](https://developer.apple.com/documentation/appstoreserverapi/invalidextendbydayserror)
    case invalidExtendByDays = 4000009

    ///An error that indicates an invalid reason code.
    ///
    ///[InvalidExtendReasonCodeError](https://developer.apple.com/documentation/appstoreserverapi/invalidextendreasoncodeerror)
    case invalidExtendReasonCode = 4000010

    ///An error that indicates an invalid request identifier.
    ///
    ///[InvalidRequestIdentifierError](https://developer.apple.com/documentation/appstoreserverapi/invalidrequestidentifiererror)
    case invalidRequestIdentifier = 4000011

    ///An error that indicates that the start date is earlier than the earliest allowed date.
    ///
    ///[StartDateTooFarInPastError](https://developer.apple.com/documentation/appstoreserverapi/startdatetoofarinpasterror)
    case startDateTooFarInPast = 4000012

    ///An error that indicates that the end date precedes the start date, or the two dates are equal.
    ///
    ///[StartDateAfterEndDateError](https://developer.apple.com/documentation/appstoreserverapi/startdateafterenddateerror)
    case startDateAfterEndDate = 4000013

    ///An error that indicates the pagination token is invalid.
    ///
    ///[InvalidPaginationTokenError](https://developer.apple.com/documentation/appstoreserverapi/invalidpaginationtokenerror)
    case invalidPaginationToken = 4000014

    ///An error that indicates the start date is invalid.
    ///
    ///[InvalidStartDateError](https://developer.apple.com/documentation/appstoreserverapi/invalidstartdateerror)
    case invalidStartDate = 4000015

    ///An error that indicates the end date is invalid.
    ///
    ///[InvalidEndDateError](https://developer.apple.com/documentation/appstoreserverapi/invalidenddateerror)
    case invalidEndDate = 4000016
    
    ///An error that indicates the pagination token expired.
    ///
    ///[PaginationTokenExpiredError](https://developer.apple.com/documentation/appstoreserverapi/paginationtokenexpirederror)
    case paginationTokenExpired = 4000017

    ///An error that indicates the notification type or subtype is invalid.
    ///
    ///[InvalidNotificationTypeError](https://developer.apple.com/documentation/appstoreserverapi/invalidnotificationtypeerror)
    case invalidNotificationType = 4000018

    ///An error that indicates the request is invalid because it has too many constraints applied.
    ///
    ///[MultipleFiltersSuppliedError](https://developer.apple.com/documentation/appstoreserverapi/multiplefilterssuppliederror)
    case multipleFiltersSupplied = 4000019

    ///An error that indicates the test notification token is invalid.
    ///
    ///[InvalidTestNotificationTokenError](https://developer.apple.com/documentation/appstoreserverapi/invalidtestnotificationtokenerror)
    case invalidTestNotificationToken = 4000020

    ///An error that indicates an invalid sort parameter.
    ///
    ///[InvalidSortError](https://developer.apple.com/documentation/appstoreserverapi/invalidsorterror)
    case invalidSort = 4000021

    ///An error that indicates an invalid product type parameter.
    ///
    ///[InvalidProductTypeError](https://developer.apple.com/documentation/appstoreserverapi/invalidproducttypeerror)
    case invalidProductType = 4000022

    ///An error that indicates the product ID parameter is invalid.
    ///
    ///[InvalidProductIdError](https://developer.apple.com/documentation/appstoreserverapi/invalidproductiderror)
    case invalidProductId = 4000023

    ///An error that indicates an invalid subscription group identifier.
    ///
    ///[InvalidSubscriptionGroupIdentifierError](https://developer.apple.com/documentation/appstoreserverapi/invalidsubscriptiongroupidentifiererror)
    case invalidSubscriptionGroupIdentifier = 4000024

    ///An error that indicates the query parameter exclude-revoked is invalid.
    ///
    ///[InvalidExcludeRevokedError](https://developer.apple.com/documentation/appstoreserverapi/invalidexcluderevokederror)
    case invalidExcludeRevoked = 4000025

    ///An error that indicates an invalid in-app ownership type parameter.
    ///
    ///[InvalidInAppOwnershipTypeError](https://developer.apple.com/documentation/appstoreserverapi/invalidinappownershiptypeerror)
    case invalidInAppOwnershipType = 4000026

    ///An error that indicates a required storefront country code is empty.
    ///
    ///[InvalidEmptyStorefrontCountryCodeListError](https://developer.apple.com/documentation/appstoreserverapi/invalidemptystorefrontcountrycodelisterror)
    case invalidEmptyStorefrontCountryCodeList = 4000027

    ///An error that indicates a storefront code is invalid.
    ///
    ///[InvalidStorefrontCountryCodeError](https://developer.apple.com/documentation/appstoreserverapi/invalidstorefrontcountrycodeerror)
    case invalidStorefrontCountryCode = 4000028

    ///An error that indicates the revoked parameter contains an invalid value.
    ///
    ///[InvalidRevokedError](https://developer.apple.com/documentation/appstoreserverapi/invalidrevokederror)
    case invalidRevoked = 4000030

    ///An error that indicates the status parameter is invalid.
    ///
    ///[InvalidStatusError](https://developer.apple.com/documentation/appstoreserverapi/invalidstatuserror)
    case invalidStatus = 4000031

    ///An error that indicates the value of the account tenure field is invalid.
    ///
    ///[InvalidAccountTenureError](https://developer.apple.com/documentation/appstoreserverapi/invalidaccounttenureerror)
    case invalidAccountTenure = 4000032

    ///An error that indicates the value of the app account token field is invalid.
    ///
    ///[InvalidAppAccountTokenError](https://developer.apple.com/documentation/appstoreserverapi/invalidappaccounttokenerror)
    case invalidAppAccountToken = 4000033

    ///An error that indicates the value of the consumption status field is invalid.
    ///
    ///[InvalidConsumptionStatusError](https://developer.apple.com/documentation/appstoreserverapi/invalidconsumptionstatuserror)
    case invalidConsumptionStatus = 4000034

    ///An error that indicates the customer consented field is invalid or doesn’t indicate that the customer consented.
    ///
    ///[InvalidCustomerConsentedError](https://developer.apple.com/documentation/appstoreserverapi/invalidcustomerconsentederror)
    case invalidCustomerConsented = 4000035

    ///An error that indicates the value in the delivery status field is invalid.
    ///
    ///[InvalidDeliveryStatusError](https://developer.apple.com/documentation/appstoreserverapi/invaliddeliverystatuserror)
    case invalidDeliveryStatus = 4000036

    ///An error that indicates the value in the lifetime dollars purchased field is invalid.
    ///
    ///[InvalidLifetimeDollarsPurchasedError](https://developer.apple.com/documentation/appstoreserverapi/invalidlifetimedollarspurchasederror)
    case invalidLifetimeDollarsPurchased = 4000037

    ///An error that indicates the value in the lifetime dollars refunded field is invalid.
    ///
    ///[InvalidLifetimeDollarsRefundedError](https://developer.apple.com/documentation/appstoreserverapi/invalidlifetimedollarsrefundederror)
    case invalidLifetimeDollarsRefunded = 4000038

    ///An error that indicates the value in the platform field is invalid.
    ///
    ///[InvalidPlatformError](https://developer.apple.com/documentation/appstoreserverapi/invalidplatformerror)
    case invalidPlatform = 4000039

    ///An error that indicates the value in the playtime field is invalid.
    ///
    ///[InvalidPlayTimeError](https://developer.apple.com/documentation/appstoreserverapi/invalidplaytimeerror)
    case invalidPlayTime = 4000040

    ///An error that indicates the value in the sample content provided field is invalid.
    ///
    ///[InvalidSampleContentProvidedError](https://developer.apple.com/documentation/appstoreserverapi/invalidsamplecontentprovidederror)
    case invalidSampleContentProvided = 4000041

    ///An error that indicates the value in the user status field is invalid.
    ///
    ///[InvalidUserStatusError](https://developer.apple.com/documentation/appstoreserverapi/invaliduserstatuserror)
    case invalidUserStatus = 4000042

    ///An error that indicates the transaction identifier doesn’t represent a consumable in-app purchase.
    ///
    ///[InvalidTransactionNotConsumableError](https://developer.apple.com/documentation/appstoreserverapi/invalidtransactionnotconsumableerror)
    @available(*, deprecated)
    case invalidTransactionNotConsumable = 4000043

    ///An error that indicates the transaction identifier represents an unsupported in-app purchase type.
    ///
    ///[InvalidTransactionTypeNotSupportedError](https://developer.apple.com/documentation/appstoreserverapi/invalidtransactiontypenotsupportederror)
    case invalidTransactionTypeNotSupported = 4000047

    ///An error that indicates the endpoint doesn't support an app transaction ID.
    ///
    ///[AppTransactionIdNotSupportedError](https://developer.apple.com/documentation/appstoreserverapi/apptransactionidnotsupportederror)
    case appTransactionIdNotSupported = 4000048

    ///An error that indicates the subscription doesn't qualify for a renewal-date extension due to its subscription state.
    ///
    ///[SubscriptionExtensionIneligibleError](https://developer.apple.com/documentation/appstoreserverapi/subscriptionextensionineligibleerror)
    case subscriptionExtensionIneligible = 4030004

    ///An error that indicates the subscription doesn’t qualify for a renewal-date extension because it has already received the maximum extensions.
    ///
    ///[SubscriptionMaxExtensionError](https://developer.apple.com/documentation/appstoreserverapi/subscriptionmaxextensionerror)
    case subscriptionMaxExtension = 4030005

    ///An error that indicates a subscription isn't directly eligible for a renewal date extension because the user obtained it through Family Sharing.
    ///
    ///[FamilySharedSubscriptionExtensionIneligibleError](https://developer.apple.com/documentation/appstoreserverapi/familysharedsubscriptionextensionineligibleerror)
    case familySharedSubscriptionExtensionIneligible = 4030007

    ///An error that indicates the App Store account wasn’t found.
    ///
    ///[AccountNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/accountnotfounderror)
    case accountNotFound = 4040001

    ///An error response that indicates the App Store account wasn’t found, but you can try again.
    ///
    ///[AccountNotFoundRetryableError](https://developer.apple.com/documentation/appstoreserverapi/accountnotfoundretryableerror)
    case accountNotFoundRetryable = 4040002

    ///An error that indicates the app wasn’t found.
    ///
    ///[AppNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/appnotfounderror)
    case appNotFound = 4040003

    ///An error response that indicates the app wasn’t found, but you can try again.
    ///
    ///[AppNotFoundRetryableError](https://developer.apple.com/documentation/appstoreserverapi/appnotfoundretryableerror)
    case appNotFoundRetryable = 4040004

    ///An error that indicates an original transaction identifier wasn't found.
    ///
    ///[OriginalTransactionIdNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionidnotfounderror)
    case originalTransactionIdNotFound = 4040005

    ///An error response that indicates the original transaction identifier wasn’t found, but you can try again.
    ///
    ///[OriginalTransactionIdNotFoundRetryableError](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionidnotfoundretryableerror)
    case originalTransactionIdNotFoundRetryable = 4040006

    ///An error that indicates that the App Store server couldn’t find a notifications URL for your app in this environment.
    ///
    ///[ServerNotificationUrlNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/servernotificationurlnotfounderror)
    case serverNotificationUrlNotFound = 4040007

    ///An error that indicates that the test notification token is expired or the test notification status isn’t available.
    ///
    ///[TestNotificationNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/testnotificationnotfounderror)
    case testNotificationNotFound = 4040008

    ///An error that indicates the server didn't find a subscription-renewal-date extension request for the request identifier and product identifier you provided.
    ///
    ///[StatusRequestNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/statusrequestnotfounderror)
    case statusRequestNotFound = 4040009

    ///An error that indicates a transaction identifier wasn't found.
    ///
    ///[TransactionIdNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/transactionidnotfounderror)
    case transactionIdNotFound = 4040010

    ///An error that indicates that the request exceeded the rate limit.
    ///
    ///[RateLimitExceededError](https://developer.apple.com/documentation/appstoreserverapi/ratelimitexceedederror)
    case rateLimitExceeded = 4290000

    ///An error that indicates a general internal error.
    ///
    ///[GeneralInternalError](https://developer.apple.com/documentation/appstoreserverapi/generalinternalerror)
    case generalInternal = 5000000

    ///An error response that indicates an unknown error occurred, but you can try again.
    ///
    ///[GeneralInternalRetryableError](https://developer.apple.com/documentation/appstoreserverapi/generalinternalretryableerror)
    case generalInternalRetryable = 5000001
}

public enum GetTransactionHistoryVersion: String, Hashable, Sendable {
    @available(*, deprecated)
    case v1 = "v1"
    case v2 = "v2"
}
