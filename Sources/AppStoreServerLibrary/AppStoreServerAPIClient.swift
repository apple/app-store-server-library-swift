// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import Crypto
import JWTKit
import AsyncHTTPClient
import NIOHTTP1
import NIOFoundationCompat

public actor AppStoreServerAPIClient: Sendable {

    public enum ConfigurationError: Error, Hashable, Sendable {
        /// Xcode is not a supported environment for an AppStoreServerAPIClient
        case invalidEnvironment
    }
    
    private static let userAgent = "app-store-server-library/swift/6.0.0"
    private static let productionUrl = "https://api.storekit.apple.com"
    private static let sandboxUrl = "https://api.storekit-sandbox.apple.com"
    private static let localTestingUrl = "https://local-testing-base-url"
    private static let appStoreConnectAudience = "appstoreconnect-v1"
    
    private let signingKey: P256.Signing.PrivateKey
    private let keyId: String
    private let issuerId: String
    private let bundleId: String
    private let url: String
    private let client: HTTPClient = .shared
    // For testing purposes
    private var executeRequestOverride: (@Sendable (HTTPClientRequest, Data?) async throws -> HTTPClientResponse)?

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
        self.executeRequestOverride = nil
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
    }

    // Test helper method to set request override
    internal func setExecuteRequestOverride(_ override: @escaping @Sendable (HTTPClientRequest, Data?) async throws -> HTTPClientResponse) {
        self.executeRequestOverride = override
    }
    
    private enum RequestBody {
        case encodable(any Encodable)
        case raw(Data, contentType: String)
    }

    private func makeRequest<T: Encodable>(path: RequestPath, method: HTTPMethod, queryParameters: [String: [String]], body: T?) async -> APIResult<Data> {
        if let b = body {
            return await makeRequest(path: path, method: method, queryParameters: queryParameters, body: .encodable(b))
        } else {
            return await makeRequest(path: path, method: method, queryParameters: queryParameters, body: nil)
        }
    }

    private func makeRequest(path: RequestPath, method: HTTPMethod, queryParameters: [String: [String]], body: Data, contentType: String) async -> APIResult<Data> {
        return await makeRequest(path: path, method: method, queryParameters: queryParameters, body: .raw(body, contentType: contentType))
    }

    private func makeRequest(path: RequestPath, method: HTTPMethod, queryParameters: [String: [String]], body: RequestBody?) async -> APIResult<Data> {
        do {
            var queryItems: [URLQueryItem] = []
            for (parameter, values) in queryParameters {
                for val in values {
                    queryItems.append(URLQueryItem(name: parameter, value: val))
                }
            }
            guard path.isValid else {
                return APIResult.failure(APIFailure(statusCode: nil, rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: nil, headers: [:]))
            }
            var urlComponents = URLComponents(string: self.url)
            urlComponents?.percentEncodedPath = path.value
            if !queryItems.isEmpty {
                urlComponents?.queryItems = queryItems
                let percentEncodedQuery = urlComponents?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                urlComponents?.percentEncodedQuery = percentEncodedQuery
            }
            
            guard let url = urlComponents?.url else {
                return APIResult.failure(APIFailure(statusCode: nil, rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: nil, headers: [:]))
            }
            
            var urlRequest = HTTPClientRequest(url: url.absoluteString)
            let token = try await generateToken()
            urlRequest.headers.add(name: "User-Agent", value: AppStoreServerAPIClient.userAgent)
            urlRequest.headers.add(name: "Authorization", value: "Bearer \(token)")
            urlRequest.headers.add(name: "Accept", value: "application/json")
            urlRequest.method = method
            
            let requestBody: Data?
            if let b = body {
                let data: Data
                let contentType: String
                switch b {
                case .encodable(let encodable):
                    let jsonEncoder = getJsonEncoder()
                    data = try jsonEncoder.encode(encodable)
                    contentType = "application/json"
                case .raw(let rawData, let ct):
                    data = rawData
                    contentType = ct
                }
                requestBody = data
                urlRequest.body = .bytes(.init(data: data))
                urlRequest.headers.add(name: "Content-Type", value: contentType)
            } else {
                requestBody = nil
            }
            
            let response = try await executeRequest(urlRequest, requestBody)
            let responseHeaders = APIFailure.normalizeHeaders(response.headers)
            var body = try await response.body.collect(upTo: 1024 * 1024)
            guard let data = body.readData(length: body.readableBytes) else {
                throw APIFetchError(headers: responseHeaders)
            }
            if response.status.code >= 200 && response.status.code < 300 {
                return APIResult.success(response: data)
            } else if let decodedBody = try? getJsonDecoder().decode(ErrorPayload.self, from: data), let errorCode = decodedBody.errorCode {
                return APIResult.failure(APIFailure(statusCode: Int(response.status.code), rawApiError: errorCode, apiError: APIError.init(rawValue: errorCode), errorMessage: decodedBody.errorMessage, causedBy: nil, headers: responseHeaders))
            } else {
                return APIResult.failure(APIFailure(statusCode: Int(response.status.code), rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: nil, headers: responseHeaders))
            }
        } catch (let error) {
            let responseHeaders = (error as? APIFetchError)?.headers ?? [:]
            return APIResult.failure(APIFailure(statusCode: nil, rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: error, headers: responseHeaders))
        }
    }

    // requestBody passed for testing purposes
    internal func executeRequest(_ urlRequest: HTTPClientRequest, _ requestBody: Data?) async throws -> HTTPClientResponse {
        if let override = executeRequestOverride {
            return try await override(urlRequest, requestBody)
        }
        return try await self.client.execute(urlRequest, timeout: .seconds(30))
    }

    private func makeRequestWithResponseBody<T: Encodable, R: Decodable>(path: RequestPath, method: HTTPMethod, queryParameters: [String: [String]], body: T?) async -> APIResult<R> {
        let response = await makeRequest(path: path, method: method, queryParameters: queryParameters, body: body)
        switch response {
        case .success(let data):
            let decoder = getJsonDecoder()
            do {
                let decodedBody = try decoder.decode(R.self, from: data)
                return APIResult.success(response: decodedBody)
            } catch (let error) {
                return APIResult.failure(APIFailure(statusCode: nil, rawApiError: nil, apiError: nil, errorMessage: nil, causedBy: error, headers: [:]))
            }
        case .failure(let failure):
            return APIResult.failure(failure)
        }
    }

    private func makeRequestWithoutResponseBody<T: Encodable>(path: RequestPath, method: HTTPMethod, queryParameters: [String: [String]], body: T?) async -> APIResult<Void> {
        let response = await makeRequest(path: path, method: method, queryParameters: queryParameters, body: body)
        switch response {
            case .success:
                return APIResult.success(response: ())
            case .failure(let failure):
                return APIResult.failure(failure)
        }
    }

    private func makeRequestWithoutResponseBody(path: RequestPath, method: HTTPMethod, queryParameters: [String: [String]], body: Data, contentType: String) async -> APIResult<Void> {
        let response = await makeRequest(path: path, method: method, queryParameters: queryParameters, body: body, contentType: contentType)
        switch response {
            case .success:
                return APIResult.success(response: ())
            case .failure(let failure):
                return APIResult.failure(failure)
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
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .integerSecondsSince1970
        try await keys.add(ecdsa: ECDSA.PrivateKey<P256>(backing: signingKey), serializer: DefaultJWTSerializer(jsonEncoder: jsonEncoder))
        return try await keys.sign(payload, header: ["typ": "JWT", "kid": .string(self.keyId)])
    }
    
    ///Uses a subscription’s product identifier to extend the renewal date for all of its eligible active subscribers.
    ///
    ///- Parameter massExtendRenewalDateRequest: The request body for extending a subscription renewal date for all of its active subscribers.
    ///- Returns: A response that indicates the server successfully received the subscription-renewal-date extension request, or information about the failure
    ///[Extend Subscription Renewal Dates for All Active Subscribers](https://developer.apple.com/documentation/appstoreserverapi/extend-subscription-renewal-dates-for-all-active-subscribers)
    public func extendRenewalDateForAllActiveSubscribers(massExtendRenewalDateRequest: MassExtendRenewalDateRequest) async -> APIResult<MassExtendRenewalDateResponse> {
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/mass", method: .POST, queryParameters: [:], body: massExtendRenewalDateRequest)
    }
    
    ///Extends the renewal date of a customer’s active subscription using the original transaction identifier.
    ///
    ///- Parameter originalTransactionId:    The original transaction identifier of the subscription receiving a renewal date extension.
    ///- Parameter extendRenewalDateRequest:  The request body containing subscription-renewal-extension data.
    ///- Returns: A response that indicates whether an individual renewal-date extension succeeded, and related details, or information about the failure
    ///[Extend a Subscription Renewal Date](https://developer.apple.com/documentation/appstoreserverapi/extend-a-subscription-renewal-date)
    public func extendSubscriptionRenewalDate(originalTransactionId: String, extendRenewalDateRequest: ExtendRenewalDateRequest) async -> APIResult<ExtendRenewalDateResponse> {
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/\(originalTransactionId)", method: .PUT, queryParameters: [:], body: extendRenewalDateRequest)
    }
    
    ///Get the statuses for all of a customer’s auto-renewable subscriptions in your app.
    ///- Parameter anyTransactionId: Any transactionId, originalTransactionId, or appTransactionId that belongs to the customer for your app.
    ///- Parameter status: An optional filter that indicates the status of subscriptions to include in the response. Your query may specify more than one status query parameter.
    ///- Returns: A response that contains status information for all of a customer’s auto-renewable subscriptions in your app, or information about the failure
    ///[Get All Subscription Statuses](https://developer.apple.com/documentation/appstoreserverapi/get-all-subscription-statuses)
    public func getAllSubscriptionStatuses(anyTransactionId: String, status: [Status]? = nil) async -> APIResult<StatusResponse> {
        let request: String? = nil
        var queryParams: [String: [String]] = [:]
        if let innerStatus = status {
            queryParams["status"] = innerStatus.map { (input) -> String in
                String(input.rawValue)
            }
        }

        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/\(anyTransactionId)", method: .GET, queryParameters: queryParams, body: request)
    }
    
    ///Get a paginated list of all of a customer’s refunded in-app purchases for your app.
    ///
    ///- Parameter anyTransactionId: Any transactionId, originalTransactionId, or appTransactionId that belongs to the customer for your app.
    ///- Parameter revision:      A token you provide to get the next set of up to 20 transactions. All responses include a revision token. Use the revision token from the previous RefundHistoryResponse.
    ///- Returns: A response that contains an array of signed JSON Web Signature (JWS) refunded transactions, and paging information, or information about the failure
    ///[Get Refund History](https://developer.apple.com/documentation/appstoreserverapi/get-refund-history)
    public func getRefundHistory(anyTransactionId: String, revision: String?) async -> APIResult<RefundHistoryResponse> {
        let request: String? = nil
        var queryParams: [String: [String]] = [:]
        if let innerRevision = revision {
            queryParams["revision"] = [innerRevision]
        }

        return await makeRequestWithResponseBody(path: "/inApps/v2/refund/lookup/\(anyTransactionId)", method: .GET, queryParameters: queryParams, body: request)
    }
    
    ///Checks whether a renewal date extension request completed, and provides the final count of successful or failed extensions.
    ///
    ///- Parameter requestIdentifier: The UUID that represents your request to the Extend Subscription Renewal Dates for All Active Subscribers endpoint.
    ///- Parameter productId:         The product identifier of the auto-renewable subscription that you request a renewal-date extension for.
    ///- Returns: A response that indicates the current status of a request to extend the subscription renewal date to all eligible subscribers, or information about the failure
    ///[Get Status of Subscription Renewal Date Extensions](https://developer.apple.com/documentation/appstoreserverapi/get-status-of-subscription-renewal-date-extensions)
    public func getStatusOfSubscriptionRenewalDateExtensions(requestIdentifier: String, productId: String) async -> APIResult<MassExtendRenewalDateStatusResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/subscriptions/extend/mass/\(productId)/\(requestIdentifier)", method: .GET, queryParameters: [:], body: request)
    }
    
    ///Check the status of the test App Store server notification sent to your server.
    ///
    ///- Parameter testNotificationToken: The test notification token received from the Request a Test Notification endpoint
    ///- Returns: A response that contains the contents of the App Store server’s test notification and the result from your server, or information about the failure
    ///[Get Test Notification Status](https://developer.apple.com/documentation/appstoreserverapi/get-test-notification-status)
    public func getTestNotificationStatus(testNotificationToken: String) async -> APIResult<CheckTestNotificationResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/test/\(testNotificationToken)", method: .GET, queryParameters: [:], body: request)
    }
    
    ///See `getTransactionHistory(anyTransactionId: String, revision: String?, transactionHistoryRequest: TransactionHistoryRequest, version: GetTransactionHistoryVersion)`
    @available(*, deprecated, message: "Use getTransactionHistory(anyTransactionId:revision:transactionHistoryRequest:version:) instead")
    public func getTransactionHistory(anyTransactionId: String, revision: String?, transactionHistoryRequest: TransactionHistoryRequest) async -> APIResult<HistoryResponse> {
        return await self.getTransactionHistory(anyTransactionId: anyTransactionId, revision: revision, transactionHistoryRequest: transactionHistoryRequest, version: .v1)
    }

    ///Get a customer’s in-app purchase transaction history for your app.
    ///
    ///- Parameter anyTransactionId: Any transactionId, originalTransactionId, or appTransactionId that belongs to the customer for your app.
    ///- Parameter revision:      A token you provide to get the next set of up to 20 transactions. All responses include a revision token. Note: For requests that use the revision token, include the same query parameters from the initial request. Use the revision token from the previous HistoryResponse.
    ///- Parameter version:      The version of the Get Transaction History endpoint to use. V2 is recommended.
    ///- Returns: A response that contains the customer’s transaction history for an app, or information about the failure
    ///[Get Transaction History](https://developer.apple.com/documentation/appstoreserverapi/get-transaction-history)
    public func getTransactionHistory(anyTransactionId: String, revision: String?, transactionHistoryRequest: TransactionHistoryRequest, version: GetTransactionHistoryVersion) async -> APIResult<HistoryResponse> {
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
        return await makeRequestWithResponseBody(path: "/inApps/\(version.rawValue)/history/\(anyTransactionId)", method: .GET, queryParameters: queryParams, body: request)
    }

    ///Get information about a single transaction for your app.
    ///- Parameter transactionId: The identifier of a transaction that belongs to the customer, and which may be an original transaction identifier.
    ///- Returns: A response that contains signed transaction information for a single transaction.
    ///[Get Transaction Info](https://developer.apple.com/documentation/appstoreserverapi/get-transaction-info)
    public func getTransactionInfo(transactionId: String) async -> APIResult<TransactionInfoResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/transactions/\(transactionId)", method: .GET, queryParameters: [:], body: request)
    }
    
    ///Get a customer’s in-app purchases from a receipt using the order ID.
    ///- Parameter orderId: The order ID for in-app purchases that belong to the customer.
    ///- Returns: A response that includes the order lookup status and an array of signed transactions for the in-app purchases in the order, or information about the failure
    ///[Look Up Order ID](https://developer.apple.com/documentation/appstoreserverapi/look-up-order-id)
    public func lookUpOrderId(orderId: String) async -> APIResult<OrderLookupResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/lookup/\(orderId)", method: .GET, queryParameters: [:], body: request)
    }
    
    ///Ask App Store Server Notifications to send a test notification to your server.
    ///
    ///- Returns: A response that contains the test notification token, or information about the failure
    ///
    ///[Request a Test Notification](https://developer.apple.com/documentation/appstoreserverapi/request-a-test-notification)
    public func requestTestNotification() async -> APIResult<SendTestNotificationResponse> {
        let body: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/test", method: .POST, queryParameters: [:], body: body)
    }
    
    ///Get a list of notifications that the App Store server attempted to send to your server.
    ///
    ///- Parameter paginationToken: An optional token you use to get the next set of up to 20 notification history records. All responses that have more records available include a paginationToken. Omit this parameter the first time you call this endpoint.
    ///- Parameter notificationHistoryRequest: The request body that includes the start and end dates, and optional query constraints.
    ///- Returns: A response that contains the App Store Server Notifications history for your app.
    ///[Get Notification History](https://developer.apple.com/documentation/appstoreserverapi/get-notification-history)
    public func getNotificationHistory(paginationToken: String?, notificationHistoryRequest: NotificationHistoryRequest) async -> APIResult<NotificationHistoryResponse> {
        var queryParams: [String: [String]] = [:]
        if let innerPaginationToken = paginationToken {
            queryParams["paginationToken"] = [innerPaginationToken]
        }
        return await makeRequestWithResponseBody(path: "/inApps/v1/notifications/history", method: .POST, queryParameters: queryParams, body: notificationHistoryRequest)
    }

    ///Send consumption information about a consumable in-app purchase to the App Store after your server receives a consumption request notification.
    ///
    ///- Parameter transactionId: The transaction identifier for which you're providing consumption information. You receive this identifier in the CONSUMPTION_REQUEST notification the App Store sends to your server.
    ///- Parameter consumptionRequest: The request body containing consumption information.
    ///- Returns: Success, or information about the failure
    ///[Send Consumption Information V1](https://developer.apple.com/documentation/appstoreserverapi/send-consumption-information-v1)
    @available(*, deprecated, message: "Use sendConsumptionInformation(transactionId:consumptionRequest:) instead")
    public func sendConsumptionData(transactionId: String, consumptionRequest: ConsumptionRequestV1) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/transactions/consumption/\(transactionId)", method: .PUT, queryParameters: [:], body: consumptionRequest)
    }

    ///Send consumption information about an In-App Purchase to the App Store after your server receives a consumption request notification.
    ///
    ///- Parameter transactionId: The transaction identifier for which you're providing consumption information. You receive this identifier in the CONSUMPTION_REQUEST notification the App Store sends to your server's App Store Server Notifications V2 endpoint.
    ///- Parameter consumptionRequest: The request body containing consumption information.
    ///- Returns: Success, or information about the failure
    ///[Send Consumption Information](https://developer.apple.com/documentation/appstoreserverapi/send-consumption-information)
    public func sendConsumptionInformation(transactionId: String, consumptionRequest: ConsumptionRequest) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v2/transactions/consumption/\(transactionId)", method: .PUT, queryParameters: [:], body: consumptionRequest)
    }

    ///Sets the app account token value for a purchase the customer makes outside your app, or updates its value in an existing transaction.
    ///
    ///- Parameter originalTransactionId: The original transaction identifier of the transaction to receive the app account token update.
    ///- Parameter updateAppAccountTokenRequest: The request body that contains a valid app account token value.
    ///- Returns: Success, or information about the failure
    ///[Set App Account Token](https://developer.apple.com/documentation/appstoreserverapi/set-app-account-token)
    public func setAppAccountToken(originalTransactionId: String, updateAppAccountTokenRequest: UpdateAppAccountTokenRequest) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/transactions/\(originalTransactionId)/appAccountToken", method: .PUT, queryParameters: [:], body: updateAppAccountTokenRequest)
    }

    ///Upload an image to use for retention messaging.
    ///
    ///- Parameter imageIdentifier: A UUID you provide to uniquely identify the image you upload.
    ///- Parameter image: The image file to upload.
    ///- Parameter imageSize: The size of the image you upload.
    ///- Returns: Success, or information about the failure
    ///[Upload Image](https://developer.apple.com/documentation/retentionmessaging/upload-image)
    public func uploadImage(imageIdentifier: UUID, image: Data, imageSize: ImageSize? = nil) async -> APIResult<Void> {
        var queryParams: [String: [String]] = [:]
        if let imageSize = imageSize {
            queryParams["imageSize"] = [imageSize.rawValue]
        }
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/image/\(imageIdentifier.uuidString.lowercased())", method: .PUT, queryParameters: queryParams, body: image, contentType: "image/png")
    }

    ///Delete a previously uploaded image.
    ///
    ///- Parameter imageIdentifier: The identifier of the image to delete.
    ///- Returns: Success, or information about the failure
    ///[Delete Image](https://developer.apple.com/documentation/retentionmessaging/delete-image)
    public func deleteImage(imageIdentifier: UUID) async -> APIResult<Void> {
        let request: String? = nil
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/image/\(imageIdentifier.uuidString.lowercased())", method: .DELETE, queryParameters: [:], body: request)
    }

    ///Get the image identifier and state for all uploaded images.
    ///
    ///- Returns: A response that contains status information for all images.
    ///[Get Image List](https://developer.apple.com/documentation/retentionmessaging/get-image-list)
    public func getImageList() async -> APIResult<GetImageListResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/messaging/image/list", method: .GET, queryParameters: [:], body: request)
    }

    ///Upload a message to use for retention messaging.
    ///
    ///- Parameter messageIdentifier: A UUID you provide to uniquely identify the message you upload.
    ///- Parameter uploadMessageRequestBody: The message text to upload.
    ///- Returns: Success, or information about the failure
    ///[Upload Message](https://developer.apple.com/documentation/retentionmessaging/upload-message)
    public func uploadMessage(messageIdentifier: UUID, uploadMessageRequestBody: UploadMessageRequestBody) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/message/\(messageIdentifier.uuidString.lowercased())", method: .PUT, queryParameters: [:], body: uploadMessageRequestBody)
    }

    ///Delete a previously uploaded message.
    ///
    ///- Parameter messageIdentifier: The identifier of the message to delete.
    ///- Returns: Success, or information about the failure
    ///[Delete Message](https://developer.apple.com/documentation/retentionmessaging/delete-message)
    public func deleteMessage(messageIdentifier: UUID) async -> APIResult<Void> {
        let request: String? = nil
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/message/\(messageIdentifier.uuidString.lowercased())", method: .DELETE, queryParameters: [:], body: request)
    }

    ///Get the message identifier and state of all uploaded messages.
    ///
    ///- Returns: A response that contains status information for all messages, or information about the failure
    ///[Get Message List](https://developer.apple.com/documentation/retentionmessaging/get-message-list)
    public func getMessageList() async -> APIResult<GetMessageListResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/messaging/message/list", method: .GET, queryParameters: [:], body: request)
    }

    ///Configure a default message for a specific product in a specific locale.
    ///
    ///- Parameter productId: The product identifier for the default configuration.
    ///- Parameter locale: The locale for the default configuration.
    ///- Parameter defaultConfigurationRequest: The request body that includes the message identifier to configure as the default message.
    ///- Returns: Success, or information about the failure
    ///[Configure Default Message](https://developer.apple.com/documentation/retentionmessaging/configure-default-message)
    public func configureDefaultMessage(productId: String, locale: String, defaultConfigurationRequest: DefaultConfigurationRequest) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/default/\(productId)/\(locale)", method: .PUT, queryParameters: [:], body: defaultConfigurationRequest)
    }

    ///Delete a default message for a product in a locale.
    ///
    ///- Parameter productId: The product ID of the default message configuration.
    ///- Parameter locale: The locale of the default message configuration.
    ///- Returns: Success, or information about the failure
    ///[Delete Default Message](https://developer.apple.com/documentation/retentionmessaging/delete-default-message)
    public func deleteDefaultMessage(productId: String, locale: String) async -> APIResult<Void> {
        let request: String? = nil
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/default/\(productId)/\(locale)", method: .DELETE, queryParameters: [:], body: request)
    }

    ///Gets the default message for a specific product in a specific locale, if it’s configured.
    ///
    ///- Parameter productId: The product identifier of the message.
    ///- Parameter locale: The locale of the message.
    ///- Returns: The response body that contains the default configuration information.
    ///[Get Default Message](https://developer.apple.com/documentation/retentionmessaging/get-default-message)
    public func getDefaultMessage(productId: String, locale: String) async -> APIResult<DefaultConfigurationResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/messaging/default/\(productId)/\(locale)", method: .GET, queryParameters: [:], body: request)
    }

    ///Configures the URL for your Get Retention Message endpoint in the sandbox and production environments.
    ///
    ///- Parameter realtimeUrlRequest: The request body that includes your endpoint’s URL.
    ///- Returns: Success, or information about the failure
    ///[Configure Realtime URL](https://developer.apple.com/documentation/retentionmessaging/configure-realtime-url)
    public func configureRealtimeURL(realtimeUrlRequest: RealtimeUrlRequest) async -> APIResult<Void> {
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/realtime/url", method: .PUT, queryParameters: [:], body: realtimeUrlRequest)
    }

    ///Deletes the URL for your Get Retention Message endpoint, in the sandbox or production environments.
    ///
    ///- Returns: Success, or information about the failure
    ///[Delete Realtime URL](https://developer.apple.com/documentation/retentionmessaging/delete-realtime-url)
    public func deleteRealtimeURL() async -> APIResult<Void> {
        let request: String? = nil
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/messaging/realtime/url", method: .DELETE, queryParameters: [:], body: request)
    }

    ///Gets the URL for real-time messages that points to your Get Retention Message endpoint, which you previously configured.
    ///
    ///- Returns: The response body that contains the URL for your Get Retention Message endpoint.
    ///[Get Realtime URL](https://developer.apple.com/documentation/retentionmessaging/get-realtime-url)
    public func getRealtimeURL() async -> APIResult<RealtimeUrlResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/messaging/realtime/url", method: .GET, queryParameters: [:], body: request)
    }

    ///Initiates a performance test of your Get Retention Message endpoint in the sandbox environment.
    ///
    ///- Parameter performanceTestRequest: The request body which specifies a transaction identifier of an In-App Purchase to use for this test.
    ///- Returns: The performance test response object.
    ///[Initiate Performance Test](https://developer.apple.com/documentation/retentionmessaging/initiate-performance-test)
    public func initiatePerformanceTest(performanceTestRequest: PerformanceTestRequest) async -> APIResult<PerformanceTestResponse> {
        return await makeRequestWithResponseBody(path: "/inApps/v1/messaging/performanceTest", method: .POST, queryParameters: [:], body: performanceTestRequest)
    }

    ///Gets the results of the performance test for the specified identifier.
    ///
    ///- Parameter requestId: The ID of the performance test to return, which you receive in the PerformanceTestResponse when you call Initiate Performance Test.
    ///- Returns: An object the API returns that describes the performance test results.
    ///[Get Performance Test Results](https://developer.apple.com/documentation/retentionmessaging/get-performance-test-results)
    public func getPerformanceTestResults(requestId: UUID) async -> APIResult<PerformanceTestResultResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/messaging/performanceTest/result/\(requestId.uuidString.lowercased())", method: .GET, queryParameters: [:], body: request)
    }

    ///Get a customer's app transaction information for your app.
    ///- Parameter anyTransactionId: Any transactionId, originalTransactionId, or appTransactionId that belongs to the customer for your app.
    ///- Returns: A response that contains signed app transaction information for a customer.
    ///[Get App Transaction Info](https://developer.apple.com/documentation/appstoreserverapi/get-app-transaction-info)
    public func getAppTransactionInfo(anyTransactionId: String) async -> APIResult<AppTransactionInfoResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/inApps/v1/transactions/appTransactions/\(anyTransactionId)", method: .GET, queryParameters: [:], body: request)
    }

    ///Notifies the App Store server that your system has finished processing the customer's transaction.
    ///
    ///- Parameter transactionId: The transaction identifier of the transaction to mark as finished.
    ///- Returns: Success, or information about the failure
    ///[Finish Transaction](https://developer.apple.com/documentation/appstoreserverapi/finish-transaction)
    public func finishTransaction(transactionId: String) async -> APIResult<Void> {
        let request: String? = nil
        return await makeRequestWithoutResponseBody(path: "/inApps/v1/transactions/\(transactionId)/finish", method: .POST, queryParameters: [:], body: request)
    }

    ///Increase or decrease the price of an auto-renewable subscription, a bundle, or individual items within a subscription at the next renewal.
    ///
    ///- Parameter transactionId: A transaction identifier of the auto-renewable subscription that is subject to the price change.
    ///- Parameter subscriptionPriceChangeRequest: The request body that contains the details of the price change.
    ///- Returns: A response that contains signed JWS renewal and JWS transaction information after a subscription price change request.
    ///[Change Subscription Price](https://developer.apple.com/documentation/advancedcommerceapi/change-subscription-price)
    public func changeSubscriptionPrice(transactionId: String, subscriptionPriceChangeRequest: AdvancedCommerceSubscriptionPriceChangeRequest) async -> APIResult<AdvancedCommerceSubscriptionPriceChangeResponse> {
        return await makeRequestWithResponseBody(path: "/advancedCommerce/v1/subscription/changePrice/\(transactionId)", method: .POST, queryParameters: [:], body: subscriptionPriceChangeRequest)
    }

    ///Turn off automatic renewal to cancel a customer's auto-renewable subscription.
    ///
    ///- Parameter transactionId: The transaction identifier of the auto-renewable subscription to cancel.
    ///- Parameter subscriptionCancelRequest: The request body that includes information about the subscription to cancel.
    ///- Returns: The response body for a successful subscription cancellation.
    ///[Cancel a Subscription](https://developer.apple.com/documentation/advancedcommerceapi/cancel-a-subscription)
    public func cancelSubscription(transactionId: String, subscriptionCancelRequest: AdvancedCommerceSubscriptionCancelRequest) async -> APIResult<AdvancedCommerceSubscriptionCancelResponse> {
        return await makeRequestWithResponseBody(path: "/advancedCommerce/v1/subscription/cancel/\(transactionId)", method: .POST, queryParameters: [:], body: subscriptionCancelRequest)
    }

    ///Immediately cancel a customer's subscription and all the items that are included in the subscription, and request a full or prorated refund.
    ///
    ///- Parameter transactionId: The transaction identifier of the auto-renewable subscription to revoke.
    ///- Parameter subscriptionRevokeRequest: The request body you provide to terminate a subscription and all its items immediately.
    ///- Returns: The response body for a successful revoke-subscription request.
    ///[Revoke Subscription](https://developer.apple.com/documentation/advancedcommerceapi/revoke-subscription)
    public func revokeSubscription(transactionId: String, subscriptionRevokeRequest: AdvancedCommerceSubscriptionRevokeRequest) async -> APIResult<AdvancedCommerceSubscriptionRevokeResponse> {
        return await makeRequestWithResponseBody(path: "/advancedCommerce/v1/subscription/revoke/\(transactionId)", method: .POST, queryParameters: [:], body: subscriptionRevokeRequest)
    }

    ///Request a refund for a one-time charge or subscription transaction.
    ///
    ///- Parameter transactionId: The transaction identifier for which you request a refund.
    ///- Parameter requestRefundRequest: The request body for requesting a refund for a transaction.
    ///- Returns: The response body for a transaction refund request.
    ///[Request Transaction Refund](https://developer.apple.com/documentation/advancedcommerceapi/request-transaction-refund)
    public func requestTransactionRefund(transactionId: String, requestRefundRequest: AdvancedCommerceRequestRefundRequest) async -> APIResult<AdvancedCommerceRequestRefundResponse> {
        return await makeRequestWithResponseBody(path: "/advancedCommerce/v1/transaction/requestRefund/\(transactionId)", method: .POST, queryParameters: [:], body: requestRefundRequest)
    }

    ///Update the SKU, display name, and description associated with a subscription, without affecting the subscription's billing or its service.
    ///
    ///- Parameter transactionId: The transaction identifier of the auto-renewable subscription to get changes to its metadata.
    ///- Parameter subscriptionChangeMetadataRequest: The request body that contains the metadata changes.
    ///- Returns: The response body for a successful subscription metadata change.
    ///[Change Subscription Metadata](https://developer.apple.com/documentation/advancedcommerceapi/change-subscription-metadata)
    public func changeSubscriptionMetadata(transactionId: String, subscriptionChangeMetadataRequest: AdvancedCommerceSubscriptionChangeMetadataRequest) async -> APIResult<AdvancedCommerceSubscriptionChangeMetadataResponse> {
        return await makeRequestWithResponseBody(path: "/advancedCommerce/v1/subscription/changeMetadata/\(transactionId)", method: .POST, queryParameters: [:], body: subscriptionChangeMetadataRequest)
    }

    ///Migrate a subscription that a customer purchased through Apple In-App Purchase to a subscription you manage using the Advanced Commerce API.
    ///
    ///- Parameter transactionId: The transaction identifier of the auto-renewable subscription to migrate.
    ///- Parameter subscriptionMigrateRequest: The request body that contains the details for the migration.
    ///- Returns: A response that contains signed renewal and transaction information after a subscription successfully migrates to the Advanced Commerce API.
    ///[Migrate a Subscription to Advanced Commerce API](https://developer.apple.com/documentation/advancedcommerceapi/migrate-subscription-to-advanced-commerce-api)
    public func migrateSubscriptionToAdvancedCommerceAPI(transactionId: String, subscriptionMigrateRequest: AdvancedCommerceSubscriptionMigrateRequest) async -> APIResult<AdvancedCommerceSubscriptionMigrateResponse> {
        return await makeRequestWithResponseBody(path: "/advancedCommerce/v1/subscription/migrate/\(transactionId)", method: .POST, queryParameters: [:], body: subscriptionMigrateRequest)
    }

    ///Get the groups that a customer belongs to, and their role in each group.
    ///
    ///- Parameter anyTransactionId: Any originalTransactionId, transactionId, or appTransactionId that belongs to the customer for your app.
    ///- Returns: A response that contains the groups a customer belongs to, and their role in each group, or information about the failure
    ///[Get Customer Groups](https://developer.apple.com/documentation/appstoreserverapi/get-customer-groups)
    public func getCustomerGroups(anyTransactionId: String) async -> APIResult<GetCustomerGroupsResponse> {
        let request: String? = nil
        return await makeRequestWithResponseBody(path: "/groups/v1/currentGroups/\(anyTransactionId)", method: .GET, queryParameters: [:], body: request)
    }

    ///Get a paginated list of the customers that belong to a group.
    ///
    ///- Parameter groupId: The identifier of a group in your app, which the Get Customer Groups endpoint returns.
    ///- Parameter paginationToken: An optional token you use to get the next set of members. Responses that have more members available include a paginationToken. Omit this parameter the first time you call this endpoint.
    ///- Parameter limit: An optional maximum number of members to return in a single response.
    ///- Returns: A response that contains a page of the customers that belong to a group, or information about the failure
    ///[Get Group Members](https://developer.apple.com/documentation/appstoreserverapi/get-group-members)
    public func getGroupMembers(groupId: String, paginationToken: String? = nil, limit: Int32? = nil) async -> APIResult<GetGroupMembersResponse> {
        let request: String? = nil
        var queryParams: [String: [String]] = [:]
        if let innerPaginationToken = paginationToken {
            queryParams["paginationToken"] = [innerPaginationToken]
        }
        if let innerLimit = limit {
            queryParams["limit"] = [String(innerLimit)]
        }
        return await makeRequestWithResponseBody(path: "/groups/v1/group/\(groupId)", method: .GET, queryParameters: queryParams, body: request)
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
    
    private struct APIFetchError: Error {
        let headers: [String: [String]]
    }
}

