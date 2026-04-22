// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The item information that replaces a migrated subscription item when the subscription renews.
///
///[SubscriptionMigrateRenewalItem](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigraterenewalitem)
public struct AdvancedCommerceSubscriptionMigrateRenewalItem: Decodable, Encodable, Hashable, Sendable {

    public init(sku: String, description: String, displayName: String) throws {
        self.sku = try AdvancedCommerceValidationUtils.validateSku(sku)
        self.description = try AdvancedCommerceValidationUtils.validateDescription(description)
        self.displayName = try AdvancedCommerceValidationUtils.validateDisplayName(displayName)
    }

    ///The description of the renewing SKU.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String

    ///The display name of the renewing SKU.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String

    ///The SKU that the subscription item renews to at the next renewal period.
    ///
    ///[SKU](https://developer.apple.com/documentation/advancedcommerceapi/sku)
    public var sku: String

    public enum CodingKeys: String, CodingKey {
        case description = "description"
        case displayName = "displayName"
        case sku = "SKU"
    }
}
