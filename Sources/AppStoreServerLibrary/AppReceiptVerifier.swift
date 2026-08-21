// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation
import Crypto
import SwiftASN1
import X509

///A verifier and decoder class for legacy PKCS#7 App Store receipts, the app receipt used with the deprecated
///`verifyReceipt` endpoint.
///
///This is the validating counterpart to ``ReceiptUtility``, which extracts without validation. The receipt's
///certificate chain is validated with the same chain verification used for JWS signed data, against the same
///caller-supplied Apple root certificates, and evaluated at the receipt's creation date so old receipts survive
///certificate rotations unless online checks are enabled.
public struct AppReceiptVerifier: Sendable {

    private static let ATTR_RECEIPT_TYPE = Int64(0)
    private static let ATTR_BUNDLE_ID = Int64(2)
    private static let ATTR_APP_VERSION = Int64(3)
    private static let ATTR_OPAQUE_VALUE = Int64(4)
    private static let ATTR_SHA1_HASH = Int64(5)
    private static let ATTR_CREATION_DATE = Int64(12)
    private static let ATTR_IN_APP = Int64(17)
    private static let ATTR_ORIGINAL_PURCHASE_DATE = Int64(18)
    private static let ATTR_ORIGINAL_APP_VERSION = Int64(19)
    private static let ATTR_EXPIRATION_DATE = Int64(21)

    private static let IAP_QUANTITY = Int64(1701)
    private static let IAP_PRODUCT_ID = Int64(1702)
    private static let IAP_TRANSACTION_ID = Int64(1703)
    private static let IAP_PURCHASE_DATE = Int64(1704)
    private static let IAP_ORIGINAL_TRANSACTION_ID = Int64(1705)
    private static let IAP_ORIGINAL_PURCHASE_DATE = Int64(1706)
    private static let IAP_EXPIRES_DATE = Int64(1708)
    private static let IAP_WEB_ORDER_LINE_ITEM_ID = Int64(1711)
    private static let IAP_CANCELLATION_DATE = Int64(1712)
    private static let IAP_IS_IN_INTRO_OFFER_PERIOD = Int64(1719)

    private static let EXPECTED_CHAIN_LENGTH = 3

    private var bundleId: String
    private var environment: AppStoreEnvironment
    private var chainVerifier: ChainVerifier
    private var enableOnlineChecks: Bool

    /// - Parameter rootCertificates: The set of Apple Root certificate authority certificates, as found on [Apple PKI](https://www.apple.com/certificateauthority/)
    /// - Parameter bundleId: The bundle identifier of the app.
    /// - Parameter environment: The server environment, either sandbox or production.
    /// - Parameter enableOnlineChecks: Whether to enable revocation checking and check expiration using the current date
    /// - Throws: When the root certificates are malformed
    public init(rootCertificates: [Data], bundleId: String, environment: AppStoreEnvironment, enableOnlineChecks: Bool) throws {
        self.bundleId = bundleId
        self.environment = environment
        self.chainVerifier = try ChainVerifier(rootCertificates: rootCertificates)
        self.enableOnlineChecks = enableOnlineChecks
    }

    ///Verifies and decodes an app receipt, as obtained from a device
    ///See [App Store Receipts](https://developer.apple.com/documentation/appstorereceipts)
    ///
    ///- Parameter encodedReceipt The base64-encoded app receipt
    ///- Returns: If success, the decoded receipt after verification, else the reason for verification failure
    public func verifyAndDecodeAppReceipt(encodedReceipt: String) async -> VerificationResult<AppReceipt> {
        // The decoder ignores unknown characters, tolerating the line breaks base64 receipts commonly pick up in transit
        guard let receiptDer = Data(base64Encoded: encodedReceipt, options: .ignoreUnknownCharacters) else {
            return VerificationResult.invalid(VerificationError.VERIFICATION_FAILURE)
        }
        let signedData: PKCS7SignedData
        let receipt: AppReceipt
        do {
            // BER.parse throws when parsing does not exhaust the input, rejecting trailing bytes after the CMS blob
            signedData = try PKCS7SignedData(berEncoded: [UInt8](receiptDer))
            // Parsed before signature verification only to learn the creation date (chain validity is anchored at
            // signing time); nothing from it is trusted until the chain and signature checks pass.
            receipt = try AppReceiptVerifier.parseReceiptPayload(signedData.encapsulatedContent)
        } catch let error as AppReceiptVerificationError {
            return VerificationResult.invalid(error.verificationError)
        } catch {
            return VerificationResult.invalid(VerificationError.VERIFICATION_FAILURE)
        }
        if self.environment != .xcode && self.environment != .localTesting {
            let effectiveDate = self.enableOnlineChecks || receipt.receiptCreationDate == nil ? Date() : receipt.receiptCreationDate!
            let signerCertificate: Certificate
            switch await verifyChain(signedData: signedData, effectiveDate: effectiveDate) {
            case .valid(let certificate):
                signerCertificate = certificate
            case .invalid(let error):
                return VerificationResult.invalid(error)
            }
            if let signatureFailure = verifySignature(signedData: signedData, signerCertificate: signerCertificate) {
                return VerificationResult.invalid(signatureFailure)
            }
        }
        // In the Xcode and LocalTesting environments the data is not signed by the App Store and signature
        // verification is skipped, but the bundle id and environment are still validated.
        if self.bundleId != receipt.bundleId {
            return VerificationResult.invalid(VerificationError.INVALID_APP_IDENTIFIER)
        }
        if self.environment != AppReceiptVerifier.environmentForReceiptType(receipt.receiptType) {
            return VerificationResult.invalid(VerificationError.INVALID_ENVIRONMENT)
        }
        return VerificationResult.valid(receipt)
    }

