// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import X509
import SwiftASN1
import JWTKit
import Crypto
import AsyncHTTPClient
import NIOFoundationCompat

class ChainVerifier {
    private static let EXPECTED_CHAIN_LENGTH = 3

    private static let MAXIMUM_CACHE_SIZE = 32 // There are unlikely to be more than a couple keys at once
    private static let CACHE_TIME_LIMIT: Int64 = 15 * 60 // 15 minutes in seconds

    private let x5cVerifier: X5CVerifier
    private let requester: Requester
    private var verifiedPublicKeyCache: [CacheKey: CacheValue]
    
    init(rootCertificates: [Data]) throws {
        self.x5cVerifier = try X5CVerifier(rootCertificates: rootCertificates)
        self.requester = Requester()
        self.verifiedPublicKeyCache = [:]
    }
    
    func verify<T: DecodedSignedData>(signedData: String, type: T.Type, onlineVerification: Bool, environment: AppStoreEnvironment) async -> VerificationResult<T> where T: JWTPayload {
        let jsonDecoder = getJsonDecoder()
        let parser = DefaultJWTParser(jsonDecoder: jsonDecoder)
        let payload: T
        let header: JWTKit.JWTHeader
        let dataToken = Data(signedData.utf8)

        do {
            (header, payload, _) = try parser.parse(dataToken, as: type)
        } catch {
            return VerificationResult.invalid(VerificationError.INVALID_JWT_FORMAT)
        }

        if (environment == AppStoreEnvironment.xcode || environment == AppStoreEnvironment.localTesting) {
            // Data is not signed by the App Store, and verification should be skipped.
            // The environment MUST be checked in the public method calling this
            return VerificationResult.valid(payload)   
        }

        guard let x5c = header.x5c, x5c.count == ChainVerifier.EXPECTED_CHAIN_LENGTH else {
            return .invalid(VerificationError.INVALID_JWT_FORMAT)
        }

        let validationTime = !onlineVerification && payload.signedDate != nil ? payload.signedDate! : getDate()

        do {
            let body = try await x5cVerifier.verifyJWS(dataToken, as: type, jsonDecoder: jsonDecoder, policy: {
                RFC5280Policy(validationTime: validationTime)
                AppStoreOIDPolicy()
                if onlineVerification {
                    OCSPVerifierPolicy(failureMode: .hard, requester: requester, validationTime: getDate())
                }
            })
            return VerificationResult.valid(body)
        } catch {
            if
                let jwtError = error as? JWTError,
                jwtError.errorType == .missingX5CHeader || jwtError.errorType == .malformedToken
            {
                return .invalid(VerificationError.INVALID_JWT_FORMAT)
            } else {
                return .invalid(VerificationError.VERIFICATION_FAILURE)
            }
        }
    }

    func verifyChain(leaf: Certificate, intermediate: Certificate, online: Bool, validationTime: Date) async -> X509.VerificationResult {
        if online {
            if let cachedResult = verifiedPublicKeyCache[CacheKey(leaf: leaf, intermediate: intermediate)] {
                if cachedResult.expirationTime > getDate() {
                    return cachedResult.publicKey
                }
            }
        }

        let verificationResult = await verifyChainWithoutCaching(leaf: leaf, intermediate: intermediate, online: online, validationTime: validationTime)

        if online {
            if case .validCertificate(_) = verificationResult {
                verifiedPublicKeyCache[CacheKey(leaf: leaf, intermediate: intermediate)] = CacheValue(
                    expirationTime: getDate().addingTimeInterval(TimeInterval(integerLiteral: ChainVerifier.CACHE_TIME_LIMIT)), 
                    publicKey: verificationResult
                )

                if verifiedPublicKeyCache.count > ChainVerifier.MAXIMUM_CACHE_SIZE {
                    for kv in verifiedPublicKeyCache {
                        if kv.value.expirationTime < getDate() {
                            verifiedPublicKeyCache.removeValue(forKey: kv.key)
                        }
                    }
                }
            }
        }

        return verificationResult
    }

