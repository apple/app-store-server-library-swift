// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation
import JWTKit
import Crypto

fileprivate protocol BasePayload: Codable {
    var nonce: String { get }
    var iss: IssuerClaim { get }
    var bid: String { get }
    var aud: AudienceClaim { get }
    var iat: IssuedAtClaim { get }
}

fileprivate class BasePayloadObject: BasePayload {
    let nonce: String
    let iss: IssuerClaim
    let bid: String
    let aud: AudienceClaim
    let iat: IssuedAtClaim
    init(nonce: String, iss: IssuerClaim, bid: String, aud: AudienceClaim, iat: IssuedAtClaim) {
        self.nonce = nonce
        self.iss = iss
        self.bid = bid
        self.aud = aud
        self.iat = iat
    }
}

fileprivate final class PromotionalOfferV2Payload: BasePayload, JWTPayload {
    
    let nonce: String
    let iss: IssuerClaim
    let bid: String
    let aud: AudienceClaim
    let iat: IssuedAtClaim
    let productId: String
    let offerIdentifier: String
    let transactionId: String?
    
    init(basePayload: BasePayload, productId: String, offerIdentifier: String, transactionId: String? = nil) {
        self.productId = productId
        self.offerIdentifier = offerIdentifier
        self.transactionId = transactionId
        self.nonce = basePayload.nonce
        self.iss = basePayload.iss
        self.bid = basePayload.bid
        self.aud = basePayload.aud
        self.iat = basePayload.iat
    }

    required init(from decoder: any Decoder) throws {
        fatalError("Do not attempt to decode a JWS locally")
    }
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        fatalError("Do not attempt to locally verify a JWS")
    }
}

fileprivate final class IntroductoryOfferEligibilityPayload: BasePayload, JWTPayload {
    let nonce: String
    let iss: IssuerClaim
    let bid: String
    let aud: AudienceClaim
    let iat: IssuedAtClaim
    let productId: String
    let allowIntroductoryOffer: Bool
    let transactionId: String
    
    init(basePayload: BasePayload, productId: String, allowIntroductoryOffer: Bool, transactionId: String) {
        self.productId = productId
        self.allowIntroductoryOffer = allowIntroductoryOffer
        self.transactionId = transactionId
        self.nonce = basePayload.nonce
        self.iss = basePayload.iss
        self.bid = basePayload.bid
        self.aud = basePayload.aud
        self.iat = basePayload.iat
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("Do not attempt to decode a JWS locally")
    }
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        fatalError("Do not attempt to locally verify a JWS")
    }
}

fileprivate final class AdvancedCommerceInAppPayload: BasePayload, JWTPayload {
    let nonce: String
    let iss: IssuerClaim
    let bid: String
    let aud: AudienceClaim
    let iat: IssuedAtClaim
    let request: String
    
    init(basePayload: BasePayload, request: String) {
        self.request = request
        self.nonce = basePayload.nonce
        self.iss = basePayload.iss
        self.bid = basePayload.bid
        self.aud = basePayload.aud
        self.iat = basePayload.iat
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("Do not attempt to decode a JWS locally")
    }
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        fatalError("Do not attempt to locally verify a JWS")
    }
}

public class JWSSignatureCreator {

    private let audience: String
    private let signingKey: P256.Signing.PrivateKey
    private let keyId: String
    private let issuerId: String
    private let bundleId: String

    init(audience: String, signingKey: String, keyId: String, issuerId: String, bundleId: String) throws {
        self.audience = audience
        self.signingKey = try P256.Signing.PrivateKey(pemRepresentation: signingKey)
        self.keyId = keyId
        self.issuerId = issuerId
        self.bundleId = bundleId
    }
    
    fileprivate func getBasePayload() -> BasePayload {
        return BasePayloadObject(
            nonce: UUID().uuidString,
            iss: .init(value: self.issuerId),
            bid: self.bundleId,
            aud: .init(value: self.audience),
            iat: .init(value: Date())
        )
    }

    fileprivate func createSignature(payload: JWTPayload) async throws -> String {
        let keys = JWTKeyCollection()
        try await keys.add(ecdsa: ECDSA.PrivateKey<P256>(backing: signingKey))
        return try await keys.sign(payload, header: ["typ": "JWT", "kid": .string(self.keyId)])
    }
}

