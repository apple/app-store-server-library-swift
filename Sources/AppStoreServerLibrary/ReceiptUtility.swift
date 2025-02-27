// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import SwiftASN1

public class ReceiptUtility {
    
    private static let IN_APP_TYPE_ID = Int64(17)
    private static let TRANSACTION_IDENTIFIER_TYPE_ID = Int64(1703)
    private static let ORIGINAL_TRANSACTION_IDENTIFIER_TYPE_ID = Int64(1705)
    
    ///Extracts a transaction id from an encoded App Receipt. Throws if the receipt does not match the expected format.
    ///*NO validation* is performed on the receipt, and any data returned should only be used to call the App Store Server API.
    ///- Parameter appReceipt The unmodified app receipt
    ///- Returns A transaction id from the array of in-app purchases, null if the receipt contains no in-app purchases
    public static func extractTransactionId(appReceipt: String) -> String? {
        var result: String? = nil
        if let parsedData = Data(base64Encoded: appReceipt), let parsedContainer = try? BER.parse([UInt8](parsedData)) {
            try? BER.sequence(parsedContainer, identifier: ASN1Identifier.sequence) { nodes in
                let _ = try ASN1ObjectIdentifier(berEncoded: &nodes)
                try? BER.optionalExplicitlyTagged(&nodes, tagNumber: 0, tagClass: .contextSpecific) { arrayNode in
                    try? BER.sequence(arrayNode, identifier: ASN1Identifier.sequence) { nodes in
                        var _ = nodes.next()
                        _ = nodes.next()
                        if let contentInfo = nodes.next() {
                            try? BER.sequence(contentInfo, identifier: ASN1Identifier.sequence) { nodes in
                                _ = nodes.next()
                                try? BER.optionalExplicitlyTagged(&nodes, tagNumber: 0, tagClass: .contextSpecific) { arrayNode in
                                    let content = try ASN1OctetString(berEncoded: arrayNode)
                                    result = extractTransactionIdFromAppReceiptInner(appReceiptContent: content)
                                }
                            }
                        }
                        var _ = nodes.next()
                        _ = nodes.next()
                    }
                }
            }
        }
        return result
    }
    
    private static func extractTransactionIdFromAppReceiptInner(appReceiptContent: ASN1OctetString) -> String? {
        var result: String? = nil
        if let parsedAppReceipt = try? BER.parse([UInt8](appReceiptContent.bytes)) {
            try? BER.sequence(parsedAppReceipt, identifier: ASN1Identifier.set) { nodes in
                while let node = nodes.next() {
                    try? BER.sequence(node, identifier: ASN1Identifier.sequence) { sequenceNodes in
                        if let typeEncoded = sequenceNodes.next(), sequenceNodes.next() != nil, let valueEncoded = sequenceNodes.next() {
                            let type = try? Int64(berEncoded: typeEncoded, withIdentifier: ASN1Identifier.integer)
                            let value = try? ASN1OctetString(berEncoded: valueEncoded)
                            if type == IN_APP_TYPE_ID, let unwrappedValue = value {
                                result = extractTransactionIdFromInAppReceipt(inAppReceiptContent: unwrappedValue)
                            }
                        }
                    }
                }
            }
        }
        return result
    }
    
    private static func extractTransactionIdFromInAppReceipt(inAppReceiptContent: ASN1OctetString) -> String? {
        var result: String? = nil
        if let parsedInAppReceipt = try? BER.parse([UInt8](inAppReceiptContent.bytes)) {
            try? BER.sequence(parsedInAppReceipt, identifier: ASN1Identifier.set) { nodes in
                while let node = nodes.next() {
                    try? BER.sequence(node, identifier: ASN1Identifier.sequence) { sequenceNodes in
                        if let typeEncoded = sequenceNodes.next(), sequenceNodes.next() != nil, let valueEncoded = sequenceNodes.next() {
                            let type = try? Int64(berEncoded: typeEncoded, withIdentifier: ASN1Identifier.integer)
                            let value = try? ASN1OctetString(berEncoded: valueEncoded)
                            if type == TRANSACTION_IDENTIFIER_TYPE_ID || type == ORIGINAL_TRANSACTION_IDENTIFIER_TYPE_ID, let unwrappedValue = value {
                                if let parseResult = try? BER.parse(unwrappedValue.bytes) {
                                    if let utf8String = try? ASN1UTF8String(berEncoded: parseResult, withIdentifier: .utf8String) {
                                        result =  String(utf8String)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return result
    }
    
    ///Extracts a transaction id from an encoded transactional receipt. Throws if the receipt does not match the expected format.
    ///*NO validation* is performed on the receipt, and any data returned should only be used to call the App Store Server API.
    /// - Parameter transactionReceipt The unmodified transactionReceipt
    /// - Returns A transaction id, or null if no transactionId is found in the receipt
    public static func extractTransactionId(transactionReceipt: String) -> String? {
        if let d = Data(base64Encoded: transactionReceipt), let decodedReceipt = String(bytes: d, encoding: .utf8) {
            let purchaseInfoRange = NSRange(decodedReceipt.startIndex..<decodedReceipt.endIndex, in: decodedReceipt)
            if let purchaseInfoRegex = try? NSRegularExpression(pattern: #"\"purchase-info\"\s+=\s+\"([a-zA-Z0-9+/=]+)\";"#, options: []), let purchaseInfoMatch = purchaseInfoRegex.firstMatch(in: decodedReceipt, range: purchaseInfoRange) {
                let purchaseInfoResultRange = purchaseInfoMatch.range(at: 1)
                if purchaseInfoResultRange.location != NSNotFound, let purchaseInfoRange = Range(purchaseInfoResultRange, in: decodedReceipt)
                {
                    let purchaseInfo = decodedReceipt[purchaseInfoRange]
                    if let e = Data(base64Encoded: String(purchaseInfo)), let decodedPurchaseInfo = String(bytes: e, encoding: .utf8) {
                        let transactionIdNSRange = NSRange(decodedPurchaseInfo.startIndex..<decodedPurchaseInfo.endIndex, in: decodedPurchaseInfo)
                        if let transactionIdRegex = try? NSRegularExpression(pattern: #"\"transaction-id\"\s+=\s+\"([a-zA-Z0-9+/=]+)\";"#, options: []), let transactionIdMatch = transactionIdRegex.firstMatch(in: decodedPurchaseInfo, range: transactionIdNSRange) {
                            let transactionIdResultRange = transactionIdMatch.range(at: 1)
                            if transactionIdResultRange.location != NSNotFound, let transactionIdRange = Range(transactionIdResultRange, in: decodedPurchaseInfo)
                            {
                                let transactionId = decodedPurchaseInfo[transactionIdRange]
                                return String(transactionId)
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
}