public enum APIResult<T: Sendable>: Sendable {
    case success(response: T)
    case failure(APIFailure)
}

public struct APIFailure: Sendable {
    public let statusCode: Int?
    public let rawApiError: Int64?
    public let apiError: APIError?
    public let errorMessage: String?
    public let causedBy: Error?
    ///The headers of the response, keyed by lowercased header name
    public let headers: [String: [String]]

    ///The time that informs you when you can next send a request
    ///
    ///[Identifying rate limits](https://developer.apple.com/documentation/appstoreserverapi/identifying-rate-limits)
    public let retryAfter: Date?

    internal init(statusCode: Int?, rawApiError: Int64?, apiError: APIError?, errorMessage: String?, causedBy: Error?, headers: [String: [String]]) {
        self.statusCode = statusCode
        self.rawApiError = rawApiError
        self.apiError = apiError
        self.errorMessage = errorMessage
        self.causedBy = causedBy
        self.headers = headers
        self.retryAfter = APIFailure.parseRetryAfter(headers["retry-after"])
    }

    internal static func normalizeHeaders(_ headers: HTTPHeaders) -> [String: [String]] {
        var normalizedHeaders: [String: [String]] = [:]
        for (name, value) in headers {
            normalizedHeaders[name.lowercased(), default: []].append(value)
        }
        return normalizedHeaders
    }

