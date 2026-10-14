// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The metadata to change for an item, specifically its SKU, description, and display name.
///
///[SubscriptionChangeMetadataItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadataitem)
public struct AdvancedCommerceSubscriptionChangeMetadataItem: Decodable, Encodable, Hashable, Sendable {

    public init(currentSku: String, effective: AdvancedCommerceEffective, sku: String? = nil, description: String? = nil, displayName: String? = nil) throws {
        try self.init(currentSku: currentSku, rawEffective: effective.rawValue, sku: sku, description: description, displayName: displayName)
    }

    public init(currentSku: String, rawEffective: String, sku: String? = nil, description: String? = nil, displayName: String? = nil) throws {
        self.currentSku = try HelperValidationUtils.validateSku(currentSku, fieldName: "currentSKU")
        self.rawEffective = rawEffective
        self.sku = try sku.map(HelperValidationUtils.validateSku)
        self.description = try description.map(HelperValidationUtils.validateDescription)
        self.displayName = try displayName.map(HelperValidationUtils.validateDisplayName)
    }

    ///The new SKU of the item.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String?

    ///The original SKU of the item.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var currentSku: String

    ///The new description for the item.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String?

    ///The new display name for the item.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String?

    ///The string that determines when the metadata change goes into effect.
    ///
    ///[effective](https://developer.apple.com/documentation/advancedcommerceapi/effective)
    public var effective: AdvancedCommerceEffective? {
        get {
            return AdvancedCommerceEffective(rawValue: rawEffective)
        }
        set {
            self.rawEffective = newValue.map { $0.rawValue } ?? rawEffective
        }
    }

    ///See ``effective``
    public var rawEffective: String

    public enum CodingKeys: String, CodingKey {
        case sku = "SKU"
        case currentSku = "currentSKU"
        case description = "description"
        case displayName = "displayName"
        case effective = "effective"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sku = try container.decodeIfPresent(String.self, forKey: .sku)
        self.currentSku = try container.decode(String.self, forKey: .currentSku)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.rawEffective = try container.decode(String.self, forKey: .effective)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.sku.map(HelperValidationUtils.validateSku), forKey: .sku)
        try container.encode(HelperValidationUtils.validateSku(self.currentSku, fieldName: "currentSKU"), forKey: .currentSku)
        try container.encodeIfPresent(self.description.map(HelperValidationUtils.validateDescription), forKey: .description)
        try container.encodeIfPresent(self.displayName.map(HelperValidationUtils.validateDisplayName), forKey: .displayName)
        try container.encode(self.rawEffective, forKey: .effective)
    }
}
