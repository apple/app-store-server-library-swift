// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A string value that indicates when a requested change to an auto-renewable subscription goes into effect.
///
///[effective](https://developer.apple.com/documentation/advancedcommerceapi/effective)
public enum AdvancedCommerceEffective: String, Decodable, Encodable, Hashable, Sendable {
    ///The requested change goes into effect immediately.
    case immediately = "IMMEDIATELY"

    ///The requested change goes into effect at the start of the next billing cycle.
    case nextBillCycle = "NEXT_BILL_CYCLE"
}
