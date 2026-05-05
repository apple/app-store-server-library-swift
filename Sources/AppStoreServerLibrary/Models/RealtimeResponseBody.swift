// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A response you provide to choose, in real time, a retention message the system displays to the customer.
///
///[RealtimeResponseBody](https://developer.apple.com/documentation/retentionmessaging/realtimeresponsebody)
public struct RealtimeResponseBody: Decodable, Encodable, Hashable, Sendable {

    public init(message: Message? = nil, alternateProduct: AlternateProduct? = nil, promotionalOffer: PromotionalOffer? = nil, advancedCommerceInfo: AdvancedCommerceInfo? = nil) {
        self.message = message
        self.alternateProduct = alternateProduct
        self.promotionalOffer = promotionalOffer
        self.advancedCommerceInfo = advancedCommerceInfo
    }

    ///A retention message that's text-based and can include an optional image.
    ///
    ///[message](https://developer.apple.com/documentation/retentionmessaging/message)
    public var message: Message?

    ///A retention message with a switch-plan option.
    ///
    ///[alternateProduct](https://developer.apple.com/documentation/retentionmessaging/alternateproduct)
    public var alternateProduct: AlternateProduct?

    ///A retention message that includes a promotional offer.
    ///
    ///[promotionalOffer](https://developer.apple.com/documentation/retentionmessaging/promotionaloffer)
    public var promotionalOffer: PromotionalOffer?

    ///A retention offer or switch plan option.
    ///
    ///[advancedCommerceInfo](https://developer.apple.com/documentation/retentionmessaging/advancedcommerceinfo)
    public var advancedCommerceInfo: AdvancedCommerceInfo?
}
