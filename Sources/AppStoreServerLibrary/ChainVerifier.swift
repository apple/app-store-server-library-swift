// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import AsyncHTTPClient
import Foundation
import JWTKit
import SwiftASN1
import X509

struct ChainVerifier {
    private let verifier: X5CVerifier

    init(rootCertificates: [Foundation.Data]) throws {
        self.verifier = try X5CVerifier(rootCertificates: rootCertificates)
    }

    func verify<T: DecodedSignedData & JWTPayload>(signedData: String, type: T.Type, onlineVerification: Bool, environment: Environment) async -> VerificationResult<T> where T: Decodable {
        let dataToken = Foundation.Data(signedData.utf8)

        let (header, payload, _): (header: JWTKit.JWTHeader, payload: T, signature: Foundation.Data)

        do {
            (header, payload, _) = try DefaultJWTParser(jsonDecoder: getJsonDecoder())
                .parse(dataToken, as: T.self)
        } catch {
            return .invalid(VerificationError.INVALID_JWT_FORMAT)
        }

        if environment == Environment.xcode || environment == Environment.localTesting {
            // Data is not signed by the App Store, and verification should be skipped
            // The environment MUST be checked in the public method calling this
            return .valid(payload)
        }

        guard let x5c = header.x5c, x5c.count >= 3 else {
            return .invalid(VerificationError.INVALID_JWT_FORMAT)
        }

        let validationTime = !onlineVerification && payload.signedDate != nil ? payload.signedDate! : Date()

        do {
            let result = try await verifier.verifyJWS(dataToken, as: T.self, jsonDecoder: getJsonDecoder(), policy: {
                RFC5280Policy(validationTime: validationTime)
                AppStoreOIDPolicy()
                if onlineVerification {
                    OCSPVerifierPolicy(failureMode: .hard, requester: Requester(), validationTime: Date())
                }
            })
            return .valid(result)
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
        do {
            return try await verifier.verifyChain(certificates: [leaf, intermediate], policy: {
                RFC5280Policy(validationTime: validationTime)
                AppStoreOIDPolicy()
                if online {
                    OCSPVerifierPolicy(failureMode: .hard, requester: Requester(), validationTime: Date())
                }
            })
        } catch {
            return .couldNotValidate([])
        }
    }
}

final class AppStoreOIDPolicy: VerifierPolicy {
    private static let NUMBER_OF_CERTS = 3
    private static let WWDR_INTERMEDIATE_OID: ASN1ObjectIdentifier = [1, 2, 840, 113_635, 100, 6, 2, 1]
    private static let RECEIPT_SIGNER_OID: ASN1ObjectIdentifier = [1, 2, 840, 113_635, 100, 6, 11, 1]

    init() {
        verifyingCriticalExtensions = []
    }

    var verifyingCriticalExtensions: [SwiftASN1.ASN1ObjectIdentifier]

    func chainMeetsPolicyRequirements(chain: X509.UnverifiedCertificateChain) async -> X509.PolicyEvaluationResult {
        if chain.count != AppStoreOIDPolicy.NUMBER_OF_CERTS {
            return X509.PolicyEvaluationResult.failsToMeetPolicy(reason: "Chain has unexpected length")
        }
        let intermediateCertificate = chain[1]
        let leafCertificate = chain[0]
        if !intermediateCertificate.extensions.contains(where: { ext in
            ext.oid == AppStoreOIDPolicy.WWDR_INTERMEDIATE_OID
        }) {
            return X509.PolicyEvaluationResult.failsToMeetPolicy(reason: "Intermediate certificate does not contain WWDR OID")
        }
        if !leafCertificate.extensions.contains(where: { ext in
            ext.oid == AppStoreOIDPolicy.RECEIPT_SIGNER_OID
        }) {
            return X509.PolicyEvaluationResult.failsToMeetPolicy(reason: "Leaf certificate does not contain Receipt Signing OID")
        }
        return X509.PolicyEvaluationResult.meetsPolicy
    }
}

final class Requester: OCSPRequester {
    func query(request: [UInt8], uri: String) async -> X509.OCSPRequesterQueryResult {
        do {
            var urlRequest = HTTPClientRequest(url: uri)
            urlRequest.method = .POST
            urlRequest.headers.add(name: "Content-Type", value: "application/ocsp-request")
            urlRequest.body = .bytes(request)
            let response = try await HTTPClient.shared.execute(urlRequest, timeout: .seconds(30))
            var body = try await response.body.collect(upTo: 1024 * 1024)
            guard let data = body.readData(length: body.readableBytes) else {
                throw OCSPFetchError()
            }
            return .response([UInt8](data))
        } catch {
            return .terminalError(error)
        }
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