    internal static func parseRetryAfter(_ retryAfterValues: [String]?) -> Date? {
        guard let rawRetryAfter = retryAfterValues?.first else {
            return nil
        }
        let trimmedRetryAfter = rawRetryAfter.trimmingCharacters(in: .whitespaces)
        guard !trimmedRetryAfter.isEmpty, trimmedRetryAfter.allSatisfy({ $0.isASCII && $0.isNumber }) else {
            return nil
        }
        guard let retryAfter = Int64(trimmedRetryAfter) else {
            return nil
        }
        return Date(timeIntervalSince1970: Double(retryAfter) / 1000.0)
    }
}

///Understand the error codes that App Store Server API responses return.
///
///[Error codes](https://developer.apple.com/documentation/appstoreserverapi/error-codes)
public enum APIError: Int64, Hashable, Sendable {
    ///An error that indicates an invalid request.
    ///
    ///[GeneralBadRequestError](https://developer.apple.com/documentation/appstoreserverapi/generalbadrequesterror)
    case generalBadRequest = 4000000

    ///An error that indicates an invalid app identifier.
    ///
    ///[InvalidAppIdentifierError](https://developer.apple.com/documentation/appstoreserverapi/invalidappidentifiererror)
    case invalidAppIdentifier = 4000002

    ///An error that indicates the request limit is invalid.
    ///
    ///[InvalidLimitError](https://developer.apple.com/documentation/appstoreserverapi/invalidlimiterror)
    case invalidLimit = 4000004

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

