// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import Crypto

public struct PromotionalOfferSignatureCreator {
    private let ecPrivateKey: P256.Signing.PrivateKey
    private let keyId: String
    private let bundleId: String
    
    public init(privateKey: String, keyId: String, bundleId: String) throws {
        self.ecPrivateKey = try P256.Signing.PrivateKey(pemRepresentation: privateKey)
        self.keyId = keyId
        self.bundleId = bundleId
    }
    ///Create a promotional offer signature
    ///
    ///[Generating a signature for promotional offers](https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/subscriptions_and_offers/generating_a_signature_for_promotional_offers)
    ///
    /// - Parameter productIdentifier: The subscription product identifier
    /// - Parameter subscriptionOfferID: The subscription discount identifier
    /// - Parameter applicationUsername: An optional string value that you define; may be an empty string
    /// - Parameter nonce: A one-time UUID value that your server generates. Generate a new nonce for every signature.
    /// - Parameter timestamp: A timestamp your server generates in UNIX time format, in milliseconds. The timestamp keeps the offer active for 24 hours.
    /// - Returns: The Base64 encoded signature
    /// - Throws: If there was an error creating the signature
    public func createSignature(productIdentifier: String, subscriptionOfferID: String, applicationUsername: String, nonce: UUID, timestamp: Int64) throws -> String {
        let payload = "\(self.bundleId)\u{2063}\(self.keyId)\u{2063}\(productIdentifier)\u{2063}\(subscriptionOfferID)\u{2063}\(applicationUsername.lowercased())\u{2063}\(nonce.uuidString.lowercased())\u{2063}\(timestamp)"
        let dataBytes = Foundation.Data(payload.utf8)
        let signature = try ecPrivateKey.signature(for: SHA256.hash(data: dataBytes))
        return signature.derRepresentation.base64EncodedString()
    }
}
