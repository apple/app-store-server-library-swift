// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The display name and description of a subscription product.
///
///[Descriptors](https://developer.apple.com/documentation/advancedcommerceapi/descriptors)
public struct AdvancedCommerceDescriptors: Decodable, Encodable, Hashable, Sendable {

    public init(description: String, displayName: String) throws {
        self.description = try AdvancedCommerceValidationUtils.validateDescription(description)
        self.displayName = try AdvancedCommerceValidationUtils.validateDisplayName(displayName)
    }

    ///A string you provide that describes a SKU.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///A string with a product name that you can localize and is suitable for display to customers.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String
}