    ///An error that indicates the start date is earlier than the earliest allowed date.
    ///
    ///[StartDateTooFarInPastError](https://developer.apple.com/documentation/appstoreserverapi/startdatetoofarinpasterror)
    case startDateTooFarInPast = 4000012

    ///An error that indicates the end date precedes the start date, or the two dates are equal.
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

    ///An error that indicates the request is invalid because it has too many applied constraints.
    ///
    ///[MultipleFiltersSuppliedError](https://developer.apple.com/documentation/appstoreserverapi/multiplefilterssuppliederror)
    case multipleFiltersSupplied = 4000019

    ///An error that indicates the test notification token is invalid.
    ///
    ///[InvalidTestNotificationTokenError](https://developer.apple.com/documentation/appstoreserverapi/invalidtestnotificationtokenerror)
    case invalidTestNotificationToken = 4000020

    ///An error that indicates the sort parameter is invalid.
    ///
    ///[InvalidSortError](https://developer.apple.com/documentation/appstoreserverapi/invalidsorterror)
    case invalidSort = 4000021

    ///An error that indicates the product type parameter is invalid.
    ///
    ///[InvalidProductTypeError](https://developer.apple.com/documentation/appstoreserverapi/invalidproducttypeerror)
    case invalidProductType = 4000022

    ///An error that indicates the product ID parameter is invalid.
    ///
    ///[InvalidProductIdError](https://developer.apple.com/documentation/appstoreserverapi/invalidproductiderror)
    case invalidProductId = 4000023

    ///An error that indicates the subscription group identifier is invalid.
    ///
    ///[InvalidSubscriptionGroupIdentifierError](https://developer.apple.com/documentation/appstoreserverapi/invalidsubscriptiongroupidentifiererror)
    case invalidSubscriptionGroupIdentifier = 4000024

    ///An error that indicates the query parameter exclude-revoked is invalid.
    ///
    ///[InvalidExcludeRevokedError](https://developer.apple.com/documentation/appstoreserverapi/invalidexcluderevokederror)
    @available(*, deprecated, message: "Use invalidRevoked instead")
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

    ///An error that indicates the transaction identifier doesn’t represent a consumable In-App Purchase.
    ///
    ///[InvalidTransactionNotConsumableError](https://developer.apple.com/documentation/appstoreserverapi/invalidtransactionnotconsumableerror)
    @available(*, deprecated, message: "Use invalidTransactionTypeNotSupported instead")
    case invalidTransactionNotConsumable = 4000043

    ///An error that indicates an invalid refund preference value.
    ///
    ///[InvalidRefundPreferenceError](https://developer.apple.com/documentation/appstoreserverapi/invalidrefundpreferenceerror)
    case invalidRefundPreference = 4000044

    ///An error that indicates the transaction identifier represents an unsupported In-App Purchase type.
    ///
    ///[InvalidTransactionTypeNotSupportedError](https://developer.apple.com/documentation/appstoreserverapi/invalidtransactiontypenotsupportederror)
    case invalidTransactionTypeNotSupported = 4000047

    ///An error that indicates the endpoint doesn’t support an app transaction ID.
    ///
    ///[AppTransactionIdNotSupportedError](https://developer.apple.com/documentation/appstoreserverapi/apptransactionidnotsupportederror)
    case appTransactionIdNotSupported = 4000048

    ///The currency value is invalid.
    ///
    ///[InvalidCurrencyError](https://developer.apple.com/documentation/advancedcommerceapi/invalidcurrencyerror)
    case invalidCurrency = 4000053

    ///At least one type of change must be provided in a modify subscription request.
    ///
    ///[OneItemNeededInModifyError](https://developer.apple.com/documentation/advancedcommerceapi/oneitemneededinmodifyerror)
    case oneItemNeededInModify = 4000063