    ///Verifies an app receipt and extracts a transaction id from its in-app purchases, the validated counterpart of
    ///``ReceiptUtility/extractTransactionId(appReceipt:)`` with the same output contract: a transaction id from the
    ///array of in-app purchases, or nil if the receipt contains none.
    ///
    ///- Parameter encodedReceipt The base64-encoded app receipt
    ///- Returns: If success, a transaction id from the receipt's in-app purchases, nil if the receipt contains no
    ///in-app purchases, else the reason for verification failure
    public func verifyAndExtractTransactionId(encodedReceipt: String) async -> VerificationResult<String?> {
        switch await verifyAndDecodeAppReceipt(encodedReceipt: encodedReceipt) {
        case .valid(let receipt):
            for purchase in receipt.inAppPurchases {
                if let transactionId = purchase.transactionId {
                    return VerificationResult.valid(transactionId)
                }
                if let originalTransactionId = purchase.originalTransactionId {
                    return VerificationResult.valid(originalTransactionId)
                }
            }
            return VerificationResult.valid(nil)
        case .invalid(let error):
            return VerificationResult.invalid(error)
        }
    }

    ///Orders the receipt's embedded certificates as leaf, intermediate, root and hands the leaf and intermediate to
    ///the shared ``ChainVerifier``, which enforces the chain length, the WWDR intermediate OID and the receipt-signing
    ///leaf OID, and validates to the caller-supplied Apple roots. As with JWS signed data, the root of the chain comes
    ///from the caller, not from the receipt.
    private func verifyChain(signedData: PKCS7SignedData, effectiveDate: Date) async -> VerificationResult<Certificate> {
        guard let leaf = signedData.signerCertificate() else {
            return VerificationResult.invalid(VerificationError.INVALID_CERTIFICATE)
        }
        var ordered = [leaf]
        while ordered.count < signedData.certificates.count {
            guard let issuer = signedData.certificates.first(where: { candidate in
                candidate.subject == ordered[ordered.count - 1].issuer && !ordered.contains(candidate)
            }) else {
                break
            }
            ordered.append(issuer)
        }
        guard ordered.count == AppReceiptVerifier.EXPECTED_CHAIN_LENGTH else {
            return VerificationResult.invalid(VerificationError.VERIFICATION_FAILURE)
        }
        let verificationResult = await chainVerifier.verifyChain(leaf: ordered[0], intermediate: ordered[1], online: self.enableOnlineChecks, validationTime: effectiveDate)
        switch verificationResult {
        case .validCertificate(_):
            return VerificationResult.valid(leaf)
        case .couldNotValidate(let terminalErrors):
            for failure in terminalErrors {
                if failure.policyFailureReason.description.contains(Requester.OCSP_NETWORK_REQUEST_FAILED) {
                    // OCSP validation failed due to network failures
                    return VerificationResult.invalid(VerificationError.RETRYABLE_VERIFICATION_FAILURE)
                }
            }
            return VerificationResult.invalid(VerificationError.VERIFICATION_FAILURE)
        }
    }

