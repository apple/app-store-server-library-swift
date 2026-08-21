// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation
import Crypto
import _CryptoExtras
import SwiftASN1
import X509

///Generates a throwaway "Apple-like" RSA PKI (root, WWDR intermediate, receipt signing leaf) and CMS-signs synthetic
///legacy app receipts with it, so ``AppReceiptVerifier`` can be exercised without any real Apple key material or a
///checked-in receipt.
public final class ReceiptCreator: Sendable {

    private static let WWDR_INTERMEDIATE_OID: ASN1ObjectIdentifier = [1, 2, 840, 113635, 100, 6, 2, 1]
    private static let RECEIPT_SIGNER_OID: ASN1ObjectIdentifier = [1, 2, 840, 113635, 100, 6, 11, 1]

    private static let SIGNED_DATA_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 7, 2]
    private static let DATA_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 7, 1]
    private static let CONTENT_TYPE_ATTRIBUTE_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 9, 3]
    private static let MESSAGE_DIGEST_ATTRIBUTE_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 9, 4]
    private static let SIGNING_TIME_ATTRIBUTE_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 9, 5]
    private static let SHA256_OID: ASN1ObjectIdentifier = [2, 16, 840, 1, 101, 3, 4, 2, 1]
    private static let RSA_ENCRYPTION_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 1, 1]

    private static let CONTEXT_TAG_0 = ASN1Identifier(tagWithNumber: 0, tagClass: .contextSpecific)

    private static let DAY: TimeInterval = 86400

    ///Leaf first, then intermediate, then root; a self-signed creator holds one entry.
    private let chain: [Certificate]
    private let signingKey: _RSA.Signing.PrivateKey

    private init(chain: [Certificate], signingKey: _RSA.Signing.PrivateKey) {
        self.chain = chain
        self.signingKey = signingKey
    }

    ///A chain carrying both Apple marker OIDs, with a validity window wide enough to cover any plausible receipt
    ///creation date: the chain of a receipt is evaluated at the date the receipt was created, not now.
    ///
    ///- Parameter receiptSignerOid: Whether the leaf carries the receipt-signing marker OID
    ///- Parameter wwdrIntermediateOid: Whether the intermediate carries the WWDR marker OID
    ///- Parameter notBefore: The start of the validity window of every certificate in the chain
    ///- Parameter notAfter: The end of the validity window of every certificate in the chain
    public static func createReceiptCreator(receiptSignerOid: Bool = true, wwdrIntermediateOid: Bool = true, notBefore: Date = daysAgo(3650), notAfter: Date = inOneYear()) throws -> ReceiptCreator {
        let rootKey = try rsaKey()
        let intermediateKey = try rsaKey()
        let leafKey = try rsaKey()
        let rootName = distinguishedName("Test App Store Root CA")
        let intermediateName = distinguishedName("Test WWDR CA")
        let root = try certificate(subject: rootName, subjectKey: rootKey, issuer: rootName, issuerKey: rootKey, certificateAuthority: true, markerOid: nil, notBefore: notBefore, notAfter: notAfter)
        let intermediate = try certificate(subject: intermediateName, subjectKey: intermediateKey, issuer: rootName, issuerKey: rootKey, certificateAuthority: true, markerOid: wwdrIntermediateOid ? WWDR_INTERMEDIATE_OID : nil, notBefore: notBefore, notAfter: notAfter)
        let leaf = try certificate(subject: distinguishedName("Test Receipt Signing"), subjectKey: leafKey, issuer: intermediateName, issuerKey: intermediateKey, certificateAuthority: false, markerOid: receiptSignerOid ? RECEIPT_SIGNER_OID : nil, notBefore: notBefore, notAfter: notAfter)
        return ReceiptCreator(chain: [leaf, intermediate, root], signingKey: leafKey)
    }

    ///A single self-signed certificate, as an Xcode-generated receipt carries; such a receipt is never chain verified.
    public static func createSelfSignedReceiptCreator() throws -> ReceiptCreator {
        let key = try rsaKey()
        let name = distinguishedName("Test Xcode Receipt Signing")
        let certificate = try certificate(subject: name, subjectKey: key, issuer: name, issuerKey: key, certificateAuthority: false, markerOid: RECEIPT_SIGNER_OID, notBefore: daysAgo(3650), notAfter: inOneYear())
        return ReceiptCreator(chain: [certificate], signingKey: key)
    }

    ///The root of this chain, in the form the verifier's initializer accepts.
    public var rootCertificate: Data {
        var serializer = DER.Serializer()
        try! serializer.serialize(chain[chain.count - 1])
        return Data(serializer.serializedBytes)
    }

    ///CMS-signs `payload` as encapsulated content, embedding the chain.
    ///
    ///- Parameter embeddedCertificates: How many certificates of the chain, starting at the leaf, to embed in the container
    ///- Parameter signingTime: The CMS signing time attribute, which a stricter verifier would require to fall inside
    ///the signer certificate's validity window, so an old receipt signed by a since expired certificate needs its
    ///original signing time
    ///- Parameter signedAttributes: Whether to sign through a set of signed attributes, as a receipt produced by
    ///BouncyCastle does, rather than over the payload directly, as genuine App Store receipts do
    ///- Parameter segmentedContent: Whether to encapsulate the payload in a constructed, segmented OCTET STRING, the
    ///BER shape genuine App Store receipts arrive in, rather than a single primitive one
    public func signReceipt(_ payload: [UInt8], embeddedCertificates: Int? = nil, signingTime: Date = Date(), signedAttributes: Bool = true, segmentedContent: Bool = false) throws -> Data {
        let signedAttributeBytes = signedAttributes ? try ReceiptCreator.signedAttributeSet(payload: payload, signingTime: signingTime) : nil
        let signature = try signingKey.signature(for: SHA256.hash(data: signedAttributeBytes ?? payload), padding: .insecurePKCS1v1_5)

        var serializer = DER.Serializer()
        try serializer.appendConstructedNode(identifier: .sequence) { coder in
            try coder.serialize(ReceiptCreator.SIGNED_DATA_OID)
            try coder.appendConstructedNode(identifier: ReceiptCreator.CONTEXT_TAG_0) { coder in
                try coder.appendConstructedNode(identifier: .sequence) { coder in
                    try coder.serialize(1)
                    try coder.serializeSetOf([ReceiptCreator.algorithmIdentifier(ReceiptCreator.SHA256_OID)])
                    // encapContentInfo ::= SEQUENCE { eContentType OBJECT IDENTIFIER, eContent [0] EXPLICIT OCTET STRING }
                    try coder.appendConstructedNode(identifier: .sequence) { coder in
                        try coder.serialize(ReceiptCreator.DATA_OID)
                        try coder.appendConstructedNode(identifier: ReceiptCreator.CONTEXT_TAG_0) { coder in
                            if segmentedContent {
                                let split = payload.count / 2
                                try coder.appendConstructedNode(identifier: .octetString) { coder in
                                    try coder.serialize(ASN1OctetString(contentBytes: payload[..<split]))
                                    try coder.serialize(ASN1OctetString(contentBytes: payload[split...]))
                                }
                            } else {
                                try coder.serialize(ASN1OctetString(contentBytes: payload[...]))
                            }
                        }
                    }
                    coder.appendConstructedNode(identifier: ReceiptCreator.CONTEXT_TAG_0) { coder in
                        for certificate in chain.prefix(embeddedCertificates ?? chain.count) {
                            try! coder.serialize(certificate)
                        }
                    }
                    try coder.serializeSetOf([try signerInfo(signedAttributeBytes: signedAttributeBytes, signature: signature)])
                }
            }
        }
        return Data(serializer.serializedBytes)
    }

    ///The extra OCTET STRING wrapper Xcode-generated receipts put around the payload.
    public static func doubleWrap(_ payload: [UInt8]) -> [UInt8] {
        var serializer = DER.Serializer()
        try! serializer.serialize(ASN1OctetString(contentBytes: payload[...]))
        return serializer.serializedBytes
    }

    public static func attributeSet() -> AttributeSet {
        return AttributeSet()
    }

    ///Builds a receipt attribute SET, the shape both the receipt payload and the value of an in-app purchase attribute
    ///take. Each attribute is `SEQUENCE { type INTEGER, version INTEGER, value OCTET STRING }`.
    public final class AttributeSet {
        private var attributes: [DERBytes] = []

        fileprivate init() {}

        ///An attribute whose value is a DER UTF8String, e.g. the bundle identifier.
        @discardableResult
        public func string(_ type: Int64, _ value: String) -> AttributeSet {
            var serializer = DER.Serializer()
            try! serializer.serialize(ASN1UTF8String(value))
            return raw(type, serializer.serializedBytes)
        }

        ///An attribute whose value is a DER IA5String holding an RFC 3339 date.
        @discardableResult
        public func date(_ type: Int64, _ value: String) -> AttributeSet {
            var serializer = DER.Serializer()
            try! serializer.serialize(try! ASN1IA5String(value))
            return raw(type, serializer.serializedBytes)
        }

        ///An attribute whose value is a DER INTEGER, e.g. a purchase quantity.
        @discardableResult
        public func integer(_ type: Int64, _ value: Int64) -> AttributeSet {
            var serializer = DER.Serializer()
            try! serializer.serialize(value)
            return raw(type, serializer.serializedBytes)
        }

        ///An attribute whose value bytes are used as-is, e.g. an opaque value or a nested SET.
        @discardableResult
        public func raw(_ type: Int64, _ value: [UInt8]) -> AttributeSet {
            var serializer = DER.Serializer()
            try! serializer.appendConstructedNode(identifier: .sequence) { coder in
                try coder.serialize(type)
                try coder.serialize(1)
                try coder.serialize(ASN1OctetString(contentBytes: value[...]))
            }
            attributes.append(DERBytes(serializer.serializedBytes))
            return self
        }

        public func build() -> [UInt8] {
            var serializer = DER.Serializer()
            try! serializer.serializeSetOf(attributes)
            return serializer.serializedBytes
        }
    }

    public static func inOneYear() -> Date {
        return Date().addingTimeInterval(365 * DAY)
    }

    public static func daysAgo(_ days: Int) -> Date {
        return Date().addingTimeInterval(-Double(days) * DAY)
    }

    ///`SignerInfo ::= SEQUENCE { version INTEGER, sid IssuerAndSerialNumber, digestAlgorithm AlgorithmIdentifier,`
    ///`signedAttrs [0] IMPLICIT SignedAttributes OPTIONAL, signatureAlgorithm AlgorithmIdentifier, signature OCTET STRING }`
    private func signerInfo(signedAttributeBytes: [UInt8]?, signature: _RSA.Signing.RSASignature) throws -> DERBytes {
        let leaf = chain[0]
        var serializer = DER.Serializer()
        try serializer.appendConstructedNode(identifier: .sequence) { coder in
            try coder.serialize(1)
            try coder.appendConstructedNode(identifier: .sequence) { coder in
                try coder.serialize(leaf.issuer)
                try coder.serialize(leaf.serialNumber.bytes)
            }
            try coder.serialize(ReceiptCreator.algorithmIdentifier(ReceiptCreator.SHA256_OID))
            if var implicitlyTagged = signedAttributeBytes {
                // The same bytes that were signed, with the SET OF tag swapped back for the IMPLICIT [0] tag
                implicitlyTagged[0] = 0xA0
                coder.serializeRawBytes(implicitlyTagged)
            }
            try coder.serialize(ReceiptCreator.algorithmIdentifier(ReceiptCreator.RSA_ENCRYPTION_OID))
            try coder.serialize(ASN1OctetString(contentBytes: ArraySlice(signature.rawRepresentation)))
        }
        return DERBytes(serializer.serializedBytes)
    }

    ///The signed attributes, serialized as the explicit SET OF the signature is computed over.
    private static func signedAttributeSet(payload: [UInt8], signingTime: Date) throws -> [UInt8] {
        let contentType = try attribute(CONTENT_TYPE_ATTRIBUTE_OID) { coder in
            try coder.serialize(DATA_OID)
        }
        let messageDigest = try attribute(MESSAGE_DIGEST_ATTRIBUTE_OID) { coder in
            try coder.serialize(ASN1OctetString(contentBytes: ArraySlice(Array(SHA256.hash(data: payload)))))
        }
        let signingTimeAttribute = try attribute(SIGNING_TIME_ATTRIBUTE_OID) { coder in
            try coder.serialize(utcTime(signingTime))
        }
        var serializer = DER.Serializer()
        try serializer.serializeSetOf([contentType, messageDigest, signingTimeAttribute])
        return serializer.serializedBytes
    }

    ///`Attribute ::= SEQUENCE { attrType OBJECT IDENTIFIER, attrValues SET OF ANY }`
    private static func attribute(_ oid: ASN1ObjectIdentifier, _ value: (inout DER.Serializer) throws -> Void) throws -> DERBytes {
        var serializer = DER.Serializer()
        try serializer.appendConstructedNode(identifier: .sequence) { coder in
            try coder.serialize(oid)
            try coder.appendConstructedNode(identifier: .set) { coder in
                try value(&coder)
            }
        }
        return DERBytes(serializer.serializedBytes)
    }

    private static func algorithmIdentifier(_ oid: ASN1ObjectIdentifier) -> DERBytes {
        var serializer = DER.Serializer()
        try! serializer.appendConstructedNode(identifier: .sequence) { coder in
            try coder.serialize(oid)
            try coder.serialize(ASN1Null())
        }
        return DERBytes(serializer.serializedBytes)
    }

    private static func utcTime(_ date: Date) throws -> UTCTime {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return try UTCTime(year: components.year!, month: components.month!, day: components.day!, hours: components.hour!, minutes: components.minute!, seconds: components.second!)
    }

    private static func rsaKey() throws -> _RSA.Signing.PrivateKey {
        return try _RSA.Signing.PrivateKey(keySize: .bits2048)
    }

    private static func distinguishedName(_ commonName: String) -> DistinguishedName {
        return try! DistinguishedName {
            CommonName(commonName)
        }
    }

    private static func certificate(subject: DistinguishedName, subjectKey: _RSA.Signing.PrivateKey, issuer: DistinguishedName, issuerKey: _RSA.Signing.PrivateKey, certificateAuthority: Bool, markerOid: ASN1ObjectIdentifier?, notBefore: Date, notAfter: Date) throws -> Certificate {
        var extensions = [
            try Certificate.Extension(certificateAuthority ? BasicConstraints.isCertificateAuthority(maxPathLength: nil) : BasicConstraints.notCertificateAuthority, critical: true)
        ]
        if let markerOid {
            // The Apple marker extensions are non-critical and carry a DER NULL as their value
            extensions.append(Certificate.Extension(oid: markerOid, critical: false, value: [0x05, 0x00]))
        }
        return try Certificate(
            version: .v3,
            serialNumber: Certificate.SerialNumber(),
            publicKey: Certificate.PublicKey(subjectKey.publicKey),
            notValidBefore: notBefore,
            notValidAfter: notAfter,
            issuer: issuer,
            subject: subject,
            signatureAlgorithm: .sha256WithRSAEncryption,
            extensions: try Certificate.Extensions(extensions),
            issuerPrivateKey: Certificate.PrivateKey(issuerKey)
        )
    }
}

///Already-encoded DER, so pieces built separately can be nested and sorted into a SET OF.
struct DERBytes: DERSerializable {
    private let bytes: [UInt8]

    init(_ bytes: [UInt8]) {
        self.bytes = bytes
    }

    func serialize(into coder: inout DER.Serializer) throws {
        coder.serializeRawBytes(bytes)
    }
}
