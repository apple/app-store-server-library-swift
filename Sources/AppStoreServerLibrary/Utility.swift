// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

internal func base64URLToBase64(_ encodedString: String) -> String {
    let replacedString = encodedString
        .replacingOccurrences(of: "/", with: "+")
        .replacingOccurrences(of: "_", with: "-")
    if (replacedString.count % 4 != 0) {
        return replacedString + String(repeating: "=", count: 4 - replacedString.count % 4)
    }
    return replacedString
}

internal func getJsonDecoder() -> JSONDecoder  {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    decoder.keyDecodingStrategy = .custom { keys in
        return RawValueCodingKey(decodingKey: keys.last!)
    }
    return decoder
}

internal func getJsonEncoder() -> JSONEncoder  {
    let decoder = JSONEncoder()
    decoder.dateEncodingStrategy = .millisecondsSince1970
    decoder.keyEncodingStrategy = .custom { keys in
        return RawValueCodingKey(encodingKey: keys.last!)
    }
    return decoder
}

private struct RawValueCodingKey: CodingKey {
    
    private static let keysToRawKeys = ["environment": "rawEnvironment", "receiptType": "rawReceiptType",  "consumptionStatus": "rawConsumptionStatus", "platform": "rawPlatform", "deliveryStatus": "rawDeliveryStatus", "accountTenure": "rawAccountTenure", "playTime": "rawPlayTime", "lifetimeDollarsRefunded": "rawLifetimeDollarsRefunded", "lifetimeDollarsPurchased": "rawLifetimeDollarsPurchased", "userStatus": "rawUserStatus", "status": "rawStatus", "expirationIntent": "rawExpirationIntent", "priceIncreaseStatus": "rawPriceIncreaseStatus", "offerType": "rawOfferType", "type": "rawType", "inAppOwnershipType": "rawInAppOwnershipType", "revocationReason": "rawRevocationReason", "transactionReason": "rawTransactionReason", "offerDiscountType": "rawOfferDiscountType", "notificationType": "rawNotificationType", "subtype": "rawSubtype", "sendAttemptResult": "rawSendAttemptResult", "autoRenewStatus": "rawAutoRenewStatus"]
    private static let rawKeysToKeys = ["rawEnvironment": "environment", "rawReceiptType": "receiptType",  "rawConsumptionStatus": "consumptionStatus", "rawPlatform": "platform", "rawDeliveryStatus": "deliveryStatus", "rawAccountTenure": "accountTenure", "rawPlayTime": "playTime", "rawLifetimeDollarsRefunded": "lifetimeDollarsRefunded", "rawLifetimeDollarsPurchased": "lifetimeDollarsPurchased", "rawUserStatus": "userStatus", "rawStatus": "status", "rawExpirationIntent": "expirationIntent", "rawPriceIncreaseStatus": "priceIncreaseStatus", "rawOfferType": "offerType", "rawType": "type", "rawInAppOwnershipType": "inAppOwnershipType", "rawRevocationReason": "revocationReason", "rawTransactionReason": "transactionReason", "rawOfferDiscountType": "offerDiscountType", "rawNotificationType": "notificationType", "rawSubtype": "subtype", "rawSendAttemptResult": "sendAttemptResult", "rawAutoRenewStatus": "autoRenewStatus"]
    
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
    
    init(decodingKey: CodingKey) {
        let decodingKeyString = decodingKey.stringValue
        self.stringValue = RawValueCodingKey.keysToRawKeys[decodingKeyString, default: decodingKeyString]
        self.intValue = nil
    }
    
    init(encodingKey: CodingKey) {
        let encodingKeyString = encodingKey.stringValue
        self.stringValue = RawValueCodingKey.rawKeysToKeys[encodingKeyString, default: encodingKeyString]
        self.intValue = nil
    }
}
