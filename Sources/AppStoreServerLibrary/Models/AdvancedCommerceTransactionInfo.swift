// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[advancedCommerceTransactionInfo](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetransactioninfo)
public struct AdvancedCommerceTransactionInfo: Decodable, Encodable, Hashable, Sendable {

    public init(descriptors: AdvancedCommerceDescriptors? = nil, estimatedTax: Int64? = nil, items: [AdvancedCommerceTransactionItem]? = nil, period: AdvancedCommercePeriod? = nil, requestReferenceId: String? = nil, taxCode: String? = nil, taxExclusivePrice: Int64? = nil, taxRate: String? = nil) {
        self.init(descriptors: descriptors, estimatedTax: estimatedTax, items: items, rawPeriod: period?.rawValue, requestReferenceId: requestReferenceId, taxCode: taxCode, taxExclusivePrice: taxExclusivePrice, taxRate: taxRate)
    }

    public init(descriptors: AdvancedCommerceDescriptors? = nil, estimatedTax: Int64? = nil, items: [AdvancedCommerceTransactionItem]? = nil, rawPeriod: String? = nil, requestReferenceId: String? = nil, taxCode: String? = nil, taxExclusivePrice: Int64? = nil, taxRate: String? = nil) {
        self.descriptors = descriptors
        self.estimatedTax = estimatedTax
        self.items = items
        self.rawPeriod = rawPeriod
        self.requestReferenceId = requestReferenceId
        self.taxCode = taxCode
        self.taxExclusivePrice = taxExclusivePrice
        self.taxRate = taxRate
    }

    ///[advancedCommerceDescriptors](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercedescriptors)
    public var descriptors: AdvancedCommerceDescriptors?

    ///[advancedCommerceEstimatedTax](https://developer.apple.com/documentation/appstoreserverapi/advancedcommerceestimatedtax)
    public var estimatedTax: Int64?

    ///[advancedCommerceTransactionItem](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetransactionitem)
    public var items: [AdvancedCommerceTransactionItem]?

    ///[advancedCommercePeriod](https://developer.apple.com/documentation/appstoreserverapi/advancedcommerceperiod)
    public var period: AdvancedCommercePeriod? {
        get {
            return rawPeriod.flatMap { AdvancedCommercePeriod(rawValue: $0) }
        }
        set {
            self.rawPeriod = newValue.map { $0.rawValue }
        }
    }

    ///See ``period``
    public var rawPeriod: String?

    ///[advancedCommerceRequestReferenceId](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerequestreferenceid)
    public var requestReferenceId: String?

    ///[advancedCommerceTaxCode](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetaxcode)
    public var taxCode: String?

    ///[advancedCommerceTaxExclusivePrice](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetaxexclusiveprice)
    public var taxExclusivePrice: Int64?

    ///[advancedCommerceTaxRate](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercetaxrate)
    public var taxRate: String?

    public enum CodingKeys: CodingKey {
        case descriptors
        case estimatedTax
        case items
        case period
        case requestReferenceId
        case taxCode
        case taxExclusivePrice
        case taxRate
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.descriptors = try container.decodeIfPresent(AdvancedCommerceDescriptors.self, forKey: .descriptors)
        self.estimatedTax = try container.decodeIfPresent(Int64.self, forKey: .estimatedTax)
        self.items = try container.decodeIfPresent([AdvancedCommerceTransactionItem].self, forKey: .items)
        self.rawPeriod = try container.decodeIfPresent(String.self, forKey: .period)
        self.requestReferenceId = try container.decodeIfPresent(String.self, forKey: .requestReferenceId)
        self.taxCode = try container.decodeIfPresent(String.self, forKey: .taxCode)
        self.taxExclusivePrice = try container.decodeIfPresent(Int64.self, forKey: .taxExclusivePrice)
        self.taxRate = try container.decodeIfPresent(String.self, forKey: .taxRate)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.descriptors, forKey: .descriptors)
        try container.encodeIfPresent(self.estimatedTax, forKey: .estimatedTax)
        try container.encodeIfPresent(self.items, forKey: .items)
        try container.encodeIfPresent(self.rawPeriod, forKey: .period)
        try container.encodeIfPresent(self.requestReferenceId, forKey: .requestReferenceId)
        try container.encodeIfPresent(self.taxCode, forKey: .taxCode)
        try container.encodeIfPresent(self.taxExclusivePrice, forKey: .taxExclusivePrice)
        try container.encodeIfPresent(self.taxRate, forKey: .taxRate)
    }
}
