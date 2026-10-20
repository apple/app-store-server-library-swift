// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The request body that contains subscription-renewal-extension data for an individual subscription.
///
///[ExtendRenewalDateRequest](https://developer.apple.com/documentation/appstoreserverapi/extendrenewaldaterequest)
public struct ExtendRenewalDateRequest: Decodable, Encodable, Hashable, Sendable {

    private static let minimumExtendByDays: Int32 = 1
    private static let maximumExtendByDays: Int32 = 90
    private static let maximumRequestIdentifierLength = 128

    public enum ValidationError: Error {
        case extendByDaysOutOfRange
        case requestIdentifierTooLong
    }

    public init(extendByDays: Int32, extendReasonCode: ExtendReasonCode, requestIdentifier: String) throws {
        try self.init(extendByDays: extendByDays, rawExtendReasonCode: extendReasonCode.rawValue, requestIdentifier: requestIdentifier)
    }

    public init(extendByDays: Int32, rawExtendReasonCode: Int32, requestIdentifier: String) throws {
        guard extendByDays >= Self.minimumExtendByDays && extendByDays <= Self.maximumExtendByDays else {
            throw ValidationError.extendByDaysOutOfRange
        }
        guard requestIdentifier.unicodeScalars.count <= Self.maximumRequestIdentifierLength else {
            throw ValidationError.requestIdentifierTooLong
        }
        self.extendByDays = extendByDays
        self.rawExtendReasonCode = rawExtendReasonCode
        self.requestIdentifier = requestIdentifier
    }

    ///The number of days to extend the subscription renewal date.
    ///
    ///[extendByDays](https://developer.apple.com/documentation/appstoreserverapi/extendbydays)
    public var extendByDays: Int32

    ///The reason code for the subscription date extension.
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

    ///A string that contains a value you provide to uniquely identify this renewal-date extension request.
    ///
    ///[requestIdentifier](https://developer.apple.com/documentation/appstoreserverapi/requestidentifier)
    public var requestIdentifier: String

    public enum CodingKeys: CodingKey {
        case extendByDays
        case extendReasonCode
        case requestIdentifier
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.extendByDays = try container.decode(Int32.self, forKey: .extendByDays)
        self.rawExtendReasonCode = try container.decode(Int32.self, forKey: .extendReasonCode)
        self.requestIdentifier = try container.decode(String.self, forKey: .requestIdentifier)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.extendByDays, forKey: .extendByDays)
        try container.encode(self.rawExtendReasonCode, forKey: .extendReasonCode)
        try container.encode(self.requestIdentifier, forKey: .requestIdentifier)
    }
}
