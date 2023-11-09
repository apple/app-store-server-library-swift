// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import Crypto
import JWTKit
import AsyncHTTPClient

public class AppStoreServerAPIClient {
    
    private static let userAgent = "app-store-server-library/swift/0.1.0"
    private static let productionUrl = "https://api.storekit.itunes.apple.com"
    private static let sandboxUrl = "https://api.storekit-sandbox.itunes.apple.com"
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
    public init(signingKey: String, keyId: String, issuerId: String, bundleId: String, environment: Environment) throws {
        self.signingKey = try P256.Signing.PrivateKey(pemRepresentation: signingKey)
        self.keyId = keyId
        self.issuerId = issuerId
        self.bundleId = bundleId
        self.url = environment == Environment.production ? AppStoreServerAPIClient.productionUrl : AppStoreServerAPIClient.sandboxUrl
        self.client = .init()
    }
    
    deinit {
        try? self.client.syncShutdown()
    }
    
    private func makeRequest<T: Encodable>(path: String, method: String, queryParameters: [String: [String]], body: T?) async -> APIResult<Foundation.Data> {
        do {
            var queryItems: [URLQueryItem] = []
            for (parameter, values) in queryParameters {
                for val in values {
                    queryItems.append(URLQueryItem(name: parameter, value: val))
                }
            }
            var urlComponents = URLComponents(string: self.url)
            urlComponents?.path = path
            urlComponents?.queryItems = queryItems
            
            guard let url = urlComponents?.url else {
                return APIResult.failure(statusCode: nil, apiError: nil, causedBy: nil)
            }
            
            var urlRequest = URLRequest(url: url)
            let token = try generateToken()
            urlRequest.setValue(AppStoreServerAPIClient.userAgent, forHTTPHeaderField: "User-Agent")
            urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpMethod = method
            
            if let b = body {
                let jsonEncoder = JSONEncoder()
                jsonEncoder.dateEncodingStrategy = .millisecondsSince1970
                let encodedBody = try jsonEncoder.encode(b)
                urlRequest.httpBody = encodedBody
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            let (data, response) = try await withCheckedThrowingContinuation() { (c: CheckedContinuation<(Foundation.Data, URLResponse), Error>) in
                let urlSessionDataTask = URLSession.shared.dataTask(with: urlRequest) {data, response, error in
                    if let e = error {
                        c.resume(throwing: e)
                        return
                    }
                    guard let r = response else {
                        c.resume(throwing: APIFetchError())
                        return
                    }
                    c.resume(returning: (data ?? Foundation.Data(), r))
                }
                urlSessionDataTask.resume()
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                return APIResult.failure(statusCode: nil, apiError: nil, causedBy: nil)
            }
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                return APIResult.success(response: data)
            } else if let decodedBody = try? JSONDecoder().decode(ErrorPayload.self, from: data), let errorCode = decodedBody.errorCode, let apiError = APIError.init(rawValue: errorCode) {
                return APIResult.failure(statusCode: httpResponse.statusCode, apiError: apiError, causedBy: nil)
            } else {
                return APIResult.failure(statusCode: httpResponse.statusCode, apiError: nil, causedBy: nil)
            }
        } catch (let error) {
            return APIResult.failure(statusCode: nil, apiError: nil, causedBy: error)
        }
    }
    
    private func makeRequestWithResponseBody<T: Encodable, R: Decodable>(path: String, method: String, queryParameters: [String: [String]], body: T?) async -> APIResult<R> {
        let response = await makeRequest(path: path, method: method, queryParameters: queryParameters, body: body)
        switch response {
        case .success(let data):
            let decoder = JSONDecoder();
            decoder.dateDecodingStrategy = .millisecondsSince1970
            guard let decodedBody = try? decoder.decode(R.self, from: data) else {
                return APIResult.failure(statusCode: nil, apiError: nil, causedBy: nil)
            }
            return APIResult.success(response: decodedBody)
        case .failure(let statusCode, let apiError, let error):
            return APIResult.failure(statusCode: statusCode, apiError: apiError, causedBy: error)
        }
    }
    
    private func makeRequestWithoutResponseBody<T: Encodable>(path: String, method: String, queryParameters: [String: [String]], body: T?) async -> APIResult<Void> {
        let response = await makeRequest(path: path, method: method, queryParameters: queryParameters, body: body)
        switch response {
            case .success:
                return APIResult.success(response: ())
            case .failure(let statusCode, let apiError, let causedBy):
            return APIResult.failure(statusCode: statusCode, apiError: apiError, causedBy: causedBy)
        }
    }
        
    private func generateToken() throws -> String {
        let signers = JWTSigners()
        let payload = AppStoreServerAPIJWT(
            exp: .init(value: Date().addingTimeInterval(5 * 60)), // 5 minutes
            iss: .init(value: self.issuerId),
            bid: self.bundleId,
            aud: .init(value: AppStoreServerAPIClient.appStoreConnectAudience),
            iat: .init(value: Date())
        )
        let key: ECDSAKey = try ECDSAKey.private(pem: self.signingKey.pemRepresentation)
        signers.use(.es256(key: key))
        return try signers.sign(payload, typ: "JWT", kid: JWKIdentifier(stringLiteral: self.keyId))
    }
    
