// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The metadata to change for an item, specifically its SKU, description, and display name.
///
///[SubscriptionChangeMetadataItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadataitem)
public struct AdvancedCommerceSubscriptionChangeMetadataItem: Decodable, Encodable, Hashable, Sendable {

    public init(effective: AdvancedCommerceEffective, currentSku: String, description: String? = nil, displayName: String? = nil, sku: String? = nil) throws {
        self.rawEffective = effective.rawValue
        self.currentSku = try HelperValidationUtils.validateSku(currentSku)
        self.description = try description.map(HelperValidationUtils.validateDescription)
        self.displayName = try displayName.map(HelperValidationUtils.validateDisplayName)
        self.sku = try sku.map(HelperValidationUtils.validateSku)
    }

    public init(rawEffective: String, currentSku: String, description: String? = nil, displayName: String? = nil, sku: String? = nil) throws {
        self.rawEffective = rawEffective
        self.currentSku = try HelperValidationUtils.validateSku(currentSku)
        self.description = try description.map(HelperValidationUtils.validateDescription)
        self.displayName = try displayName.map(HelperValidationUtils.validateDisplayName)
        self.sku = try sku.map(HelperValidationUtils.validateSku)
    }

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

    ///The new SKU of the item.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String?

    public enum CodingKeys: String, CodingKey {
        case currentSku = "currentSKU"
        case description = "description"
        case displayName = "displayName"
        case effective = "effective"
        case sku = "SKU"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentSku = try container.decode(String.self, forKey: .currentSku)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.rawEffective = try container.decode(String.self, forKey: .effective)
        self.sku = try container.decodeIfPresent(String.self, forKey: .sku)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.currentSku, forKey: .currentSku)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encode(self.rawEffective, forKey: .effective)
        try container.encodeIfPresent(self.sku, forKey: .sku)
    }
}
