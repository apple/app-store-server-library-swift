// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///A customer’s role for a single product within a group.
///
///[RoleEntry](https://developer.apple.com/documentation/appstoreserverapi/roleentry)
public struct RoleEntry: Decodable, Encodable, Hashable, Sendable {

    public init(productId: String? = nil, role: Role? = nil) {
        self.init(productId: productId, rawRole: role?.rawValue)
    }

    @_disfavoredOverload
    public init(productId: String? = nil, rawRole: String? = nil) {
        self.productId = productId
        self.rawRole = rawRole
    }

    ///The product identifier of the in-app purchase that the role applies to.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String?

    ///The customer’s role for the product.
    ///
    ///[role](https://developer.apple.com/documentation/appstoreserverapi/role)
    public var role: Role? {
        get {
            return rawRole.flatMap { Role(rawValue: $0) }
        }
        set {
            self.rawRole = newValue.map { $0.rawValue }
        }
    }

    ///See ``role``
    public var rawRole: String?

    public enum CodingKeys: CodingKey {
        case productId
        case role
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.rawRole = try container.decodeIfPresent(String.self, forKey: .role)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.rawRole, forKey: .role)
    }
}
