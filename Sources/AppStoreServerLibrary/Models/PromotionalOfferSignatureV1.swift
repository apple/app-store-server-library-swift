// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The promotional-offer signature you generate using an earlier signature version.
///
///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
public struct PromotionalOfferSignatureV1: Decodable, Encodable, Hashable, Sendable {

    public init(encodedSignature: String, productId: String, nonce: UUID, timestamp: Date, keyId: String, offerIdentifier: String, appAccountToken: UUID? = nil) {
        self.encodedSignature = encodedSignature
        self.productId = productId
        self.nonce = nonce
        self.timestamp = timestamp
        self.keyId = keyId
        self.offerIdentifier = offerIdentifier
        self.appAccountToken = appAccountToken
    }

    ///The Base64-encoded cryptographic signature you generate using the offer parameters.
    ///
    ///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
    public var encodedSignature: String

    ///The subscription’s product identifier.
    ///
    ///[productId](https://developer.apple.com/documentation/retentionmessaging/productid)
    public var productId: String

    ///A one-time-use UUID antireplay value you generate.
    ///
    ///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
    public var nonce: UUID

    ///The UNIX time, in milliseconds, when you generate the signature.
    ///
    ///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
    public var timestamp: Date

    ///A string that identifies the private key you use to generate the signature.
    ///
    ///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
    public var keyId: String

    ///The subscription offer identifier that you set up in App Store Connect.
    ///
    ///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
    public var offerIdentifier: String

    ///A UUID that you provide to associate with the transaction if the customer accepts the promotional offer.
    ///
    ///[promotionalOfferSignatureV1](https://developer.apple.com/documentation/retentionmessaging/promotionaloffersignaturev1)
    public var appAccountToken: UUID?

    public enum CodingKeys: CodingKey {
        case encodedSignature
        case productId
        case nonce
        case timestamp
        case keyId
        case offerIdentifier
        case appAccountToken
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.encodedSignature = try container.decode(String.self, forKey: .encodedSignature)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.nonce = try container.decode(UUID.self, forKey: .nonce)
        self.timestamp = try Date(timeIntervalSince1970: container.decode(Double.self, forKey: .timestamp) / 1000.0)
        self.keyId = try container.decode(String.self, forKey: .keyId)
        self.offerIdentifier = try container.decode(String.self, forKey: .offerIdentifier)
        self.appAccountToken = try container.decodeIfPresent(UUID.self, forKey: .appAccountToken)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.encodedSignature, forKey: .encodedSignature)
        try container.encode(self.productId, forKey: .productId)
        try container.encode(self.nonce.uuidString.lowercased(), forKey: .nonce)
        try container.encode((self.timestamp.timeIntervalSince1970 * 1000.0).rounded(.towardZero), forKey: .timestamp)
        try container.encode(self.keyId, forKey: .keyId)
        try container.encode(self.offerIdentifier, forKey: .offerIdentifier)
        try container.encodeIfPresent(self.appAccountToken?.uuidString.lowercased(), forKey: .appAccountToken)
    }
}
