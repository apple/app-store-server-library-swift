// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///[advancedCommerceRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerenewalinfo)
public struct AdvancedCommerceRenewalInfo: Decodable, Encodable, Hashable, Sendable {

    public init(consistencyToken: String? = nil, descriptors: AdvancedCommerceDescriptors? = nil, items: [AdvancedCommerceRenewalItem]? = nil, period: AdvancedCommercePeriod? = nil, requestReferenceId: String? = nil, taxCode: String? = nil) {
        self.init(consistencyToken: consistencyToken, descriptors: descriptors, items: items, rawPeriod: period?.rawValue, requestReferenceId: requestReferenceId, taxCode: taxCode)
    }

    public init(consistencyToken: String? = nil, descriptors: AdvancedCommerceDescriptors? = nil, items: [AdvancedCommerceRenewalItem]? = nil, rawPeriod: String? = nil, requestReferenceId: String? = nil, taxCode: String? = nil) {
        self.consistencyToken = consistencyToken
        self.descriptors = descriptors
        self.items = items
        self.rawPeriod = rawPeriod
        self.requestReferenceId = requestReferenceId
        self.taxCode = taxCode
    }

    ///[advancedCommerceConsistencyToken](https://developer.apple.com/documentation/appstoreserverapi/advancedcommerceconsistencytoken)
    public var consistencyToken: String?

    ///[advancedCommerceDescriptors](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercedescriptors)
    public var descriptors: AdvancedCommerceDescriptors?

    ///[advancedCommerceRenewalItem](https://developer.apple.com/documentation/appstoreserverapi/advancedcommercerenewalitem)
    public var items: [AdvancedCommerceRenewalItem]?

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

    public enum CodingKeys: CodingKey {
        case consistencyToken
        case descriptors
        case items
        case period
        case requestReferenceId
        case taxCode
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.consistencyToken = try container.decodeIfPresent(String.self, forKey: .consistencyToken)
        self.descriptors = try container.decodeIfPresent(AdvancedCommerceDescriptors.self, forKey: .descriptors)
        self.items = try container.decodeIfPresent([AdvancedCommerceRenewalItem].self, forKey: .items)
        self.rawPeriod = try container.decodeIfPresent(String.self, forKey: .period)
        self.requestReferenceId = try container.decodeIfPresent(String.self, forKey: .requestReferenceId)
        self.taxCode = try container.decodeIfPresent(String.self, forKey: .taxCode)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.consistencyToken, forKey: .consistencyToken)
        try container.encodeIfPresent(self.descriptors, forKey: .descriptors)
        try container.encodeIfPresent(self.items, forKey: .items)
        try container.encodeIfPresent(self.rawPeriod, forKey: .period)
        try container.encodeIfPresent(self.requestReferenceId, forKey: .requestReferenceId)
        try container.encodeIfPresent(self.taxCode, forKey: .taxCode)
    }
}
