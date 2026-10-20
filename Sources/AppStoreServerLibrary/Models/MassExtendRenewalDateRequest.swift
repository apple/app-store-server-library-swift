// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The request body that contains subscription-renewal-extension data to apply for all eligible active subscribers.
///
///[MassExtendRenewalDateRequest](https://developer.apple.com/documentation/appstoreserverapi/massextendrenewaldaterequest)
public struct MassExtendRenewalDateRequest: Decodable, Encodable, Hashable, Sendable {

    private static let maximumRequestIdentifierLength = 128
    private static let minimumExtendByDays: Int32 = 1
    private static let maximumExtendByDays: Int32 = 90
    private static let maximumStorefrontCountryCodeLength = 3

    public enum ValidationError: Error {
        case requestIdentifierTooLong
        case extendByDaysOutOfRange
        case storefrontCountryCodeTooLong
    }

    public init(requestIdentifier: String, extendByDays: Int32, extendReasonCode: ExtendReasonCode, productId: String, storefrontCountryCodes: [String]? = nil) throws {
        try self.init(requestIdentifier: requestIdentifier, extendByDays: extendByDays, rawExtendReasonCode: extendReasonCode.rawValue, productId: productId, storefrontCountryCodes: storefrontCountryCodes)
    }

    public init(requestIdentifier: String, extendByDays: Int32, rawExtendReasonCode: Int32, productId: String, storefrontCountryCodes: [String]? = nil) throws {
        guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
            throw ValidationError.requestIdentifierTooLong
        }
        guard extendByDays >= Self.minimumExtendByDays && extendByDays <= Self.maximumExtendByDays else {
            throw ValidationError.extendByDaysOutOfRange
        }
        if let storefrontCountryCodes = storefrontCountryCodes {
            for storefrontCountryCode in storefrontCountryCodes {
                guard storefrontCountryCode.unicodeScalars.count <= Self.maximumStorefrontCountryCodeLength else {
                    throw ValidationError.storefrontCountryCodeTooLong
                }
            }
        }
        self.requestIdentifier = requestIdentifier
        self.extendByDays = extendByDays
        self.rawExtendReasonCode = rawExtendReasonCode
        self.productId = productId
        self.storefrontCountryCodes = storefrontCountryCodes
    }

    ///A string that contains a one-time UUID value you provide to identify this subscription-renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String

    ///The number of days to extend the subscription renewal date.
    ///
    ///[extendByDays](https://developer.apple.com/documentation/appstoreserverapi/extendbydays)
    public var extendByDays: Int32

    ///The reason code for the subscription-renewal-date extension.
    ///
    ///[extendReasonCode](https://developer.apple.com/documentation/appstoreserverapi/extendreasoncode)
    public var extendReasonCode: ExtendReasonCode? {
        get {
            return ExtendReasonCode(rawValue: rawExtendReasonCode)
        }
        set {
            self.rawExtendReasonCode = newValue.map { $0.rawValue } ?? rawExtendReasonCode
        }
    }

    ///See ``extendReasonCode``
    public var rawExtendReasonCode: Int32

    ///The product identifier of the auto-renewable subscription that you’re requesting the renewal-date extension for.
    ///
    ///[productId](https://developer.apple.com/documentation/appstoreserverapi/productid)
    public var productId: String

    ///A list of storefront country codes you provide to limit the storefronts that are eligible to receive the subscription-renewal-date extension.
    ///
    ///[storefrontCountryCodes](https://developer.apple.com/documentation/appstoreserverapi/storefrontcountrycodes)
    public var storefrontCountryCodes: [String]?

    public enum CodingKeys: CodingKey {
        case requestIdentifier
        case extendByDays
        case extendReasonCode
        case productId
        case storefrontCountryCodes
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestIdentifier = try container.decode(String.self, forKey: .requestIdentifier)
        self.extendByDays = try container.decode(Int32.self, forKey: .extendByDays)
        self.rawExtendReasonCode = try container.decode(Int32.self, forKey: .extendReasonCode)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.storefrontCountryCodes = try container.decodeIfPresent([String].self, forKey: .storefrontCountryCodes)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestIdentifier, forKey: .requestIdentifier)
        try container.encode(self.extendByDays, forKey: .extendByDays)
        try container.encode(self.rawExtendReasonCode, forKey: .extendReasonCode)
        try container.encode(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.storefrontCountryCodes, forKey: .storefrontCountryCodes)
    }
}
