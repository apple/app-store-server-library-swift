// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///[advancedCommerceRefund](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerefund)
public struct AdvancedCommerceRefund: Decodable, Encodable, Hashable, Sendable {

    public init(refundAmount: Int64? = nil, refundDate: Date? = nil, refundReason: AdvancedCommerceRefundReason? = nil, refundType: AdvancedCommerceRefundType? = nil) {
        self.init(refundAmount: refundAmount, refundDate: refundDate, rawRefundReason: refundReason?.rawValue, rawRefundType: refundType?.rawValue)
    }

    public init(refundAmount: Int64? = nil, refundDate: Date? = nil, rawRefundReason: String? = nil, rawRefundType: String? = nil) {
        self.refundAmount = refundAmount
        self.refundDate = refundDate
        self.rawRefundReason = rawRefundReason
        self.rawRefundType = rawRefundType
    }

    ///[advancedCommerceRefundAmount](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerefundamount)
    public var refundAmount: Int64?

    ///[advancedCommerceRefundDate](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerefunddate)
    public var refundDate: Date?

    ///[advancedCommerceRefundReason](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerefundreason)
    public var refundReason: AdvancedCommerceRefundReason? {
        get {
            return rawRefundReason.flatMap { AdvancedCommerceRefundReason(rawValue: $0) }
        }
        set {
            self.rawRefundReason = newValue.map { $0.rawValue }
        }
    }

    ///See ``refundReason``
    public var rawRefundReason: String?

    ///[advancedCommerceRefundType](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerefundtype)
    public var refundType: AdvancedCommerceRefundType? {
        get {
            return rawRefundType.flatMap { AdvancedCommerceRefundType(rawValue: $0) }
        }
        set {
            self.rawRefundType = newValue.map { $0.rawValue }
        }
    }

    ///See ``refundType``
    public var rawRefundType: String?

    public enum CodingKeys: CodingKey {
        case refundAmount
        case refundDate
        case refundReason
        case refundType
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.refundAmount = try container.decodeIfPresent(Int64.self, forKey: .refundAmount)
        self.refundDate = try container.decodeIfPresent(Date.self, forKey: .refundDate)
        self.rawRefundReason = try container.decodeIfPresent(String.self, forKey: .refundReason)
        self.rawRefundType = try container.decodeIfPresent(String.self, forKey: .refundType)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.refundAmount, forKey: .refundAmount)
        try container.encodeIfPresent(self.refundDate, forKey: .refundDate)
        try container.encodeIfPresent(self.rawRefundReason, forKey: .refundReason)
        try container.encodeIfPresent(self.rawRefundType, forKey: .refundType)
    }
}
