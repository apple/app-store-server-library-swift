// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import SwiftASN1

public class ReceiptUtility {

    public enum ReceiptError: Error, Hashable, Sendable {
        case invalidAppReceipt
        case invalidTransactionReceipt
    }

    private static let IN_APP_TYPE_ID = Int64(17)
    private static let TRANSACTION_IDENTIFIER_TYPE_ID = Int64(1703)
    private static let ORIGINAL_TRANSACTION_IDENTIFIER_TYPE_ID = Int64(1705)
    private static let PKCS7_SIGNED_DATA_OID: ASN1ObjectIdentifier = [1, 2, 840, 113549, 1, 7, 2]

    ///Extracts a transaction id from an encoded App Receipt. Throws if the receipt does not match the expected format.
    ///*NO validation* is performed on the receipt, and any data returned should only be used to call the App Store Server API.
    ///- Parameter appReceipt: The unmodified app receipt
    ///- Returns: The first transaction id from the array of in-app purchases, or nil if the receipt is well-formed but contains no transaction id
    ///- Throws: ``ReceiptError/invalidAppReceipt`` if the receipt is not valid base64, is not a PKCS #7 app receipt, or is otherwise not in the expected format
    public static func extractTransactionId(appReceipt: String) throws -> String? {
        guard let receiptData = Data(base64Encoded: appReceipt) else {
            throw ReceiptError.invalidAppReceipt
        }
        do {
            let receiptContent = try BER.sequence(try BER.parse([UInt8](receiptData)), identifier: ASN1Identifier.sequence) { nodes in
                guard try ASN1ObjectIdentifier(berEncoded: &nodes) == PKCS7_SIGNED_DATA_OID else {
                    throw ReceiptError.invalidAppReceipt
                }
                let content = try BER.explicitlyTagged(&nodes, tagNumber: 0, tagClass: .contextSpecific) { signedDataNode in
                    try BER.sequence(signedDataNode, identifier: ASN1Identifier.sequence) { nodes in
                        _ = nodes.next()
                        _ = nodes.next()
                        guard let encapContentInfo = nodes.next() else {
                            throw ReceiptError.invalidAppReceipt
                        }
                        let eContent = try BER.sequence(encapContentInfo, identifier: ASN1Identifier.sequence) { nodes in
                            _ = try ASN1ObjectIdentifier(berEncoded: &nodes)
                            let eContent = try BER.explicitlyTagged(&nodes, tagNumber: 0, tagClass: .contextSpecific) { try ASN1OctetString(berEncoded: $0) }
                            skipRemainingNodes(&nodes)
                            return eContent
                        }
                        skipRemainingNodes(&nodes)
                        return eContent
                    }
                }
                skipRemainingNodes(&nodes)
                return content
            }
            for (type, value) in try parseReceiptAttributes(receiptContent) where type == IN_APP_TYPE_ID {
                if let transactionId = try extractTransactionIdFromInAppReceipt(inAppReceiptContent: value) {
                    return transactionId
                }
            }
            return nil
        } catch let error as ReceiptError {
            throw error
        } catch {
            throw ReceiptError.invalidAppReceipt
        }
    }

    private static func extractTransactionIdFromInAppReceipt(inAppReceiptContent: ASN1OctetString) throws -> String? {
        let transactionIdAttribute = try parseReceiptAttributes(inAppReceiptContent).first { type, _ in
            type == TRANSACTION_IDENTIFIER_TYPE_ID || type == ORIGINAL_TRANSACTION_IDENTIFIER_TYPE_ID
        }
        guard let transactionIdValue = transactionIdAttribute?.1 else {
            return nil
        }
        return String(try ASN1UTF8String(berEncoded: try BER.parse(transactionIdValue.bytes), withIdentifier: .utf8String))
    }

    private static func parseReceiptAttributes(_ content: ASN1OctetString) throws -> [(Int64, ASN1OctetString)] {
        return try BER.set(try BER.parse(content.bytes), identifier: ASN1Identifier.set) { nodes in
            var attributes: [(Int64, ASN1OctetString)] = []
            while let node = nodes.next() {
                let attribute = try? BER.sequence(node, identifier: ASN1Identifier.sequence) { attributeNodes -> (Int64, ASN1OctetString)? in
                    guard let typeEncoded = attributeNodes.next(), attributeNodes.next() != nil, let valueEncoded = attributeNodes.next() else {
                        return nil
                    }
                    return (try Int64(berEncoded: typeEncoded, withIdentifier: ASN1Identifier.integer), try ASN1OctetString(berEncoded: valueEncoded))
                }
                if let attribute = attribute {
                    attributes.append(attribute)
                }
            }
            return attributes
        }
    }

    private static func skipRemainingNodes(_ nodes: inout ASN1NodeCollection.Iterator) {
        while nodes.next() != nil {}
    }

    ///Extracts a transaction id from an encoded transactional receipt. Throws if the receipt does not match the expected format.
    ///*NO validation* is performed on the receipt, and any data returned should only be used to call the App Store Server API.
    /// - Parameter transactionReceipt: The unmodified transactionReceipt
    /// - Returns: A transaction id, or nil if the receipt is well-formed but contains no transaction id
    /// - Throws: ``ReceiptError/invalidTransactionReceipt`` if the receipt is not valid base64, contains no purchase-info, or is otherwise not in the expected format
    public static func extractTransactionId(transactionReceipt: String) throws -> String? {
        guard let decodedReceipt = Data(base64Encoded: transactionReceipt).flatMap({ String(bytes: $0, encoding: .utf8) }),
              let purchaseInfo = firstMatch(#"\"purchase-info\"\s+=\s+\"([a-zA-Z0-9+/=]+)\";"#, in: decodedReceipt),
              let decodedPurchaseInfo = Data(base64Encoded: purchaseInfo).flatMap({ String(bytes: $0, encoding: .utf8) }) else {
            throw ReceiptError.invalidTransactionReceipt
        }
        return firstMatch(#"\"transaction-id\"\s+=\s+\"([a-zA-Z0-9+/=]+)\";"#, in: decodedPurchaseInfo)
    }

    private static func firstMatch(_ pattern: String, in string: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []),
              let match = regex.firstMatch(in: string, range: NSRange(string.startIndex..<string.endIndex, in: string)),
              let range = Range(match.range(at: 1), in: string) else {
            return nil
        }
        return String(string[range])
    }
}
