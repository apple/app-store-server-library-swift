// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The description and display name of the subscription to migrate to that you manage.
///
///[SubscriptionMigrateDescriptors](https://developer.apple.com/documentation/advancedcommerceapi/subscriptionmigratedescriptors)
public struct AdvancedCommerceSubscriptionMigrateDescriptors: Decodable, Encodable, Hashable, Sendable {

    public init(description: String, displayName: String) throws {
        self.description = try HelperValidationUtils.validateDescription(description)
        self.displayName = try HelperValidationUtils.validateDisplayName(displayName)
    }

    ///The description of the subscription to migrate to.
    ///
    ///[description](https://developer.apple.com/documentation/advancedcommerceapi/description)
    public var description: String?

    ///The display name of the subscription to migrate to.
    ///
    ///[displayName](https://developer.apple.com/documentation/advancedcommerceapi/displayname)
    public var displayName: String?
}
