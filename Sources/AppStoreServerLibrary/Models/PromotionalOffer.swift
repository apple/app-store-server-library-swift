// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A promotional offer and message you provide in a real-time response to your Get Retention Message endpoint.
///
///[promotionalOffer](https://developer.apple.com/documentation/retentionmessaging/promotionaloffer)
public struct PromotionalOffer: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID? = nil, promotionalOfferSignatureV2: String? = nil, promotionalOfferSignatureV1: PromotionalOfferSignatureV1? = nil) {
        self.messageIdentifier = messageIdentifier
        self.promotionalOfferSignatureV2 = promotionalOfferSignatureV2
        self.promotionalOfferSignatureV1 = promotionalOfferSignatureV1
    }

    ///The identifier of the message to display to the customer, along with the promotional offer.
    ///
    ///[messageIdentifier](https://developer.apple.com/documentation/retentionmessaging/messageidentifier)
    public var messageIdentifier: UUID?

    ///The promotional offer signature in V2 format.
    ///
    ///[promotionalOfferSignatureV2](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev2)
    public var promotionalOfferSignatureV2: String?

    ///The promotional offer signature in V1 format.
    ///
    ///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
    public var promotionalOfferSignatureV1: PromotionalOfferSignatureV1?
}
