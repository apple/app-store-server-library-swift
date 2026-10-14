// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[SubscriptionModifyChangeItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmodifychangeitem)
public enum AdvancedCommerceReason: String, Decodable, Encodable, Hashable, Sendable {
    case upgrade = "UPGRADE"
    case downgrade = "DOWNGRADE"
    case applyOffer = "APPLY_OFFER"
}
