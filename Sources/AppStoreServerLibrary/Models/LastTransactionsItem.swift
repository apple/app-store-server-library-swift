// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The most recent App Store-signed transaction information and App Store-signed renewal information for an auto-renewable subscription.
///
///[lastTransactionsItem](https://developer.apple.com/documentation/appstoreserverapi/lasttransactionsitem)
public struct LastTransactionsItem: Decodable, Encodable, Hashable {
    
    public init(status: Status? = nil, originalTransactionId: String? = nil, signedTransactionInfo: String? = nil, signedRenewalInfo: String? = nil) {
        self.status = status
        self.originalTransactionId = originalTransactionId
        self.signedTransactionInfo = signedTransactionInfo
        self.signedRenewalInfo = signedRenewalInfo
    }
    
    public init(rawStatus: Int32? = nil, originalTransactionId: String? = nil, signedTransactionInfo: String? = nil, signedRenewalInfo: String? = nil) {
        self.rawStatus = rawStatus
        self.originalTransactionId = originalTransactionId
        self.signedTransactionInfo = signedTransactionInfo
        self.signedRenewalInfo = signedRenewalInfo
    }

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

    ///The original transaction identifier of a purchase.
    ///
    ///[originalTransactionId](https://developer.apple.com/documentation/appstoreserverapi/originaltransactionid)
    public var originalTransactionId: String?

    ///Transaction information signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactionInfo: String?

    ///Subscription renewal information, signed by the App Store, in JSON Web Signature (JWS) format.
    ///
    ///[JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    public var signedRenewalInfo: String?
    
    public enum CodingKeys: CodingKey {
        case status
        case originalTransactionId
        case signedTransactionInfo
        case signedRenewalInfo
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawStatus = try container.decodeIfPresent(Int32.self, forKey: .status)
        self.originalTransactionId = try container.decodeIfPresent(String.self, forKey: .originalTransactionId)
        self.signedTransactionInfo = try container.decodeIfPresent(String.self, forKey: .signedTransactionInfo)
        self.signedRenewalInfo = try container.decodeIfPresent(String.self, forKey: .signedRenewalInfo)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawStatus, forKey: .status)
        try container.encodeIfPresent(self.originalTransactionId, forKey: .originalTransactionId)
        try container.encodeIfPresent(self.signedTransactionInfo, forKey: .signedTransactionInfo)
        try container.encodeIfPresent(self.signedRenewalInfo, forKey: .signedRenewalInfo)
    }
}
