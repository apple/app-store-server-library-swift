// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The decoded request body the App Store sends to your server to request a real-time retention message.
///
///[DecodedRealtimeRequestBody](https://developer.apple.com/documentation/retentionmessaging/decodedrealtimerequestbody)
public struct DecodedRealtimeRequestBody: DecodedSignedData, Decodable, Encodable, Hashable, Sendable {

    public init(originalTransactionId: String, appAppleId: Int64, productId: String, userLocale: String, requestIdentifier: UUID, signedDate: Date, environment: AppStoreEnvironment) {
        self.originalTransactionId = originalTransactionId
        self.appAppleId = appAppleId
        self.productId = productId
        self.userLocale = userLocale
        self.requestIdentifier = requestIdentifier
        self.signedDate = signedDate
        self.rawEnvironment = environment.rawValue
    }

    public init(originalTransactionId: String, appAppleId: Int64, productId: String, userLocale: String, requestIdentifier: UUID, signedDate: Date, rawEnvironment: String) {
        self.originalTransactionId = originalTransactionId
        self.appAppleId = appAppleId
        self.productId = productId
        self.userLocale = userLocale
        self.requestIdentifier = requestIdentifier
        self.signedDate = signedDate
        self.rawEnvironment = rawEnvironment
    }

    ///The original transaction identifier of the customer's subscription.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/retentionmessaging/originaltransactionid)
    public var originalTransactionId: String

    ///The unique identifier of the app in the App Store.
    ///
    ///[appAppleId](https://developer.apple.com/documentation/retentionmessaging/appappleid)
    public var appAppleId: Int64

    ///The unique identifier of the auto-renewable subscription.
    ///
    ///[productId](https://developer.apple.com/documentation/retentionmessaging/productid)
    public var productId: String

    ///The device's locale.
    ///
    ///[locale](https://developer.apple.com/documentation/retentionmessaging/locale)
    public var userLocale: String

    ///A UUID the App Store server creates to uniquely identify each request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/retentionmessaging/requestidentifier)
    public var requestIdentifier: UUID

    ///The UNIX time, in milliseconds, that the App Store signed the JSON Web Signature (JWS) data.
    ///
    ///[signedDate](https://developer.apple.com/documentation/retentionmessaging/signeddate)
    public var signedDate: Date

    public var signedDateOptional: Date? {
        signedDate
    }

    ///See ``rawEnvironment``
    public var environment: AppStoreEnvironment? {
        AppStoreEnvironment(rawValue: rawEnvironment)
    }

    ///The server environment, either sandbox or production.
    ///
    ///[environment](https://developer.apple.com/documentation/retentionmessaging/environment)
    public var rawEnvironment: String

    enum CodingKeys: CodingKey {
        case originalTransactionId
        case appAppleId
        case productId
        case userLocale
        case requestIdentifier
        case signedDate
        case environment
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.originalTransactionId = try container.decode(String.self, forKey: .originalTransactionId)
        self.appAppleId = try container.decode(Int64.self, forKey: .appAppleId)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.userLocale = try container.decode(String.self, forKey: .userLocale)
        self.requestIdentifier = try container.decode(UUID.self, forKey: .requestIdentifier)
        self.signedDate = try container.decode(Date.self, forKey: .signedDate)
        self.rawEnvironment = try container.decode(String.self, forKey: .environment)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encode(self.appAppleId, forKey: .appAppleId)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.userLocale, forKey: .userLocale)
        try container.encode(self.requestIdentifier, forKey: .requestIdentifier)
        try container.encode(self.signedDate, forKey: .signedDate)
        try container.encode(self.rawEnvironment, forKey: .environment)
    }
}