    ///Verifies the CMS signature made by the signer certificate. The signature is made over the signed attributes when
    ///they are present, in which case the message digest attribute must match the digest of the encapsulated payload,
    ///and over the payload itself otherwise. A signer key that is not RSA can satisfy neither, as only RSA signature
    ///algorithms are ever offered to it.
    private func verifySignature(signedData: PKCS7SignedData, signerCertificate: Certificate) -> VerificationError? {
        let signatureAlgorithm: Certificate.SignatureAlgorithm
        switch signedData.digestAlgorithm {
        case PKCS7SignedData.SHA1_OID:
            signatureAlgorithm = .sha1WithRSAEncryption
        case PKCS7SignedData.SHA256_OID:
            signatureAlgorithm = .sha256WithRSAEncryption
        default:
            // Unrecognized receipt digest algorithm
            return VerificationError.VERIFICATION_FAILURE
        }
        var signedBytes = signedData.encapsulatedContent
        if let signedAttributes = signedData.signedAttributes {
            let contentDigest: [UInt8] = signatureAlgorithm == .sha1WithRSAEncryption
                ? Array(Insecure.SHA1.hash(data: signedData.encapsulatedContent))
                : Array(SHA256.hash(data: signedData.encapsulatedContent))
            guard let messageDigest = signedData.messageDigest, messageDigest == contentDigest else {
                return VerificationError.VERIFICATION_FAILURE
            }
            signedBytes = signedAttributes
        }
        guard signerCertificate.publicKey.isValidSignature(signedData.signature, for: signedBytes, signatureAlgorithm: signatureAlgorithm) else {
            return VerificationError.VERIFICATION_FAILURE
        }
        return nil
    }

    ///Maps the receipt-type attribute to a server environment. Only explicit production values map to
    ///``AppStoreEnvironment/production``; unknown or missing values map to nil and fail environment validation.
    private static func environmentForReceiptType(_ receiptType: String?) -> AppStoreEnvironment? {
        switch receiptType {
        case "Production", "ProductionVPP":
            return .production
        case "ProductionSandbox", "ProductionVPPSandbox":
            return .sandbox
        case "Xcode":
            return .xcode
        case "LocalTesting":
            return .localTesting
        default:
            return nil
        }
    }

    private static func parseReceiptPayload(_ payload: [UInt8]) throws -> AppReceipt {
        var receipt = AppReceipt()
        for attribute in try parseAttributeSet(payload) {
            switch attribute.type {
            case ATTR_RECEIPT_TYPE:
                receipt.receiptType = try decodeString(attribute.value)
            case ATTR_BUNDLE_ID:
                receipt.bundleId = try decodeString(attribute.value)
                receipt.bundleIdBytes = Data(attribute.value)
            case ATTR_APP_VERSION:
                receipt.applicationVersion = try decodeString(attribute.value)
            case ATTR_OPAQUE_VALUE:
                receipt.opaqueValue = Data(attribute.value)
            case ATTR_SHA1_HASH:
                receipt.sha1Hash = Data(attribute.value)
            case ATTR_CREATION_DATE:
                receipt.receiptCreationDate = try decodeDate(attribute.value)
            case ATTR_IN_APP:
                receipt.inAppPurchases.append(try parseInAppPurchase(attribute.value))
            case ATTR_ORIGINAL_PURCHASE_DATE:
                receipt.originalPurchaseDate = try decodeDate(attribute.value)
            case ATTR_ORIGINAL_APP_VERSION:
                receipt.originalApplicationVersion = try decodeString(attribute.value)
            case ATTR_EXPIRATION_DATE:
                receipt.expirationDate = try decodeDate(attribute.value)
            default:
                receipt.unknownAttributes[attribute.type, default: []].append(Data(attribute.value))
            }
        }
        return receipt
    }