    ///The required field, requestInfo, is missing.
    ///
    ///[NullRequestInfoError](https://developer.apple.com/documentation/advancedcommerceapi/nullrequestinfoerror)
    case nullRequestInfo = 4000079

    ///The required field, requestReferenceId, is missing.
    ///
    ///[NullRequestReferenceIDError](https://developer.apple.com/documentation/advancedcommerceapi/nullrequestreferenceiderror)
    case nullRequestReferenceID = 4000080

    ///The requestReferenceId value is invalid.
    ///
    ///[InvalidRequestReferenceIDError](https://developer.apple.com/documentation/advancedcommerceapi/invalidrequestreferenceiderror)
    case invalidRequestReferenceID = 4000081

    ///The consistencyToken value is invalid.
    ///
    ///[InvalidConsistencyTokenError](https://developer.apple.com/documentation/advancedcommerceapi/invalidconsistencytokenerror)
    case invalidConsistencyToken = 4000082

    ///The required field, version, is missing.
    ///
    ///[NullVersionError](https://developer.apple.com/documentation/advancedcommerceapi/nullversionerror)
    case nullVersion = 4000083

    ///The value of version is invalid.
    ///
    ///[UnexpectedVersionError](https://developer.apple.com/documentation/advancedcommerceapi/unexpectedversionerror)
    case unexpectedVersion = 4000084

    ///The required field, transactionId, is missing.
    ///
    ///[NullTransactionIdError](https://developer.apple.com/documentation/advancedcommerceapi/nulltransactioniderror)
    case nullTransactionId = 4000085

    ///The price field must contain a positive number.
    ///
    ///[NegativePriceError](https://developer.apple.com/documentation/advancedcommerceapi/negativepriceerror)
    case negativePrice = 4000086

    ///Exceeds the maximum length of the SKU field.
    ///
    ///[SKULengthExceededError](https://developer.apple.com/documentation/advancedcommerceapi/skulengthexceedederror)
    case skuLengthExceeded = 4000087

    ///Exceeds the maximum length of the description field.
    ///
    ///[DescriptionLengthExceededError](https://developer.apple.com/documentation/advancedcommerceapi/descriptionlengthexceedederror)
    case descriptionLengthExceeded = 4000088

    ///Exceeds the maximum length of the displayName field.
    ///
    ///[DisplayNameLengthExceededError](https://developer.apple.com/documentation/advancedcommerceapi/displaynamelengthexceedederror)
    case displayNameLengthExceeded = 4000089

    ///The proratedPrice field must contain a positive number.
    ///
    ///[NegativeProratedPriceError](https://developer.apple.com/documentation/advancedcommerceapi/negativeproratedpriceerror)
    case negativeProratedPrice = 4000091

    ///The required field, offer period, is missing.
    ///
    ///[NullOfferPeriodError](https://developer.apple.com/documentation/advancedcommerceapi/nullofferperioderror)
    case nullOfferPeriod = 4000092

    ///The required field, periodCount, is missing.
    ///
    ///[NullPeriodCountError](https://developer.apple.com/documentation/advancedcommerceapi/nullperiodcounterror)
    case nullPeriodCount = 4000093

    ///Period count must be a positive number.
    ///
    ///[PeriodCountNotPositiveError](https://developer.apple.com/documentation/advancedcommerceapi/periodcountnotpositiveerror)
    case periodCountNotPositive = 4000094

    ///The required field, reason, is missing.
    ///
    ///[NullReasonError](https://developer.apple.com/documentation/advancedcommerceapi/nullreasonerror)
    case nullReason = 4000095

    ///Previous original transaction id is invalid.
    ///
    ///[InvalidPreviousTransactionIDError](https://developer.apple.com/documentation/advancedcommerceapi/invalidprevioustransactioniderror)
    case invalidPreviousTransactionID = 4000096

    ///The requestReferenceId was repeated.
    ///
    ///[RepeatedRequestReferenceIdError](https://developer.apple.com/documentation/advancedcommerceapi/repeatedrequestreferenceiderror)
    case repeatedRequestReferenceId = 4000097

    ///The required field, currency, is missing.
    ///
    ///[NullCurrencyError](https://developer.apple.com/documentation/advancedcommerceapi/nullcurrencyerror)
    case nullCurrency = 4000098

    ///The required field, taxCode, is missing.
    ///
    ///[NullTaxCodeError](https://developer.apple.com/documentation/advancedcommerceapi/nulltaxcodeerror)
    case nullTaxCode = 4000099

    ///The required field, storefront, is missing.
    ///
    ///[NullStorefrontError](https://developer.apple.com/documentation/advancedcommerceapi/nullstorefronterror)
    case nullStorefront = 4000100

    ///The required field, items, is missing.
    ///
    ///[NullItemsError](https://developer.apple.com/documentation/advancedcommerceapi/nullitemserror)
    case nullItems = 4000101

    ///The required field, item, is missing.
    ///
    ///[NullItemError](https://developer.apple.com/documentation/advancedcommerceapi/nullitemerror)
    case nullItem = 4000102

    ///The required field, descriptors, is missing.
    ///
    ///[NullDescriptorsError](https://developer.apple.com/documentation/advancedcommerceapi/nulldescriptorserror)
    case nullDescriptors = 4000103

    ///The required field, period, is missing.
    ///
    ///[NullPeriodError](https://developer.apple.com/documentation/advancedcommerceapi/nullperioderror)
    case nullPeriod = 4000104

    ///The required field, SKU, is missing.
    ///
    ///[NullSKUError](https://developer.apple.com/documentation/advancedcommerceapi/nullskuerror)
    case nullSKU = 4000105

    ///The required field, displayName, is missing.
    ///
    ///[NullDisplayNameError](https://developer.apple.com/documentation/advancedcommerceapi/nulldisplaynameerror)
    case nullDisplayName = 4000106

    ///The required field, description, is missing.
    ///
    ///[NullDescriptionError](https://developer.apple.com/documentation/advancedcommerceapi/nulldescriptionerror)
    case nullDescription = 4000107

    ///The required field, price, is missing.
    ///
    ///[NullPriceError](https://developer.apple.com/documentation/advancedcommerceapi/nullpriceerror)
    case nullPrice = 4000109

    ///The required field, retainBillingCycle, is missing.
    ///
    ///[NullRetainBillingCycleError](https://developer.apple.com/documentation/advancedcommerceapi/nullretainbillingcycleerror)
    case nullRetainBillingCycle = 4000110

    ///The required field, effective, is missing.
    ///
    ///[NullEffectiveError](https://developer.apple.com/documentation/advancedcommerceapi/nulleffectiveerror)
    case nullEffective = 4000111

    ///The required field, SKU in changeItems, is missing.
    ///
    ///[NullNewSKUError](https://developer.apple.com/documentation/advancedcommerceapi/nullnewskuerror)
    case nullNewSKU = 4000112

    ///The previous subscription targeted is invalid.
    ///
    ///[InvalidPreviousSubscriptionError](https://developer.apple.com/documentation/advancedcommerceapi/invalidprevioussubscriptionerror)
    case invalidPreviousSubscription = 4000113

    ///Provided SKU is already owned.
    ///
    ///[ProductAlreadyExistsError](https://developer.apple.com/documentation/advancedcommerceapi/productalreadyexistserror)
    case productAlreadyExists = 4000114

    ///Product changes are invalid.
    ///
    ///[InvalidProductChangesError](https://developer.apple.com/documentation/advancedcommerceapi/invalidproductchangeserror)
    case invalidProductChanges = 4000115

    ///The targeted salable isn't configured as a generic salable.
    ///
    ///[InvalidSalableError](https://developer.apple.com/documentation/advancedcommerceapi/invalidsalableerror)
    case invalidSalable = 4000116

    ///The salable duration is invalid.
    ///
    ///[InvalidSalableDurationError](https://developer.apple.com/documentation/advancedcommerceapi/invalidsalabledurationerror)
    case invalidSalableDuration = 4000117

    ///The displayName is invalid.
    ///
    ///[InvalidDisplayNameError](https://developer.apple.com/documentation/advancedcommerceapi/invaliddisplaynameerror)
    case invalidDisplayName = 4000118

    ///The description is invalid.
    ///
    ///[InvalidDescriptionError](https://developer.apple.com/documentation/advancedcommerceapi/invaliddescriptionerror)
    case invalidDescription = 4000119

    ///The requested product to change doesn't exist.
    ///
    ///[InvalidProductError](https://developer.apple.com/documentation/advancedcommerceapi/invalidproducterror)
    case invalidProduct = 4000121

    ///The SKU was invalid.
    ///
    ///[InvalidSKUError](https://developer.apple.com/documentation/advancedcommerceapi/invalidskuerror)
    case invalidSKU = 4000122

    ///The refundType is invalid.
    ///
    ///[InvalidRefundTypeError](https://developer.apple.com/documentation/advancedcommerceapi/invalidrefundtypeerror)
    case invalidRefundType = 4000123

    ///The refundReason is invalid.
    ///
    ///[InvalidRefundReasonError](https://developer.apple.com/documentation/advancedcommerceapi/invalidrefundreasonerror)
    case invalidRefundReason = 4000124

    ///The change reason is invalid.
    ///
    ///[InvalidChangeReasonError](https://developer.apple.com/documentation/advancedcommerceapi/invalidchangereasonerror)
    case invalidChangeReason = 4000125

    ///The offer reason is invalid.
    ///
    ///[InvalidOfferReasonError](https://developer.apple.com/documentation/advancedcommerceapi/invalidofferreasonerror)
    case invalidOfferReason = 4000126

    ///The taxCode is invalid.
    ///
    ///[InvalidTaxProductCodeError](https://developer.apple.com/documentation/advancedcommerceapi/invalidtaxproductcodeerror)
    case invalidTaxProductCode = 4000127

    ///The offer period is invalid.
    ///
    ///[InvalidOfferPeriodError](https://developer.apple.com/documentation/advancedcommerceapi/invalidofferperioderror)
    case invalidOfferPeriod = 4000128

    ///The offer periodCount is invalid.
    ///
    ///[InvalidOfferPeriodCountError](https://developer.apple.com/documentation/advancedcommerceapi/invalidofferperiodcounterror)
    case invalidOfferPeriodCount = 4000129

    ///The renewal period is invalid.
    ///
    ///[InvalidRenewalPeriodError](https://developer.apple.com/documentation/advancedcommerceapi/invalidrenewalperioderror)
    case invalidRenewalPeriod = 4000130

