// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The promotional offer signature you generate using an earlier signature version.
///
///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
public struct PromotionalOfferSignatureV1: Decodable, Encodable, Hashable, Sendable {

    public init(encodedSignature: String, productId: String, nonce: UUID, timestamp: Int64, keyId: String, offerIdentifier: String, appAccountToken: UUID? = nil) {
        self.encodedSignature = encodedSignature
        self.productId = productId
        self.nonce = nonce
        self.timestamp = timestamp
        self.keyId = keyId
        self.offerIdentifier = offerIdentifier
        self.appAccountToken = appAccountToken
    }

    ///The Base64-encoded cryptographic signature you generate using the offer parameters.
    public var encodedSignature: String

    ///The subscription's product identifier.
    ///
    ///[productId](https://developer.apple.com/documentation/retentionmessaging/productid)
    public var productId: String

    ///A one-time-use UUID antireplay value you generate.
    public var nonce: UUID

    ///The UNIX time, in milliseconds, when you generate the signature.
    public var timestamp: Int64

    ///A string that identifies the private key you use to generate the signature.
    public var keyId: String

    ///The subscription offer identifier that you set up in App Store Connect.
    public var offerIdentifier: String

    ///A UUID that you provide to associate with the transaction if the customer accepts the promotional offer.
    public var appAccountToken: UUID?

    enum CodingKeys: String, CodingKey {
        case encodedSignature
        case productId
        case nonce
        case timestamp
        case keyId
        case offerIdentifier
        case appAccountToken
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encodedSignature, forKey: .encodedSignature)
        try container.encode(productId, forKey: .productId)
        try container.encode(nonce.uuidString.lowercased(), forKey: .nonce)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(keyId, forKey: .keyId)
        try container.encode(offerIdentifier, forKey: .offerIdentifier)
        if let appAccountToken = appAccountToken {
            try container.encode(appAccountToken.uuidString.lowercased(), forKey: .appAccountToken)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        encodedSignature = try container.decode(String.self, forKey: .encodedSignature)
        productId = try container.decode(String.self, forKey: .productId)
        let nonceString = try container.decode(String.self, forKey: .nonce)
        guard let nonceUUID = UUID(uuidString: nonceString) else {
            throw DecodingError.dataCorruptedError(forKey: .nonce, in: container, debugDescription: "Invalid UUID string for nonce")
        }
        nonce = nonceUUID
        timestamp = try container.decode(Int64.self, forKey: .timestamp)
        keyId = try container.decode(String.self, forKey: .keyId)
        offerIdentifier = try container.decode(String.self, forKey: .offerIdentifier)
        if let appAccountTokenString = try container.decodeIfPresent(String.self, forKey: .appAccountToken) {
            guard let appAccountTokenUUID = UUID(uuidString: appAccountTokenString) else {
                throw DecodingError.dataCorruptedError(forKey: .appAccountToken, in: container, debugDescription: "Invalid UUID string for appAccountToken")
            }
            appAccountToken = appAccountTokenUUID
        } else {
            appAccountToken = nil
        }
    }
}
