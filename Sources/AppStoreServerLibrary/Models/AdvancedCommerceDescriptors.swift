// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The display name and description of a subscription product.
///
///[Descriptors](https://developer.apple.com/documentation/advancedcommerceapi/descriptors)
public struct AdvancedCommerceDescriptors: Decodable, Encodable, Hashable, Sendable {

    public init(description: String, displayName: String) throws {
        self.description = try HelperValidationUtils.validateDescription(description)
        self.displayName = try HelperValidationUtils.validateDisplayName(displayName)
    }

    ///A string that contains a description of the product.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///A string that contains the name of the product, suitable for display to customers.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    public enum CodingKeys: CodingKey {
        case description
        case displayName
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try HelperValidationUtils.validateDescription(container.decode(String.self, forKey: .description))
        self.displayName = try HelperValidationUtils.validateDisplayName(container.decode(String.self, forKey: .displayName))
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(HelperValidationUtils.validateDescription(self.description), forKey: .description)
        try container.encode(HelperValidationUtils.validateDisplayName(self.displayName), forKey: .displayName)
    }
}
