// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///Information about the refund request for an item, such as its SKU, the refund amount, reason, and type.
///
///[RequestRefundItem](https://developer.apple.com/documentation/advancedcommerceapi/requestrefunditem)
public struct AdvancedCommerceRequestRefundItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, refundReason: AdvancedCommerceRefundReason, refundType: AdvancedCommerceRefundType, revoke: Bool, refundAmount: Int32? = nil) throws {
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
        self.rawRefundReason = refundReason.rawValue
        self.rawRefundType = refundType.rawValue
        self.revoke = revoke
        self.refundAmount = refundAmount
    }

    public init(sku: String, rawRefundReason: String, rawRefundType: String, revoke: Bool, refundAmount: Int32? = nil) throws {
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
        self.rawRefundReason = rawRefundReason
        self.rawRefundType = rawRefundType
        self.revoke = revoke
        self.refundAmount = refundAmount
    }

    ///The product identifier.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    ///The refund amount you’re requesting for the SKU, in milliunits of the currency.
    ///
    ///[refundAmount](https://developer.apple.com/documentation/advancedcommerceapi/refundamount)
    public var refundAmount: Int32?

    ///The reason for the refund request.
    ///
    ///[refundReason](https://developer.apple.com/documentation/advancedcommerceapi/refundreason)
    public var refundReason: AdvancedCommerceRefundReason? {
        get {
            return AdvancedCommerceRefundReason(rawValue: rawRefundReason)
        }
        set {
            self.rawRefundReason = newValue.map { $0.rawValue } ?? rawRefundReason
        }
    }

    ///See ``refundReason``
    public var rawRefundReason: String

    ///The type of refund requested.
    public var refundType: AdvancedCommerceRefundType? {
        get {
            return AdvancedCommerceRefundType(rawValue: rawRefundType)
        }
        set {
            self.rawRefundType = newValue.map { $0.rawValue } ?? rawRefundType
        }
    }

    ///See ``refundType``
    public var rawRefundType: String

    ///A Boolean value that indicates whether to revoke the customer's access to the product.
    ///
    ///[revoke](https://developer.apple.com/documentation/advancedcommerceapi/revoke)
    public var revoke: Bool

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case refundAmount
        case refundReason
        case refundType
        case revoke
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sku = try container.decode(String.self, forKey: .sku)
        self.refundAmount = try container.decodeIfPresent(Int32.self, forKey: .refundAmount)
        self.rawRefundReason = try container.decode(String.self, forKey: .refundReason)
        self.rawRefundType = try container.decode(String.self, forKey: .refundType)
        self.revoke = try container.decode(Bool.self, forKey: .revoke)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.sku, forKey: .sku)
        try container.encodeIfPresent(self.refundAmount, forKey: .refundAmount)
        try container.encode(self.rawRefundReason, forKey: .refundReason)
        try container.encode(self.rawRefundType, forKey: .refundType)
        try container.encode(self.revoke, forKey: .revoke)
    }
}
