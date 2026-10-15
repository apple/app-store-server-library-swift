// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The subscription metadata to change, specifically the description and display name.
///
///[SubscriptionChangeMetadataDescriptors](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionchangemetadatadescriptors)
public struct AdvancedCommerceSubscriptionChangeMetadataDescriptors: Decodable, Encodable, Hashable, Sendable {

    public init(effective: AdvancedCommerceEffective, description: String? = nil, displayName: String? = nil) throws {
        try self.init(rawEffective: effective.rawValue, description: description, displayName: displayName)
    }

    public init(rawEffective: String, description: String? = nil, displayName: String? = nil) throws {
        self.rawEffective = rawEffective
        self.description = try description.map(HelperValidationUtils.validateDescription)
        self.displayName = try displayName.map(HelperValidationUtils.validateDisplayName)
    }

    ///The new description for the subscription.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String?

    ///The new display name for the subscription.
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

    public enum CodingKeys: CodingKey {
        case description
        case displayName
        case effective
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.rawEffective = try container.decode(String.self, forKey: .effective)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.description.map(HelperValidationUtils.validateDescription), forKey: .description)
        try container.encodeIfPresent(self.displayName.map(HelperValidationUtils.validateDisplayName), forKey: .displayName)
        try container.encode(self.rawEffective, forKey: .effective)
    }
}