    ///The renewal price is invalid.
    ///
    ///[InvalidRenewalPriceError](https://developer.apple.com/documentation/advancedcommerceapi/invalidrenewalpriceerror)
    case invalidRenewalPrice = 4000131

    ///The amount is invalid.
    ///
    ///[InvalidAmountError](https://developer.apple.com/documentation/advancedcommerceapi/invalidamounterror)
    case invalidAmount = 4000132

    ///The storefronts mismatch.
    ///
    ///[MismatchedStorefrontError](https://developer.apple.com/documentation/advancedcommerceapi/mismatchedstorefronterror)
    case mismatchedStorefront = 4000133

    ///Pricing isn't configured for the storefront.
    ///
    ///[MissingPricingConfigForStorefrontError](https://developer.apple.com/documentation/advancedcommerceapi/missingpricingconfigforstorefronterror)
    case missingPricingConfigForStorefront = 4000134

    ///The operation isn't allowed.
    ///
    ///[OperationNotAllowedError](https://developer.apple.com/documentation/advancedcommerceapi/operationnotallowederror)
    case operationNotAllowed = 4000135

    ///More items were provided than allowed.
    ///
    ///[MoreItemsThanAllowedError](https://developer.apple.com/documentation/advancedcommerceapi/moreitemsthanallowederror)
    case moreItemsThanAllowed = 4000136

    ///More offers were provided than allowed.
    ///
    ///[MoreOffersThanAllowedError](https://developer.apple.com/documentation/advancedcommerceapi/moreoffersthanallowederror)
    case moreOffersThanAllowed = 4000137

    ///The addItems and changeItems entries cannot be empty.
    ///
    ///[EmptyAddChangeItemsError](https://developer.apple.com/documentation/advancedcommerceapi/emptyaddchangeitemserror)
    case emptyAddChangeItems = 4000139

    ///All items must be updated on a period change.
    ///
    ///[MissingUpdatedItemsWithPeriodChangeError](https://developer.apple.com/documentation/advancedcommerceapi/missingupdateditemswithperiodchangeerror)
    case missingUpdatedItemsWithPeriodChange = 4000140

    ///Period reset conflicts with retaining billing cycle.
    ///
    ///[PeriodResetWithRetainBillingCycleError](https://developer.apple.com/documentation/advancedcommerceapi/periodresetwithretainbillingcycleerror)
    case periodResetWithRetainBillingCycle = 4000141

    ///A period change at next cycle conflicts with addition at the current period.
    ///
    ///[PeriodChangeEffectiveConflictError](https://developer.apple.com/documentation/advancedcommerceapi/periodchangeeffectiveconflicterror)
    case periodChangeEffectiveConflict = 4000142

    ///Multiple operations on a single SKU isn't allowed.
    ///
    ///[MultipleOperationsOnSingleSKUError](https://developer.apple.com/documentation/advancedcommerceapi/multipleoperationsonsingleskuerror)
    case multipleOperationsOnSingleSKU = 4000143

    ///The removeItems object was present without addItems or changeItems.
    ///
    ///[RemoveItemsWithoutAddOrChangeItemsError](https://developer.apple.com/documentation/advancedcommerceapi/removeitemswithoutaddorchangeitemserror)
    case removeItemsWithoutAddOrChangeItems = 4000144

    ///A product in removeItems wasn't found for the given subscription.
    ///
    ///[RemoveItemNotFoundError](https://developer.apple.com/documentation/advancedcommerceapi/removeitemnotfounderror)
    case removeItemNotFound = 4000145

    ///The targeted item in changeItems wasn't found.
    ///
    ///[ChangeItemNotFoundError](https://developer.apple.com/documentation/advancedcommerceapi/changeitemnotfounderror)
    case changeItemNotFound = 4000146

    ///The request contains a billing period that doesn't align with the subscription's billing cycle.
    ///
    ///[MisalignedBillingCycleError](https://developer.apple.com/documentation/advancedcommerceapi/misalignedbillingcycleerror)
    case misalignedBillingCycle = 4000147

    ///Bill cycle reset with effective later.
    ///
    ///[BillingCycleResetWithEffectiveLaterError](https://developer.apple.com/documentation/advancedcommerceapi/billingcycleresetwitheffectivelatererror)
    case billingCycleResetWithEffectiveLater = 4000148

    ///Period change immediately with effective later.
    ///
    ///[PeriodChangeImmediateWithEffectiveAtNextBillingCycleError](https://developer.apple.com/documentation/advancedcommerceapi/periodchangeimmediatewitheffectiveatnextbillingcycleerror)
    case periodChangeImmediateWithEffectiveAtNextBillingCycle = 4000149

    ///Prorated price and offer price are mutually exclusive.
    ///
    ///[MultiplePricesError](https://developer.apple.com/documentation/advancedcommerceapi/multiplepriceserror)
    case multiplePrices = 4000150

    ///The prorated price was invalid.
    ///
    ///[InvalidProratedPriceError](https://developer.apple.com/documentation/advancedcommerceapi/invalidproratedpriceerror)
    case invalidProratedPrice = 4000151

    ///The subscription offer price is higher than the regular subscription price.
    ///
    ///[InvalidOfferPriceError](https://developer.apple.com/documentation/advancedcommerceapi/invalidofferpriceerror)
    case invalidOfferPrice = 4000152

    ///The refundAmount value is invalid.
    ///
    ///[NullRefundAmountError](https://developer.apple.com/documentation/advancedcommerceapi/nullrefundamounterror)
    case nullRefundAmount = 4000153

    ///The refundAmount must be a positive number.
    ///
    ///[NegativeRefundAmountError](https://developer.apple.com/documentation/advancedcommerceapi/negativerefundamounterror)
    case negativeRefundAmount = 4000154

    ///Can't provide the refund amount because the refundType isn't CUSTOM.
    ///
    ///[RefundAmountWithoutCustomError](https://developer.apple.com/documentation/advancedcommerceapi/refundamountwithoutcustomerror)
    case refundAmountWithoutCustom = 4000155

    ///The required field, refundReason, is missing.
    ///
    ///[NullRefundReasonError](https://developer.apple.com/documentation/advancedcommerceapi/nullrefundreasonerror)
    case nullRefundReason = 4000156

    ///The required field, refundType, is missing.
    ///
    ///[NullRefundTypeError](https://developer.apple.com/documentation/advancedcommerceapi/nullrefundtypeerror)
    case nullRefundType = 4000157

    ///The type SIMULATE_REFUND_DECLINE is only valid in Sandbox.
    ///
    ///[SimulateRefundDeclineOnlyInSandboxError](https://developer.apple.com/documentation/advancedcommerceapi/simulaterefunddeclineonlyinsandboxerror)
    case simulateRefundDeclineOnlyInSandbox = 4000158

    ///The required field, refundRiskingPreference, is missing.
    ///
    ///[NullRefundRiskingError](https://developer.apple.com/documentation/advancedcommerceapi/nullrefundriskingerror)
    case nullRefundRisking = 4000159

    ///When included, provide at least one item in items.
    ///
    ///[AtLeastOneItemError](https://developer.apple.com/documentation/advancedcommerceapi/atleastoneitemerror)
    case atLeastOneItem = 4000160

    ///An error that indicates the image that’s uploading is invalid.
    ///
    ///[InvalidImageError](https://developer.apple.com/documentation/retentionmessaging/invalidimageerror)
    case invalidImage = 4000161

    ///An error that indicates the header text is too long.
    ///
    ///[HeaderTooLongError](https://developer.apple.com/documentation/retentionmessaging/headertoolongerror)
    case headerTooLong = 4000162

    ///An error that indicates the body text is too long.
    ///
    ///[BodyTooLongError](https://developer.apple.com/documentation/retentionmessaging/bodytoolongerror)
    case bodyTooLong = 4000163

    ///An error that indicates the locale is invalid.
    ///
    ///[InvalidLocaleError](https://developer.apple.com/documentation/retentionmessaging/invalidlocaleerror)
    case invalidLocale = 4000164

    ///Provide either the displayName or a description.
    ///
    ///[AtLeastOneOfDisplayNameOrDescriptionError](https://developer.apple.com/documentation/advancedcommerceapi/atleastoneofdisplaynameordescriptionerror)
    case atLeastOneOfDisplayNameOrDescription = 4000165

    ///The required field, targetProductID, is missing.
    ///
    ///[NullTargetProductIDError](https://developer.apple.com/documentation/advancedcommerceapi/nulltargetproductiderror)
    case nullTargetProductID = 4000166

    ///The targetProductID value is invalid.
    ///
    ///[InvalidTargetProductIDError](https://developer.apple.com/documentation/advancedcommerceapi/invalidtargetproductiderror)
    case invalidTargetProductID = 4000167

    ///The active subscription must contain at least one item and cannot be completely empty.
    ///
    ///[RemovalAllNotAllowedError](https://developer.apple.com/documentation/advancedcommerceapi/removalallnotallowederror)
    case removalAllNotAllowed = 4000168

    ///The required field, currentSKU, is missing.
    ///
    ///[NullCurrentSKUError](https://developer.apple.com/documentation/advancedcommerceapi/nullcurrentskuerror)
    case nullCurrentSKU = 4000169

    ///Exceeds the maximum length of the currentSKU field.
    ///
    ///[CurrentSKULengthExceededError](https://developer.apple.com/documentation/advancedcommerceapi/currentskulengthexceedederror)
    case currentSKULengthExceeded = 4000170

    ///The required field, advancedCommerceData, was null.
    ///
    ///[NullAdvancedCommerceDataError](https://developer.apple.com/documentation/advancedcommerceapi/nulladvancedcommercedataerror)
    case nullAdvancedCommerceData = 4000171

    ///The operation is invalid.
    ///
    ///[InvalidOperationError](https://developer.apple.com/documentation/advancedcommerceapi/invalidoperationerror)
    case invalidOperation = 4000172

    ///The payload is malformed.
    ///
    ///[MalformedPayloadError](https://developer.apple.com/documentation/advancedcommerceapi/malformedpayloaderror)
    case malformedPayload = 4000173

    ///The signature is invalid.
    ///
    ///[InvalidSignatureError](https://developer.apple.com/documentation/advancedcommerceapi/invalidsignatureerror)
    case invalidSignature = 4000174

    ///An error that indicates the alternative text for an image is too long.
    ///
    ///[AltTextTooLongError](https://developer.apple.com/documentation/retentionmessaging/alttexttoolongerror)
    case altTextTooLong = 4000175