    ///Uses a subscription’s product identifier to extend the renewal date for all of its eligible active subscribers.
    ///
    ///- Parameter massExtendRenewalDateRequest: The request body for extending a subscription renewal date for all of its active subscribers.
    ///- Returns: A response that indicates the server successfully received the subscription-renewal-date extension request, or information about the failure
    ///[Extend Subscription Renewal Dates for All Active Subscribers](https://developer.apple.com/documentation/appstoreserverapi/extend_subscription_renewal_dates_for_all_active_subscribers)
    public func extendRenewalDateForAllActiveSubscribers(massExtendRenewalDateRequest: MassExtendRenewalDateRequest) async -> APIResult<MassExtendRenewalDateResponse> {
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/mass/", method: "POST", queryParameters: [:], body: massExtendRenewalDateRequest)
    }
    
    ///Extends the renewal date of a customer’s active subscription using the original transaction identifier.
    ///
    ///- Parameter originalTransactionId:    The original transaction identifier of the subscription receiving a renewal date extension.
    ///- Parameter extendRenewalDateRequest:  The request body containing subscription-renewal-extension data.
    ///- Returns: A response that indicates whether an individual renewal-date extension succeeded, and related details, or information about the failure
    ///[Extend a Subscription Renewal Date](https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date)
    public func extendSubscriptionRenewalDate(originalTransactionId: String, extendRenewalDateRequest: ExtendRenewalDateRequest) async -> APIResult<ExtendRenewalDateResponse> {
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/" + originalTransactionId, method: "PUT", queryParameters: [:], body: extendRenewalDateRequest)
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

        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/" + transactionId, method: "GET", queryParameters: queryParams, body: request)
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
        
        return await makeRequestWithResponseBody(path: "/inApps/v2/refund/lookup/" + transactionId, method: "GET", queryParameters: queryParams, body: request)
    }
    
    ///Checks whether a renewal date extension request completed, and provides the final count of successful or failed extensions.
    ///
    ///- Parameter requestIdentifier: The UUID that represents your request to the Extend Subscription Renewal Dates for All Active Subscribers endpoint.
    ///- Parameter productId:         The product identifier of the auto-renewable subscription that you request a renewal-date extension for.
    ///- Returns: A response that indicates the current status of a request to extend the subscription renewal date to all eligible subscribers, or information about the failure
    ///[Get Status of Subscription Renewal Date Extensions](https://developer.apple.com/documentation/appstoreserverapi/get_status_of_subscription_renewal_date_extensions)
    public func getStatusOfSubscriptionRenewalDateExtensions(requestIdentifier: String, productId: String) async -> APIResult<MassExtendRenewalDateStatusResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/mass/" + productId + "/" + requestIdentifier, method: "GET", queryParameters: [:], body: request)
    }
    
    ///Check the status of the test App Store server notification sent to your server.
    ///
    ///- Parameter testNotificationToken: The test notification token received from the Request a Test Notification endpoint
    ///- Returns: A response that contains the contents of the test notification sent by the App Store server and the result from your server, or information about the failure
    ///[Get Test Notification Status](https://developer.apple.com/documentation/appstoreserverapi/get_test_notification_status)
    public func getTestNotificationStatus(testNotificationToken: String) async -> APIResult<CheckTestNotificationResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/test/" + testNotificationToken, method: "GET", queryParameters: [:], body: request)
    }
    
    ///Get a customer’s in-app purchase transaction history for your app.
    ///
    ///- Parameter transactionId: The identifier of a transaction that belongs to the customer, and which may be an original transaction identifier.
    ///- Parameter revision:      A token you provide to get the next set of up to 20 transactions. All responses include a revision token. Note: For requests that use the revision token, include the same query parameters from the initial request. Use the revision token from the previous HistoryResponse.
    ///- Returns: A response that contains the customer’s transaction history for an app, or information about the failure
    ///[Get Transaction History](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history)
    public func getTransactionHistory(transactionId: String, revision: String?, transactionHistoryRequest: TransactionHistoryRequest) async -> APIResult<HistoryResponse> {
        let request: String? = nil
        var queryParams: [String: [String]] = [:]
        if let innerRevision = revision {
            queryParams["revision"] = [innerRevision]
        }
        if let innerStartDate = transactionHistoryRequest.startDate {
            queryParams["startDate"] = [String(Int64(innerStartDate.timeIntervalSince1970 * 1000))]
        }
        if let innerEndDate = transactionHistoryRequest.endDate {
            queryParams["endDate"] = [String(Int64(innerEndDate.timeIntervalSince1970 * 1000))]
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
        return await makeRequestWithResponseBody(path: "/inApps/v1/history/" + transactionId, method: "GET", queryParameters: queryParams, body: request)
    }
    ///Get information about a single transaction for your app.
    ///- Parameter transactionId: The identifier of a transaction that belongs to the customer, and which may be an original transaction identifier.
    ///- Returns: A response that contains signed transaction information for a single transaction.
    ///[Get Transaction Info](https://developer.apple.com/documentation/appstoreserverapi/get_transaction_info)
    public func getTransactionInfo(transactionId: String) async -> APIResult<TransactionInfoResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/transactions/" + transactionId, method: "GET", queryParameters: [:], body: request)
    }
    
    ///Get a customer’s in-app purchases from a receipt using the order ID.
    ///- Parameter orderId: The order ID for in-app purchases that belong to the customer.
    ///- Returns: A response that includes the order lookup status and an array of signed transactions for the in-app purchases in the order, or information about the failure
    ///[Look Up Order ID](https://developer.apple.com/documentation/appstoreserverapi/look_up_order_id)
    public func lookUpOrderId(orderId: String) async -> APIResult<OrderLookupResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/lookup/" + orderId, method: "GET", queryParameters: [:], body: request)
    }
    
    ///Ask App Store Server Notifications to send a test notification to your server.
    ///
    ///- Returns: A response that contains the test notification token, or information about the failure
    ///
    ///[Request a Test Notification](https://developer.apple.com/documentation/appstoreserverapi/request_a_test_notification)
    public func requestTestNotification() async -> APIResult<SendTestNotificationResponse> {
        let body: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/test", method: "POST", queryParameters: [:], body: body)
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
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/history", method: "POST", queryParameters: queryParams, body: notificationHistoryRequest)
    }

    ///Send consumption information about a consumable in-app purchase to the App Store after your server receives a consumption request notification.
    ///
    ///- Parameter transactionId: The transaction identifier for which you’re providing consumption information. You receive this identifier in the CONSUMPTION_REQUEST notification the App Store sends to your server.
    ///- Parameter consumptionRequest :   The request body containing consumption information.
    ///- Returns: Success, or information about the failure
    ///[Send Consumption Information](https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information)
    public func sendConsumptionData(transactionId: String, consumptionRequest: ConsumptionRequest) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/transactions/consumption/" + transactionId, method: "PUT", queryParameters: [:], body: consumptionRequest)
    }
    
    struct AppStoreServerAPIJWT: JWTPayload, Equatable {
        var exp: ExpirationClaim
        var iss: IssuerClaim
        var bid: String
        var aud: AudienceClaim
        var iat: IssuedAtClaim
        func verify(using signer: JWTSigner) throws {
            fatalError("Do not attempt to locally verify a JWT")
        }
    }
    
    private struct APIFetchError: Error {}
}

