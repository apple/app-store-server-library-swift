// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[billingPlanType](https://developer.apple.com/documentation/appstoreserverapi/billingplantype)
public enum BillingPlanType: String, Decodable, Encodable, Hashable, Sendable {
    case billedUpfront = "BILLED_UPFRONT"
    case monthly = "MONTHLY"
}