    private static func parseInAppPurchase(_ inAppSet: [UInt8]) throws -> InAppPurchaseReceipt {
        var purchase = InAppPurchaseReceipt()
        for attribute in try parseAttributeSet(inAppSet) {
            switch attribute.type {
            case IAP_QUANTITY:
                purchase.quantity = try decodeInteger(attribute.value)
            case IAP_PRODUCT_ID:
                purchase.productId = try decodeString(attribute.value)
            case IAP_TRANSACTION_ID:
                purchase.transactionId = try decodeString(attribute.value)
            case IAP_PURCHASE_DATE:
                purchase.purchaseDate = try decodeDate(attribute.value)
            case IAP_ORIGINAL_TRANSACTION_ID:
                purchase.originalTransactionId = try decodeString(attribute.value)
            case IAP_ORIGINAL_PURCHASE_DATE:
                purchase.originalPurchaseDate = try decodeDate(attribute.value)
            case IAP_EXPIRES_DATE:
                purchase.expiresDate = try decodeDate(attribute.value)
            case IAP_WEB_ORDER_LINE_ITEM_ID:
                purchase.webOrderLineItemId = try decodeInteger(attribute.value)
            case IAP_CANCELLATION_DATE:
                purchase.cancellationDate = try decodeDate(attribute.value)
            case IAP_IS_IN_INTRO_OFFER_PERIOD:
                purchase.isInIntroOfferPeriod = try decodeInteger(attribute.value) != 0
            default:
                purchase.unknownAttributes[attribute.type, default: []].append(Data(attribute.value))
            }
        }
        return purchase
    }

    ///`ReceiptAttribute ::= SEQUENCE { type INTEGER, version INTEGER, value OCTET STRING }`
    private struct ReceiptAttribute {
        let type: Int64
        let value: [UInt8]
    }

