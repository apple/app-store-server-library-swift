// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///A response that indicates whether an individual renewal-date extension succeeded, and related details.
///
///[ExtendRenewalDateResponse](https://developer.apple.com/documentation/appstoreserverapi/extendrenewaldateresponse)
public struct ExtendRenewalDateResponse: Decodable, Encodable, Hashable, Sendable {

    public init(effectiveDate: Date? = nil, originalTransactionId: String? = nil, success: Bool? = nil, webOrderLineItemId: String? = nil) {
        self.effectiveDate = effectiveDate
        self.originalTransactionId = originalTransactionId
        self.success = success
        self.webOrderLineItemId = webOrderLineItemId
    }

    ///The new subscription expiration date of a successful subscription-renewal-date extension.
    ///
    ///[effectiveDate](https://developer.apple.com/documentation/appstoreserverapi/effectivedate)
    public var effectiveDate: Date?

    ///The original transaction identifier of the subscription that experienced a service interruption.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?

    ///A Boolean value that indicates whether the subscription-renewal-date extension succeeded.
    ///
    ///[success](https://developer.apple.com/documentation/appstoreserverapi/success)
    public var success: Bool?

    ///A unique ID that identifies subscription-purchase events, including subscription renewals, across devices.
    ///
    ///[webOrderLineItemId](https://developer.apple.com/documentation/appstoreserverapi/weborderlineitemid)
    public var webOrderLineItemId: String?

    public enum CodingKeys: CodingKey {
        case effectiveDate
        case originalTransactionId
        case success
        case webOrderLineItemId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.effectiveDate = try container.decodeIfPresent(Double.self, forKey: .effectiveDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.originalTransactionId = try container.decodeIfPresent(String.self, forKey: .originalTransactionId)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
        self.webOrderLineItemId = try container.decodeIfPresent(String.self, forKey: .webOrderLineItemId)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.effectiveDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .effectiveDate)
        try container.encodeIfPresent(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encodeIfPresent(self.success, forKey: .success)
        try container.encodeIfPresent(self.webOrderLineItemId, forKey: .webOrderLineItemId)
    }
}