    ///The subscription was already migrated.
    ///
    ///[SubscriptionAlreadyMigratedError](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionalreadymigratederror)
    case subscriptionAlreadyMigrated = 4000176

    ///An active or pending offer prevents changes to the item mid-cycle.
    ///
    ///[OfferPreventsItemMidCycleChangeError](https://developer.apple.com/documentation/advancedcommerceapi/offerpreventsitemmidcyclechangeerror)
    case offerPreventsItemMidCycleChange = 4000177

    ///Price change is not allowed through plan modification.
    ///
    ///[PriceChangeNotSupportedThroughModifyItemsError](https://developer.apple.com/documentation/advancedcommerceapi/pricechangenotsupportedthroughmodifyitemserror)
    case priceChangeNotSupportedThroughModifyItems = 4000178

    ///The number of items in subscription exceeds the limit.
    ///
    ///[ItemLimitExceededError](https://developer.apple.com/documentation/advancedcommerceapi/itemlimitexceedederror)
    case itemLimitExceeded = 4000179

    ///Pending subscription changes must specify a renewalItem, and if there are no pending changes, a renewalItem cannot be specified.
    ///
    ///[PendingChangesMismatchError](https://developer.apple.com/documentation/advancedcommerceapi/pendingchangesmismatcherror)
    case pendingChangesMismatch = 4000180

    ///The transaction has pending refunds.
    ///
    ///[PendingRefundError](https://developer.apple.com/documentation/advancedcommerceapi/pendingrefunderror)
    case pendingRefund = 4000181

    ///Only requests against the latest transaction can have a PRORATED refundType value.
    ///
    ///[ProratedOnlyLatestTransactionError](https://developer.apple.com/documentation/advancedcommerceapi/proratedonlylatesttransactionerror)
    case proratedOnlyLatestTransaction = 4000182

    ///An error that indicates the app account token value is not a valid UUID.
    ///
    ///[InvalidAppAccountTokenUUIDError](https://developer.apple.com/documentation/appstoreserverapi/invalidappaccounttokenuuiderror)
    case invalidAppAccountTokenUUID = 4000183

    ///If one item has a refundReason value of SIMULATE_REFUND_DECLINE, all items must have a refundReason value of SIMULATE_REFUND_DECLINE.
    ///
    ///[PartialSimulateRefundDeclineError](https://developer.apple.com/documentation/advancedcommerceapi/partialsimulaterefunddeclineerror)
    case partialSimulateRefundDecline = 4000184

    ///An error that indicates the transaction is for a product the customer obtains through Family Sharing, which the endpoint doesn’t support.
    ///
    ///[FamilyTransactionNotSupportedError](https://developer.apple.com/documentation/appstoreserverapi/familytransactionnotsupportederror)
    case familyTransactionNotSupported = 4000185

    ///Only active subscriptions are revocable.
    ///
    ///[RevokeOnInactiveSubscriptionError](https://developer.apple.com/documentation/advancedcommerceapi/revokeoninactivesubscriptionerror)
    case revokeOnInactiveSubscription = 4000186

    ///An error that indicates the endpoint expects an original transaction identifier.
    ///
    ///[TransactionIdIsNotOriginalTransactionIdError](https://developer.apple.com/documentation/appstoreserverapi/transactionidisnotoriginaltransactioniderror)
    case transactionIdIsNotOriginalTransactionId = 4000187

    ///Invalid request. dependentSKUs can't be shared between multiple SKUs.
    ///
    ///[DependentSKUsCannotBeSharedError](https://developer.apple.com/documentation/advancedcommerceapi/dependentskuscannotbesharederror)
    case dependentSKUsCannotBeShared = 4000192

    ///Invalid request. dependentSKUs can't be chained.
    ///
    ///[DependentSKUsCannotBeChainedError](https://developer.apple.com/documentation/advancedcommerceapi/dependentskuscannotbechainederror)
    case dependentSKUsCannotBeChained = 4000193

    ///Invalid request. The same SKU can't be repeated in this request.
    ///
    ///[ItemCannotBeSpecifiedMultipleTimesError](https://developer.apple.com/documentation/advancedcommerceapi/itemcannotbespecifiedmultipletimeserror)
    case itemCannotBeSpecifiedMultipleTimes = 4000194

    ///Invalid request. A price change can't be issued when the price increase has already been communicated.
    ///
    ///[PriceChangeCannotBeIssuedWhenAlreadyCommunicatedError](https://developer.apple.com/documentation/advancedcommerceapi/pricechangecannotbeissuedwhenalreadycommunicatederror)
    case priceChangeCannotBeIssuedWhenAlreadyCommunicated = 4000205

    ///An error that indicates the consumption percentage is outside the valid range.
    ///
    ///[ConsumptionPercentageOutOfRangeError](https://developer.apple.com/documentation/appstoreserverapi/consumptionpercentageoutofrangeerror)
    case consumptionPercentageOutOfRange = 4000207

    ///An error that indicates the consumption percentage must be zero for the provided delivery status.
    ///
    ///[UndeliveredConsumptionPercentageNonZeroError](https://developer.apple.com/documentation/appstoreserverapi/undeliveredconsumptionpercentagenonzeroerror)
    case undeliveredConsumptionPercentageNonZero = 4000208

    ///An error that indicates the consumption percentage field is unsupported for auto-renewable subscription transactions.
    ///
    ///[ConsumptionPercentageAutoRenewableSubscriptionError](https://developer.apple.com/documentation/appstoreserverapi/consumptionpercentageautorenewablesubscriptionerror)
    case consumptionPercentageAutoRenewableSubscription = 4000209

    ///An error that indicates Advanced Commerce API transactions are not supported by the endpoint.
    ///
    ///[AdvancedCommerceTransactionNotSupportedError](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetransactionnotsupportederror)
    case advancedCommerceTransactionNotSupported = 4000210

    ///An error the API returns that indicates the performance test request is invalid.
    ///
    ///[InvalidPerformanceTestRequestError](https://developer.apple.com/documentation/retentionmessaging/invalidperformancetestrequesterror)
    case invalidPerformanceTestRequest = 4000211

    ///An error that indicates the request ID is invalid.
    ///
    ///[InvalidRequestIdError](https://developer.apple.com/documentation/retentionmessaging/invalidrequestiderror)
    case invalidRequestId = 4000212

    ///An error that indicates an error with an existing test.
    ///
    ///[ExistingPerformanceTestRunError](https://developer.apple.com/documentation/retentionmessaging/existingperformancetestrunerror)
    case existingPerformanceTestRun = 4000213

    ///Invalid request. Price provided for a changed item with an offer while subject to a price increase was invalid.
    ///
    ///[InvalidPriceForChangeItemInPriceIncreaseError](https://developer.apple.com/documentation/advancedcommerceapi/invalidpriceforchangeiteminpriceincreaseerror)
    case invalidPriceForChangeItemInPriceIncrease = 4000214

    ///An error that indicates the URL is invalid.
    ///
    ///[BadRequestRealtimeUrlError](https://developer.apple.com/documentation/retentionmessaging/badrequestrealtimeurlerror)
    case badRequestRealtimeUrl = 4000215

    ///An error that indicates the image size provided is invalid.
    ///
    ///[BadRequestImageSizeError](https://developer.apple.com/documentation/retentionmessaging/badrequestimagesizeerror)
    case badRequestImageSize = 4000216

    ///An error that indicates there are too many bullet points.
    ///
    ///[BadRequestTooManyBulletPointsError](https://developer.apple.com/documentation/retentionmessaging/badrequesttoomanybulletpointserror)
    case badRequestTooManyBulletPoints = 4000218

    ///An error that indicates the text for a bullet point is too long.
    ///
    ///[BadRequestBulletPointTextTooLongError](https://developer.apple.com/documentation/retentionmessaging/badrequestbulletpointtexttoolongerror)
    case badRequestBulletPointTextTooLong = 4000219

    ///Invalid request. SKU values provided in request must be a SKU that will renew.
    ///
    ///[InvalidSKUProvidedMustBeCurrentSKUSetToRenewError](https://developer.apple.com/documentation/advancedcommerceapi/invalidskuprovidedmustbecurrentskusettorenewerror)
    case invalidSKUProvidedMustBeCurrentSKUSetToRenew = 4000220

    ///Advanced Commerce API Price Increase mechanism is not currently supported in India.
    ///
    ///[ACAPriceIncreaseIsNotCurrentlySupportedInIndiaError](https://developer.apple.com/documentation/advancedcommerceapi/acapriceincreaseisnotcurrentlysupportedinindiaerror)
    case acaPriceIncreaseIsNotCurrentlySupportedInIndia = 4000221

    ///Invalid request. A prorated price shouldn't be present to change items with the change taking effect later.
    ///
    ///[InvalidProratedPriceForChangeItemWithEffectiveLaterError](https://developer.apple.com/documentation/advancedcommerceapi/invalidproratedpriceforchangeitemwitheffectivelatererror)
    case invalidProratedPriceForChangeItemWithEffectiveLater = 4000222

    ///Invalid request. The subscription offer configuration is invalid; free trial offers must use a period count of 1.
    ///
    ///[FreeTrialOfferMustUsePeriodCountOfOneError](https://developer.apple.com/documentation/advancedcommerceapi/freetrialoffermustuseperiodcountofoneerror)
    case freeTrialOfferMustUsePeriodCountOfOne = 4000223

    ///An error that indicates that no image object is included, but the request indicates that the header should be placed above the image.
    ///
    ///[BadRequestAboveImageRequiresAnImageError](https://developer.apple.com/documentation/retentionmessaging/badrequestaboveimagerequiresanimageerror)
    case badRequestAboveImageRequiresAnImage = 4000224

    ///An error that indicates the group identifier is invalid.
    ///
    ///[InvalidGroupIdError](https://developer.apple.com/documentation/appstoreserverapi/invalidgroupiderror)
    case invalidGroupId = 4000225

    ///An error that indicates the transaction is one that an organization or group assigns to the customer, which the endpoint doesn’t support.
    ///
    ///[InvalidAssignedTransactionNotSupportedError](https://developer.apple.com/documentation/appstoreserverapi/invalidassignedtransactionnotsupportederror)
    case invalidAssignedTransactionNotSupported = 4000227

    ///Unauthorized.
    ///
    ///[UnauthorizedError](https://developer.apple.com/documentation/advancedcommerceapi/unauthorizederror)
    case unauthorized = 4010000