    func verifyChainWithoutCaching(leaf: Certificate, intermediate: Certificate, online: Bool, validationTime: Date) async -> X509.VerificationResult {
        do {
            return try await x5cVerifier.verifyChain(certificates: [leaf, intermediate], policy: {
                RFC5280Policy(validationTime: validationTime)
                AppStoreOIDPolicy()
                if online {
                    OCSPVerifierPolicy(failureMode: .hard, requester: requester, validationTime: getDate())
                }
            })
        } catch {
            return .couldNotValidate([])
        }
    }

    func getDate() -> Date {
        return Date()
    }
}

struct CacheKey: Hashable {
    let leaf: Certificate
    let intermediate: Certificate
}

struct CacheValue {
    let expirationTime: Date
    let publicKey: X509.VerificationResult
}

final class AppStoreOIDPolicy: VerifierPolicy {
    
    private static let NUMBER_OF_CERTS = 3
    private static let WWDR_INTERMEDIATE_OID: ASN1ObjectIdentifier = [1, 2, 840, 113635, 100, 6, 2, 1]
    private static let RECEIPT_SIGNER_OID: ASN1ObjectIdentifier = [1, 2, 840, 113635, 100, 6, 11, 1]
    
    init() {
        verifyingCriticalExtensions = []
    }
    var verifyingCriticalExtensions: [SwiftASN1.ASN1ObjectIdentifier]
    
    func chainMeetsPolicyRequirements(chain: X509.UnverifiedCertificateChain) async -> X509.PolicyEvaluationResult {
        if (chain.count != AppStoreOIDPolicy.NUMBER_OF_CERTS) {
            return X509.PolicyEvaluationResult.failsToMeetPolicy(reason: "Chain has unexpected length")
        }
        let intermediateCertificate = chain[1]
        let leafCertificate = chain[0]
        if (!intermediateCertificate.extensions.contains(where: { ext in
            ext.oid == AppStoreOIDPolicy.WWDR_INTERMEDIATE_OID
        })) {
            return X509.PolicyEvaluationResult.failsToMeetPolicy(reason: "Intermediate certificate does not contain WWDR OID")
        }
        if (!leafCertificate.extensions.contains(where: { ext in
            ext.oid == AppStoreOIDPolicy.RECEIPT_SIGNER_OID
        })) {
            return X509.PolicyEvaluationResult.failsToMeetPolicy(reason: "Leaf certificate does not contain Receipt Signing OID")
        }
        return X509.PolicyEvaluationResult.meetsPolicy
    }
}

final class Requester: OCSPRequester {
    
    private let client: HTTPClient
    
    init() {
        self.client = .init()
    }

    func query(request: [UInt8], uri: String) async -> X509.OCSPRequesterQueryResult {
        do {
            var urlRequest = HTTPClientRequest(url: uri)
            urlRequest.method = .POST
            urlRequest.headers.add(name: "Content-Type", value: "application/ocsp-request")
            urlRequest.body = .bytes(request)
            let response = try await client.execute(urlRequest, timeout: .seconds(30))
            var body = try await response.body.collect(upTo: 1024 * 1024)
            guard let data = body.readData(length: body.readableBytes) else {
                throw OCSPFetchError()
            }
            return .response([UInt8](data))
        } catch {
            return .terminalError(error)
        }
    }
    
    deinit {
        try? self.client.syncShutdown()
    }
    
    private struct OCSPFetchError: Error {}
}

public enum VerificationResult<T> {
    case valid(T)
    case invalid(VerificationError)
}

public enum VerificationError: Hashable, Sendable {
    case INVALID_JWT_FORMAT
    case INVALID_CERTIFICATE
    case VERIFICATION_FAILURE
    case INVALID_APP_IDENTIFIER
    case INVALID_ENVIRONMENT
}
