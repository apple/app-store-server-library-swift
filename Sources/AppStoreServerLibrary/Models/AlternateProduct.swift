// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A switch-plan message and product ID you provide in a real-time response to your Get Retention Message endpoint.
///
///[alternateProduct](https://developer.apple.com/documentation/retentionmessaging/alternateproduct)
public struct AlternateProduct: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID? = nil, productId: String? = nil) {
        self.messageIdentifier = messageIdentifier
        self.productId = productId
    }

    ///The message identifier of the text to display in the switch-plan retention message.
    ///
    ///[messageIdentifier](https://developer.apple.com/documentation/retentionmessaging/messageidentifier)
    public var messageIdentifier: UUID?

    ///The product identifier of the subscription the retention message suggests for your customer to switch to.
    ///
    ///[productId](https://developer.apple.com/documentation/retentionmessaging/productid)
    public var productId: String?
}
