// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A switch-plan message and product ID you provide in a real-time response to your Get Retention Message endpoint.
///
///[alternateProduct](https://developer.apple.com/documentation/retentionmessaging/alternateproduct)
public struct AlternateProduct: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID? = nil, productId: String? = nil, billingPlanType: BillingPlanType? = nil) {
        self.init(messageIdentifier: messageIdentifier, productId: productId, rawBillingPlanType: billingPlanType?.rawValue)
    }

    public init(messageIdentifier: UUID? = nil, productId: String? = nil, rawBillingPlanType: String? = nil) {
        self.messageIdentifier = messageIdentifier
        self.productId = productId
        self.rawBillingPlanType = rawBillingPlanType
    }

    ///The message identifier of the text to display in the switch-plan retention message.
    ///
    ///[messageIdentifier](https://developer.apple.com/documentation/retentionmessaging/messageidentifier)
    public var messageIdentifier: UUID?

    ///The product identifier of the subscription the retention message suggests for your customer to switch to.
    ///
    ///[productId](https://developer.apple.com/documentation/retentionmessaging/productid)
    public var productId: String?

    ///[billingPlanType](https://developer.apple.com/documentation/retentionmessaging/billingplantype)
    public var billingPlanType: BillingPlanType? {
        get {
            return rawBillingPlanType.flatMap { BillingPlanType(rawValue: $0) }
        }
        set {
            self.rawBillingPlanType = newValue.map { $0.rawValue }
        }
    }

    ///See ``billingPlanType``
    public var rawBillingPlanType: String?

    public enum CodingKeys: CodingKey {
        case messageIdentifier
        case productId
        case billingPlanType
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.messageIdentifier = try container.decodeIfPresent(UUID.self, forKey: .messageIdentifier)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.rawBillingPlanType = try container.decodeIfPresent(String.self, forKey: .billingPlanType)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.messageIdentifier, forKey: .messageIdentifier)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.rawBillingPlanType, forKey: .billingPlanType)
    }
}
