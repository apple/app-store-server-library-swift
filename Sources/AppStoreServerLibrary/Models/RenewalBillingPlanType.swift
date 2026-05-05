// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[renewalBillingPlanType](https://developer.apple.com/documentation/appstoreserverapi/renewalbillingplantype)
public enum RenewalBillingPlanType: String, Decodable, Encodable, Hashable, Sendable {
    case billedUpfront = "BILLED_UPFRONT"
    case monthly = "MONTHLY"
}
