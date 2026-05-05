// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///A response object you provide to present an offer or switch-plan recommendation message.
///
///[advancedCommerceInfo](https://developer.apple.com/documentation/retentionmessaging/advancedcommerceinfo)
public struct AdvancedCommerceInfo: Decodable, Encodable, Hashable, Sendable {

    public init(messageIdentifier: UUID? = nil, advancedCommerceData: String? = nil) {
        self.messageIdentifier = messageIdentifier
        self.advancedCommerceData = advancedCommerceData
    }

    ///The identifier of the message to display to the customer, along with the offer or switch-plan recommendation provided in advancedCommerceData.
    ///
    ///[messageIdentifier](https://developer.apple.com/documentation/retentionmessaging/messageidentifier)
    public var messageIdentifier: UUID?

    ///A Base64-encoded JSON object which contains a JWS describing an offer or switch-plan recommendation.
    ///
    ///[advancedCommerceData](https://developer.apple.com/documentation/retentionmessaging/advancedcommercedata)
    public var advancedCommerceData: String?
}