public class PromotionalOfferV2SignatureCreator: JWSSignatureCreator {
    ///Create a PromotionalOfferV2SignatureCreator
    ///
    ///- Parameter signingKey: Your private key downloaded from App Store Connect
    ///- Parameter issuerId: Your issuer ID from the Keys page in App Store Connect
    ///- Parameter bundleId: Your app’s bundle ID
    ///- Parameter environment: The environment to target
    public init(signingKey: String, keyId: String, issuerId: String, bundleId: String) throws {
        try super.init(audience: "promotional-offer", signingKey: signingKey, keyId: keyId, issuerId: issuerId, bundleId: bundleId)
    }
    
    ///Create a promotional offer V2 signature.
    ///
    ///- Parameter productId: The unique identifier of the product
    ///- Parameter offerIdentifier: The promotional offer identifier that you set up in App Store Connect
    ///- Parameter transactionId: The unique identifier of any transaction that belongs to the customer. You can use the customer's appTransactionId, even for customers who haven't made any In-App Purchases in your app. This field is optional, but recommended.
    ///- Returns: The signed JWS.
    ///[Generating JWS to sign App Store requests](https://developer.apple.com/documentation/storekit/generating-jws-to-sign-app-store-requests)
    public func createSignature(productId: String, offerIdentifier: String, transactionId: String? = nil) async throws -> String {
        let baseClaims = super.getBasePayload()
        let claims = PromotionalOfferV2Payload(basePayload: baseClaims, productId: productId, offerIdentifier: offerIdentifier, transactionId: transactionId)
        return try await super.createSignature(payload: claims)
    }
}

public class IntroductoryOfferEligibilitySignatureCreator: JWSSignatureCreator {
    ///Create a IntroductoryOfferEligibilitySignatureCreator
    ///
    ///- Parameter signingKey: Your private key downloaded from App Store Connect
    ///- Parameter issuerId: Your issuer ID from the Keys page in App Store Connect
    ///- Parameter bundleId: Your app’s bundle ID
    ///- Parameter environment: The environment to target
    public init(signingKey: String, keyId: String, issuerId: String, bundleId: String) throws {
        try super.init(audience: "introductory-offer-eligibility", signingKey: signingKey, keyId: keyId, issuerId: issuerId, bundleId: bundleId)
    }
    
    ///Create an introductory offer eligibility signature.
    ///
    ///- Parameter productId: The unique identifier of the product
    ///- Parameter allowIntroductoryOffer: A boolean value that determines whether the customer is eligible for an introductory offer
    ///- Parameter transactionId: The unique identifier of any transaction that belongs to the customer. You can use the customer's appTransactionId, even for customers who haven't made any In-App Purchases in your app.
    ///- Returns: The signed JWS.
    ///[Generating JWS to sign App Store requests](https://developer.apple.com/documentation/storekit/generating-jws-to-sign-app-store-requests)
    public func createSignature(productId: String, allowIntroductoryOffer: Bool, transactionId: String) async throws -> String {
        let baseClaims = super.getBasePayload()
        let claims = IntroductoryOfferEligibilityPayload(basePayload: baseClaims, productId: productId, allowIntroductoryOffer: allowIntroductoryOffer, transactionId: transactionId)
        return try await super.createSignature(payload: claims)
    }
}

public protocol AdvancedCommerceInAppRequest: Encodable {
    
}

public class AdvancedCommerceInAppSignatureCreator: JWSSignatureCreator {
    ///Create a AdvancedCommerceInAppSignatureCreator
    ///
    ///- Parameter signingKey: Your private key downloaded from App Store Connect
    ///- Parameter issuerId: Your issuer ID from the Keys page in App Store Connect
    ///- Parameter bundleId: Your app’s bundle ID
    ///- Parameter environment: The environment to target
    public init(signingKey: String, keyId: String, issuerId: String, bundleId: String) throws {
        try super.init(audience: "advanced-commerce-api", signingKey: signingKey, keyId: keyId, issuerId: issuerId, bundleId: bundleId)
    }
    
    ///Create an Advanced Commerce in-app signed request.
    ///
    ///- Parameter advancedCommerceInAppRequest: The request to be signed.
    ///- Returns: The signed JWS.
    ///[Generating JWS to sign App Store requests](https://developer.apple.com/documentation/storekit/generating-jws-to-sign-app-store-requests)
    public func createSignature(advancedCommerceInAppRequest: AdvancedCommerceInAppRequest) async throws -> String {
        let jsonEncoder = getJsonEncoder()
        let body = try jsonEncoder.encode(advancedCommerceInAppRequest)
        
        let base64EncodedBody = body.base64EncodedString()
        let baseClaims = super.getBasePayload()
        let claims = AdvancedCommerceInAppPayload(basePayload: baseClaims, request: base64EncodedBody)
        return try await super.createSignature(payload: claims)
    }
}
