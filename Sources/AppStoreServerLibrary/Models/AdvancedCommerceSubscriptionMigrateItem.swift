// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The SKU, description, and display name to use for a migrated subscription item.
///
///[SubscriptionMigrateItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigrateitem)
public struct AdvancedCommerceSubscriptionMigrateItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, description: String, displayName: String) throws {
        self.sku = try HelperValidationUtils.validateSku(sku)
        self.description = try HelperValidationUtils.validateDescription(description)
        self.displayName = try HelperValidationUtils.validateDisplayName(displayName)
    }

    ///The description of the SKU.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///The display name of the SKU.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///The SKU to use for the migrated item.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case description = "description"
        case displayName = "displayName"
        case sku = "SKU"
    }
}
