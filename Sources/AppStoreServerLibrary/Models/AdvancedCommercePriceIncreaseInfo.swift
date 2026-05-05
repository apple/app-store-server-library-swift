// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[advancedCommercePriceIncreaseInfo](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercepriceincreaseinfo)
public struct AdvancedCommercePriceIncreaseInfo: Decodable, Encodable, Hashable, Sendable {

    public init(dependentSKUs: [String]? = nil, price: Int64? = nil, status: AdvancedCommercePriceIncreaseInfoStatus? = nil) {
        self.init(dependentSKUs: dependentSKUs, price: price, rawStatus: status?.rawValue)
    }

    public init(dependentSKUs: [String]? = nil, price: Int64? = nil, rawStatus: String? = nil) {
        self.dependentSKUs = dependentSKUs
        self.price = price
        self.rawStatus = rawStatus
    }

    ///[advancedCommercePriceIncreaseInfoDependentSKU](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercepriceincreaseinfodependentsku)
    public var dependentSKUs: [String]?

    ///[advancedCommercePriceIncreaseInfoPrice](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercepriceincreaseinfoprice)
    public var price: Int64?

    ///[advancedCommercePriceIncreaseInfoStatus](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercepriceincreaseinfostatus)
    public var status: AdvancedCommercePriceIncreaseInfoStatus? {
        get {
            return rawStatus.flatMap { AdvancedCommercePriceIncreaseInfoStatus(rawValue: $0) }
        }
        set {
            self.rawStatus = newValue.map { $0.rawValue }
        }
    }

    ///See ``status``
    public var rawStatus: String?

    public enum CodingKeys: CodingKey {
        case dependentSKUs
        case price
        case status
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dependentSKUs = try container.decodeIfPresent([String].self, forKey: .dependentSKUs)
        self.price = try container.decodeIfPresent(Int64.self, forKey: .price)
        self.rawStatus = try container.decodeIfPresent(String.self, forKey: .status)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.dependentSKUs, forKey: .dependentSKUs)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.rawStatus, forKey: .status)
    }
}