public enum APIResult<T> {
    case success(response: T)
    case failure(statusCode: Int?, apiError: APIError?, causedBy: Error?)
}

public enum APIError: Int64 {
    case generalBadRequest = 4000000
    case invalidAppIdentifier = 4000002
    case invalidRequestRevision = 4000005
    case invalidTransactionId = 4000006
    case invalidOriginalTransactionId = 4000008
    case invalidExtendByDays = 4000009
    case invalidExtendReasonCode = 4000010
    case invalidIdentifier = 4000011
    case startDateTooFarInPast = 4000012
    case startDateAfterEndDate = 4000013
    case invalidPaginationToken = 4000014
    case invalidStartDate = 4000015
    case invalidEndDate = 4000016
    case paginationTokenExpired = 4000017
    case invalidNotificationType = 4000018
    case multipleFiltersSupplied = 4000019
    case invalidTestNotificationToken = 4000020
    case invalidSort = 4000021
    case invalidProductType = 4000022
    case invalidProductId = 4000023
    case invalidSubscriptionGroupIdentifier = 4000024
    case invalidExcludeRevoked = 4000025
    case invalidInAppOwnershipType = 4000026
    case invalidEmptyStorefrontCountryCodeList = 4000027
    case invalidStorefrontCountryCode = 4000028
    case invaildRevoked = 4000030
    case invalidStatus = 4000031
    case invalidAccountTenure = 4000032
    case invalidAppAccountToken = 4000033
    case invalidConsumptionStatus = 4000034
    case invalidCustomerConsented = 4000035
    case invalidDeliveryStatus = 4000036
    case invalidLifetimeDollarsPurchased = 4000037
    case invalidLifetimeDollarsRefunded = 4000038
    case invalidPlatform = 4000039
    case invalidPlayTime = 4000040
    case invalidSampleContentProvided = 4000041
    case invalidUserStatus = 4000042
    case invalidTransactionNotConsumable = 4000043
    case subscriptionExtensionIneligible = 4030004
    case subscriptionMaxExtension = 4030005
    case familySharedSubscriptionExtensionIneligible = 4030007
    case accountNotFound = 4040001
    case accountNotFoundRetryable = 4040002
    case appNotFound = 4040003
    case appNotFoundRetryable = 4040004
    case originalTransactionIdNotFound = 4040005
    case originalTransactionIdNotFoundRetryable = 4040006
    case serverNotificationUrlNotFound = 4040007
    case testNotificationNotFound = 4040008
    case statusRequestNotFound = 4040009
    case transactionIdNotFound = 4040010
    case rateLimitExceeded = 4290000
    case generalInternal = 5000000
    case generalInternalRetryable = 5000001
}