    private static func parseAttributeSet(_ der: [UInt8]) throws -> [ReceiptAttribute] {
        var parsed: ASN1Node
        do {
            parsed = try BER.parse(der)
            if parsed.identifier == .octetString {
                // Xcode receipts double-wrap the payload in an extra OCTET STRING; ReceiptUtility handles the same shape.
                parsed = try BER.parse(try ASN1OctetString(berEncoded: parsed).bytes)
            }
        } catch {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        guard parsed.identifier == .set, case .constructed(let elements) = parsed.content else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        var attributes: [ReceiptAttribute] = []
        for element in elements {
            attributes.append(try parseAttribute(element))
        }
        return attributes
    }

    private static func parseAttribute(_ element: ASN1Node) throws -> ReceiptAttribute {
        do {
            return try BER.sequence(element, identifier: .sequence) { nodes in
                guard let typeNode = nodes.next(), nodes.next() != nil, let valueNode = nodes.next() else {
                    throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
                }
                while nodes.next() != nil {}
                let type = try boundedInt64(typeNode)
                let value = try ASN1OctetString(berEncoded: valueNode)
                return ReceiptAttribute(type: type, value: Array(value.bytes))
            }
        } catch let error as AppReceiptVerificationError {
            throw error
        } catch {
            // Malformed receipt attribute
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
    }

    ///Non-negative and within Int64 range, real receipts carry 7-byte integers.
    private static func boundedInt64(_ node: ASN1Node) throws -> Int64 {
        guard let value = try? Int64(berEncoded: node, withIdentifier: .integer), value >= 0 else {
            // Receipt integer out of range
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        return value
    }

    private static func decodeString(_ der: [UInt8]) throws -> String {
        guard let parsed = try? BER.parse(der) else {
            // Attribute value is not valid ASN.1
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        // Apple is not consistent about which string type an attribute uses
        let bytes: ArraySlice<UInt8>
        switch parsed.identifier {
        case .utf8String:
            bytes = try ASN1UTF8String(berEncoded: parsed).bytes
        case .ia5String:
            bytes = try ASN1IA5String(berEncoded: parsed).bytes
        case .printableString:
            bytes = try ASN1PrintableString(berEncoded: parsed).bytes
        default:
            // Attribute value is not an ASN.1 string
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        guard let string = String(bytes: bytes, encoding: .utf8) else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        return string
    }

    private static func decodeInteger(_ der: [UInt8]) throws -> Int64 {
        guard let parsed = try? BER.parse(der), parsed.identifier == .integer else {
            // Attribute value is not an ASN.1 integer
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        return try boundedInt64(parsed)
    }

    ///RFC 3339 date in an IA5String; an empty string means absent, which real receipts do.
    private static func decodeDate(_ der: [UInt8]) throws -> Date? {
        let text = try decodeString(der)
        if text.isEmpty {
            return nil
        }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: text) {
            return date
        }
        formatter.formatOptions = [.withInternetDateTime]
        guard let date = formatter.date(from: text) else {
            // Unparseable receipt date
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        return date
    }
}

///Carries the ``VerificationError`` a failed decoding step should be reported as, so the ASN.1 walk can fail fast
///without every helper returning a result.
internal struct AppReceiptVerificationError: Error {
    let verificationError: VerificationError

    init(_ verificationError: VerificationError) {
        self.verificationError = verificationError
    }
}

///The subset of a PKCS#7 `SignedData` an app receipt needs. Parsed with BER because genuine App Store and
///Xcode-generated receipts use indefinite lengths and segmented OCTET STRINGs.
///```
///ContentInfo ::= SEQUENCE { contentType OBJECT IDENTIFIER, content [0] EXPLICIT SignedData }
///SignedData ::= SEQUENCE { version INTEGER, digestAlgorithms SET OF AlgorithmIdentifier,
///                          encapContentInfo EncapsulatedContentInfo, certificates [0] IMPLICIT CertificateSet OPTIONAL,
///                          crls [1] IMPLICIT RevocationInfoChoices OPTIONAL, signerInfos SET OF SignerInfo }
///SignerInfo ::= SEQUENCE { version INTEGER, sid SignerIdentifier, digestAlgorithm AlgorithmIdentifier,
///                          signedAttrs [0] IMPLICIT SignedAttributes OPTIONAL, signatureAlgorithm AlgorithmIdentifier,
///                          signature OCTET STRING, unsignedAttrs [1] IMPLICIT UnsignedAttributes OPTIONAL }
///```
internal struct PKCS7SignedData {

    static let SIGNED_DATA_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 7, 2]
    static let MESSAGE_DIGEST_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 9, 4]
    static let SHA1_OID: ASN1ObjectIdentifier = [1, 3, 14, 3, 2, 26]
    static let SHA256_OID: ASN1ObjectIdentifier = [2, 16, 840, 1, 101, 3, 4, 2, 1]

    private static let CONTEXT_TAG_0 = ASN1Identifier(tagWithNumber: 0, tagClass: .contextSpecific)
    private static let CONTEXT_TAG_1 = ASN1Identifier(tagWithNumber: 1, tagClass: .contextSpecific)

    ///The encapsulated payload of the container, the receipt's attribute set.
    let encapsulatedContent: [UInt8]
    ///The certificates embedded in the container, in the order they appear.
    let certificates: [Certificate]
    ///The digest algorithm of the first signer info, which also selects the RSA signature algorithm.
    let digestAlgorithm: ASN1ObjectIdentifier
    ///The bytes the signature covers when signed attributes are present: the `[0] IMPLICIT` signed attributes
    ///re-tagged as an explicit SET OF, as RFC 5652 section 5.4 requires.
    let signedAttributes: [UInt8]?
    ///The message digest signed attribute, which must match the digest of ``encapsulatedContent``.
    let messageDigest: [UInt8]?
    let signature: [UInt8]

    private let signerIssuer: DistinguishedName
    private let signerSerialNumber: [UInt8]

    init(berEncoded bytes: [UInt8]) throws {
        let contentInfo = try PKCS7SignedData.children(try BER.parse(bytes))
        guard contentInfo.count >= 2,
              let contentType = try? ASN1ObjectIdentifier(berEncoded: contentInfo[0]),
              contentType == PKCS7SignedData.SIGNED_DATA_OID else {
            // Receipt is not a PKCS#7 container
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        let signedData = try PKCS7SignedData.children(try PKCS7SignedData.explicit(contentInfo[1]))
        guard signedData.count >= 4 else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        // encapContentInfo ::= SEQUENCE { eContentType OBJECT IDENTIFIER, eContent [0] EXPLICIT OCTET STRING OPTIONAL }
        let encapContentInfo = try PKCS7SignedData.children(signedData[2])
        guard encapContentInfo.count >= 2 else {
            // Receipt has no encapsulated payload
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        self.encapsulatedContent = try PKCS7SignedData.octetStringValue(try PKCS7SignedData.explicit(encapContentInfo[1]))

        var certificates: [Certificate] = []
        for node in signedData.dropFirst(3) where node.identifier == PKCS7SignedData.CONTEXT_TAG_0 {
            for certificateNode in try PKCS7SignedData.children(node) {
                guard let certificate = try? Certificate(derEncoded: certificateNode) else {
                    throw AppReceiptVerificationError(.INVALID_CERTIFICATE)
                }
                certificates.append(certificate)
            }
        }
        self.certificates = certificates

        guard let signerInfos = signedData.last, signerInfos.identifier == .set,
              let signerInfo = try PKCS7SignedData.children(signerInfos).first else {
            // Receipt has no signer info
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        let signerFields = try PKCS7SignedData.children(signerInfo)
        guard signerFields.count >= 5 else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        // sid ::= IssuerAndSerialNumber SEQUENCE { issuer Name, serialNumber INTEGER }; the subjectKeyIdentifier
        // choice is not used by App Store receipts.
        let signerIdentifier = try PKCS7SignedData.children(signerFields[1])
        guard signerIdentifier.count >= 2, let issuer = try? DistinguishedName(derEncoded: signerIdentifier[0]) else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        self.signerIssuer = issuer
        self.signerSerialNumber = PKCS7SignedData.normalizedSerialNumber(try PKCS7SignedData.primitive(signerIdentifier[1]))

        let digestAlgorithmFields = try PKCS7SignedData.children(signerFields[2])
        guard digestAlgorithmFields.count >= 1, let digestAlgorithm = try? ASN1ObjectIdentifier(berEncoded: digestAlgorithmFields[0]) else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        self.digestAlgorithm = digestAlgorithm

        var index = 3
        if signerFields[index].identifier == PKCS7SignedData.CONTEXT_TAG_0 {
            let signedAttributesNode = signerFields[index]
            // The signature covers the signed attributes re-encoded as an explicit SET (RFC 5652 section 5.4): the
            // IMPLICIT [0] tag byte is swapped for the SET tag, leaving the length and contents untouched.
            var reencoded = Array(signedAttributesNode.encodedBytes)
            guard !reencoded.isEmpty else {
                throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
            }
            reencoded[0] = 0x31
            self.signedAttributes = reencoded
            var messageDigest: [UInt8]? = nil
            for attribute in try PKCS7SignedData.children(signedAttributesNode) {
                let attributeFields = try PKCS7SignedData.children(attribute)
                guard attributeFields.count >= 2 else {
                    throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
                }
                if (try? ASN1ObjectIdentifier(berEncoded: attributeFields[0])) == PKCS7SignedData.MESSAGE_DIGEST_OID,
                   let value = try PKCS7SignedData.children(attributeFields[1]).first {
                    messageDigest = try PKCS7SignedData.octetStringValue(value)
                }
            }
            self.messageDigest = messageDigest
            index += 1
        } else {
            // Genuine App Store receipts carry no signed attributes; the signature then covers the payload directly
            self.signedAttributes = nil
            self.messageDigest = nil
        }
        // The signature algorithm identifier is deliberately not read: genuine receipts declare a bare rsaEncryption
        // there, and the digest algorithm above is what selects the hash. Only RSA algorithms are ever offered to the
        // signer key, so a non-RSA key can never produce a valid signature.
        index += 1
        guard index < signerFields.count else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        self.signature = try PKCS7SignedData.octetStringValue(signerFields[index])
    }

    ///The embedded certificate the first signer info identifies, if it is present in the container.
    func signerCertificate() -> Certificate? {
        return certificates.first { certificate in
            certificate.issuer == signerIssuer
                && PKCS7SignedData.normalizedSerialNumber(Array(certificate.serialNumber.bytes)) == signerSerialNumber
        }
    }

    ///Bounds-checked navigation. A plain array subscript traps uncatchably, and every structure here is
    ///attacker-controlled until the signature has been verified.
    private static func children(_ node: ASN1Node) throws -> [ASN1Node] {
        guard case .constructed(let nodes) = node.content else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        return Array(nodes)
    }

    ///Unwraps an EXPLICIT context tag to the single node it contains.
    private static func explicit(_ node: ASN1Node) throws -> ASN1Node {
        let inner = try children(node)
        guard inner.count == 1 else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        return inner[0]
    }

    private static func primitive(_ node: ASN1Node) throws -> [UInt8] {
        guard case .primitive(let bytes) = node.content else {
            throw AppReceiptVerificationError(.VERIFICATION_FAILURE)
        }
        return Array(bytes)
    }

    ///The value bytes of an OCTET STRING, joining the chunks of a BER constructed encoding.
    private static func octetStringValue(_ node: ASN1Node) throws -> [UInt8] {
        switch node.content {
        case .primitive(let bytes):
            return Array(bytes)
        case .constructed(let chunks):
            var value: [UInt8] = []
            for chunk in chunks {
                value.append(contentsOf: try octetStringValue(chunk))
            }
            return value
        }
    }

    ///Drops the leading zero a positive INTEGER carries to stay unsigned, so serial numbers compare by value.
    private static func normalizedSerialNumber(_ bytes: [UInt8]) -> [UInt8] {
        return Array(bytes.drop(while: { $0 == 0x00 }))
    }
}
