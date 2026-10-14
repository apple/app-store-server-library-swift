// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The most recent App Store-signed transaction information and App Store-signed renewal information for an auto-renewable subscription.
///
///[lastTransactionsItem](https://developer.apple.com/documentation/appstoreserverapi/lasttransactionsitem)
public struct LastTransactionsItem: Decodable, Encodable, Hashable, Sendable {

    public init(originalTransactionId: String? = nil, status: Status? = nil, signedRenewalInfo: String? = nil, signedTransactionInfo: String? = nil) {
        self.init(originalTransactionId: originalTransactionId, rawStatus: status?.rawValue, signedRenewalInfo: signedRenewalInfo, signedTransactionInfo: signedTransactionInfo)
    }

    @_disfavoredOverload
    public init(originalTransactionId: String? = nil, rawStatus: Int32? = nil, signedRenewalInfo: String? = nil, signedTransactionInfo: String? = nil) {
        self.originalTransactionId = originalTransactionId
        self.rawStatus = rawStatus
        self.signedRenewalInfo = signedRenewalInfo
        self.signedTransactionInfo = signedTransactionInfo
    }

    ///The original transaction identifier of the auto-renewable subscription.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?

    ///The status of the auto-renewable subscription.
    ///
    ///[status](https://developer.apple.com/documentation/appstoreserverapi/status)
    public var status: Status? {
        get {
            return rawStatus.flatMap { Status(rawValue: $0) }
        }
        set {
            self.rawStatus = newValue.map { $0.rawValue }
        }
    }

    ///See ``status``
    public var rawStatus: Int32?

    ///The subscription renewal information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    public var signedRenewalInfo: String?

    ///The transaction information signed by the App Store, in JWS format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String?

    public enum CodingKeys: CodingKey {
        case originalTransactionId
        case status
        case signedRenewalInfo
        case signedTransactionInfo
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.originalTransactionId = try container.decodeIfPresent(String.self, forKey: .originalTransactionId)
        self.rawStatus = try container.decodeIfPresent(Int32.self, forKey: .status)
        self.signedRenewalInfo = try container.decodeIfPresent(String.self, forKey: .signedRenewalInfo)
        self.signedTransactionInfo = try container.decodeIfPresent(String.self, forKey: .signedTransactionInfo)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encodeIfPresent(self.rawStatus, forKey: .status)
        try container.encodeIfPresent(self.signedRenewalInfo, forKey: .signedRenewalInfo)
        try container.encodeIfPresent(self.signedTransactionInfo, forKey: .signedTransactionInfo)
    }
}
