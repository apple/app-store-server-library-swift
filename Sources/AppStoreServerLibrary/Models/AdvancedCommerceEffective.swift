// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A string value that indicates when a requested change to an auto-renewable subscription goes into effect.
///
///[effective](https://developer.apple.com/documentation/advancedcommerceapi/effective)
public enum AdvancedCommerceEffective: String, Decodable, Encodable, Hashable, Sendable {
    case immediately = "IMMEDIATELY"
    case nextBillCycle = "NEXT_BILL_CYCLE"
}