    ///An error that indicates the subscription doesn’t qualify for a renewal-date extension due to its subscription state.
    ///
    ///[SubscriptionExtensionIneligibleError](https://developer.apple.com/documentation/appstoreserverapi/subscriptionextensionineligibleerror)
    case subscriptionExtensionIneligible = 4030004

    ///An error that indicates the subscription doesn’t qualify for a renewal-date extension because it has already received the maximum extensions.
    ///
    ///[SubscriptionMaxExtensionError](https://developer.apple.com/documentation/appstoreserverapi/subscriptionmaxextensionerror)
    case subscriptionMaxExtension = 4030005

    ///An error that indicates a subscription isn’t directly eligible for a renewal date extension because the customer obtained it through Family Sharing.
    ///
    ///[FamilySharedSubscriptionExtensionIneligibleError](https://developer.apple.com/documentation/appstoreserverapi/familysharedsubscriptionextensionineligibleerror)
    case familySharedSubscriptionExtensionIneligible = 4030007

    ///The subscription doesn't exist.
    ///
    ///[SubscriptionDoesNotExistError](https://developer.apple.com/documentation/advancedcommerceapi/subscriptiondoesnotexisterror)
    case subscriptionDoesNotExist = 4030008

    ///The subscription already exists.
    ///
    ///[SubscriptionAlreadyExistsError](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionalreadyexistserror)
    case subscriptionAlreadyExists = 4030009

    ///The subscription isn't eligible for the requested changes.
    ///
    ///[SubscriptionNotEligibleError](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionnoteligibleerror)
    case subscriptionNotEligible = 4030010

    ///The subscription is already active, and cannot be reactivated or renewed at this time.
    ///
    ///[SubscriptionAlreadyActiveError](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionalreadyactiveerror)
    case subscriptionAlreadyActive = 4030011

    ///The customer doesn't own the product.
    ///
    ///[ProductNotOwnedError](https://developer.apple.com/documentation/advancedcommerceapi/productnotownederror)
    case productNotOwned = 4030013

    ///An error that indicates when you reach the maximum number of uploaded images.
    ///
    ///[MaximumNumberOfImagesReachedError](https://developer.apple.com/documentation/retentionmessaging/maximumnumberofimagesreachederror)
    case maximumNumberOfImagesReached = 4030014

    ///The subscription is not active.
    ///
    ///[InactiveACASubError](https://developer.apple.com/documentation/advancedcommerceapi/inactiveacasuberror)
    case inactiveACASub = 4030015

    ///An error that indicates when you reach the maximum number of uploaded messages.
    ///
    ///[MaximumNumberOfMessagesReachedError](https://developer.apple.com/documentation/retentionmessaging/maximumnumberofmessagesreachederror)
    case maximumNumberOfMessagesReached = 4030016

    ///An error that indicates the message isn’t in the approved state, so you can’t configure it as a default message.
    ///
    ///[MessageNotApprovedError](https://developer.apple.com/documentation/retentionmessaging/messagenotapprovederror)
    case messageNotApproved = 4030017

    ///An error that indicates the image isn’t in the approved state, so you can’t configure it as part of a default message.
    ///
    ///[ImageNotApprovedError](https://developer.apple.com/documentation/retentionmessaging/imagenotapprovederror)
    case imageNotApproved = 4030018

    ///An error that indicates the image is currently in use as part of a message, so you can’t delete it.
    ///
    ///[ImageInUseError](https://developer.apple.com/documentation/retentionmessaging/imageinuseerror)
    case imageInUse = 4030019

    ///Insufficient funds for refund.
    ///
    ///[InsufficientFundsError](https://developer.apple.com/documentation/advancedcommerceapi/insufficientfundserror)
    case insufficientFunds = 4030020

    ///The transaction was already refunded.
    ///
    ///[AlreadyRefundedError](https://developer.apple.com/documentation/advancedcommerceapi/alreadyrefundederror)
    case alreadyRefunded = 4030021

    ///The storefront changed.
    ///
    ///[StorefrontChangeError](https://developer.apple.com/documentation/advancedcommerceapi/storefrontchangeerror)
    case storefrontChange = 4030022

    ///The product isn't eligible for the requested operation.
    ///
    ///[ProductNotEligibleError](https://developer.apple.com/documentation/advancedcommerceapi/productnoteligibleerror)
    case productNotEligible = 4030023

    ///The transaction is not refundable.
    ///
    ///[TransactionNotRefundableError](https://developer.apple.com/documentation/advancedcommerceapi/transactionnotrefundableerror)
    case transactionNotRefundable = 4030024

    ///The transaction can't be refunded; customer can contact Apple Support for assistance.
    ///
    ///[TransactionCannotBeRefundedContactSupportError](https://developer.apple.com/documentation/advancedcommerceapi/transactioncannotberefundedcontactsupporterror)
    case transactionCannotBeRefundedContactSupport = 4030025

    ///An error that indicates that passing a performance test is required before you can set a URL for the production environment.
    ///
    ///[ForbiddenNoPassingTestError](https://developer.apple.com/documentation/retentionmessaging/forbiddennopassingtesterror)
    case forbiddenNoPassingTest = 4030026

    ///The subscription isn't eligible for migration because a price increase has already been communicated to the customer.
    ///
    ///[MigrationNotAllowedWhenPriceIncreaseCommunicatedError](https://developer.apple.com/documentation/advancedcommerceapi/migrationnotallowedwhenpriceincreasecommunicatederror)
    case migrationNotAllowedWhenPriceIncreaseCommunicated = 4030027

    ///An error that indicates a subscription isn’t eligible for a renewal date extension because the customer has access through an organization or group.
    ///
    ///[AssignedSubscriptionExtensionIneligibleError](https://developer.apple.com/documentation/appstoreserverapi/assignedsubscriptionextensionineligibleerror)
    case assignedSubscriptionExtensionIneligible = 4030028

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

    ///An error that indicates an original transaction identifier wasn’t found.
    ///
    ///[OriginalTransactionIdNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionidnotfounderror)
    case originalTransactionIdNotFound = 4040005

    ///An error response that indicates the original transaction identifier wasn’t found, but you can try again.
    ///
    ///[OriginalTransactionIdNotFoundRetryableError](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionidnotfoundretryableerror)
    case originalTransactionIdNotFoundRetryable = 4040006

    ///An error that indicates the App Store server couldn’t find a notifications URL for your app in the environment.
    ///
    ///[ServerNotificationURLNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/servernotificationurlnotfounderror)
    case serverNotificationUrlNotFound = 4040007

    ///An error that indicates the test notification token is expired or the test notification status isn’t available.
    ///
    ///[TestNotificationNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/testnotificationnotfounderror)
    case testNotificationNotFound = 4040008

    ///An error that indicates the server didn’t find a subscription-renewal-date extension request for the request identifier and product identifier you provided.
    ///
    ///[StatusRequestNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/statusrequestnotfounderror)
    case statusRequestNotFound = 4040009

    ///An error that indicates a transaction identifier wasn’t found.
    ///
    ///[TransactionIdNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/transactionidnotfounderror)
    case transactionIdNotFound = 4040010

    ///An error that indicates the system can’t find the image identifier.
    ///
    ///[ImageNotFoundError](https://developer.apple.com/documentation/retentionmessaging/imagenotfounderror)
    case imageNotFound = 4040014

    ///An error that indicates the system can’t find the message identifier.
    ///
    ///[MessageNotFoundError](https://developer.apple.com/documentation/retentionmessaging/messagenotfounderror)
    case messageNotFound = 4040015

    ///Product not found.
    ///
    ///[ProductNotFoundError](https://developer.apple.com/documentation/advancedcommerceapi/productnotfounderror)
    case productNotFound = 4040016

    ///An error the API returns if the service can’t find the specified test run.
    ///
    ///[PerformanceTestRunNotFoundError](https://developer.apple.com/documentation/retentionmessaging/performancetestrunnotfounderror)
    case performanceTestRunNotFound = 4040018

    ///An error response that indicates an app transaction doesn’t exist for the specified customer.
    ///
    ///[AppTransactionDoesNotExistError](https://developer.apple.com/documentation/appstoreserverapi/apptransactiondoesnotexisterror)
    case appTransactionDoesNotExist = 4040019

    ///An error that indicates a default message isn’t configured.
    ///
    ///[DefaultMessageNotFoundError](https://developer.apple.com/documentation/retentionmessaging/defaultmessagenotfounderror)
    case defaultMessageNotFound = 4040020

    ///An error that indicates that the URL for your endpoint isn’t configured.
    ///
    ///[RealtimeUrlNotFoundError](https://developer.apple.com/documentation/retentionmessaging/realtimeurlnotfounderror)
    case realtimeUrlNotFound = 4040021

    ///An error that indicates the group wasn’t found.
    ///
    ///[GroupNotFoundError](https://developer.apple.com/documentation/appstoreserverapi/groupnotfounderror)
    case groupNotFound = 4040022

    ///An error that indicates the image identifier already exists.
    ///
    ///[ImageAlreadyExistsError](https://developer.apple.com/documentation/retentionmessaging/imagealreadyexistserror)
    case imageAlreadyExists = 4090000

    ///An error that indicates the message identifier already exists.
    ///
    ///[MessageAlreadyExistsError](https://developer.apple.com/documentation/retentionmessaging/messagealreadyexistserror)
    case messageAlreadyExists = 4090001

    ///An error that indicates the request exceeded the rate limit.
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
    @available(*, deprecated, message: "Use v2 instead")
    case v1 = "v1"
    case v2 = "v2"
}

struct RequestPath: ExpressibleByStringInterpolation {
    private static let pathSegmentAllowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")

    let value: String
    let isValid: Bool

    init(stringLiteral value: String) {
        self.value = value
        self.isValid = true
    }

    init(stringInterpolation: StringInterpolation) {
        self.value = stringInterpolation.value
        self.isValid = stringInterpolation.isValid
    }

    struct StringInterpolation: StringInterpolationProtocol {
        var value = ""
        var isValid = true

        init(literalCapacity: Int, interpolationCount: Int) {
            value.reserveCapacity(literalCapacity)
        }

        mutating func appendLiteral(_ literal: String) {
            value += literal
        }

        mutating func appendInterpolation(_ pathSegment: String) {
            let encoded = pathSegment.addingPercentEncoding(withAllowedCharacters: RequestPath.pathSegmentAllowedCharacters) ?? ""
            if encoded.isEmpty || encoded == "." || encoded == ".." {
                isValid = false
            }
            value += encoded
        }
    }
}
