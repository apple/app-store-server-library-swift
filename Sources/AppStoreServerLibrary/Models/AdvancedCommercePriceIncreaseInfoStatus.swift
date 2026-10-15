// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[advancedCommercePriceIncreaseInfoStatus](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercepriceincreaseinfostatus)
public enum AdvancedCommercePriceIncreaseInfoStatus: String, Decodable, Encodable, Hashable, Sendable {
    case scheduled = "SCHEDULED"
    case pending = "PENDING"
    case accepted = "ACCEPTED"
}
