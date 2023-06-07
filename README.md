# Apple App Store Server Swift Library
The Swift server library for the [App Store Server API](https://developer.apple.com/documentation/appstoreserverapi) and [App Store Server Notifications](https://developer.apple.com/documentation/appstoreservernotifications)

## Table of Contents
1. [Beta](#-beta-)
2. [Installation](#installation)
3. [Documentation](#documentation)
4. [Usage](#usage)
5. [Support](#support)

## ⚠️ Beta ⚠️

This software is currently in Beta testing. Therefore, it should only be used for testing purposes, like for the Sandbox environment. API signatures may change between releases and signature verification may receive security updates.

## Installation

### Swift Package Manager
```swift
Add the following dependency

.package(url: "https://github.com/apple/app-store-server-library-swift.git", .upToNextMinor(from: "0.1.0")),
```

## Documentation

[Documentation](https://apple.github.io/app-store-server-library-swift/documentation/appstoreserverlibrary/)

[WWDC Video](https://developer.apple.com/videos/play/wwdc2023/10143/)
## Usage

### API Usage

```swift
import AppStoreServerLibrary

let issuerId = "99b16628-15e4-4668-972b-eeff55eeff55"
let keyId = "ABCDEFGHIJ"
let bundleId = "com.example"
let encodedKey = try! String(contentsOfFile: "/path/to/key/SubscriptionKey_ABCDEFGHIJ.p8")
let environment = Environment.sandbox

// try! used for example purposes only
let client = try! AppStoreServerAPIClient(signingKey: encodedKey, keyId: keyId, issuerId: issuerId, bundleId: bundleId, environment: environment)

let response = await client.requestTestNotification()
switch response {
case .success(let response):
    print(response.testNotificationToken)
case .failure(let errorCode, let apiError, let causedBy):
    print(errorCode)
    print(apiError)
    print(causedBy)
}
```

### Verification Usage

```swift
import AppStoreServerLibrary

let bundleId = "com.example"
let appleRootCAs = loadRootCAs() // Specific implementation may vary
let enableOnlineChecks = true
let environment = Environment.sandbox

// try! used for example purposes only
let verifier = try! SignedDataVerifier(rootCertificates: appleRootCAs, bundleId: bundleId, appAppleId: nil, environment: environment, enableOnlineChecks: enableOnlineChecks)

let notificationPayload = "ey..."
let notificationResult = await verifier.verifyAndDecodeNotification(signedPayload: notificationPayload)
switch notificationResult {
case .valid(let decodedNotificaiton):
    ...
case .invalid(let error):
    ...
}
```

### Receipt Usage

```swift
import AppStoreServerLibrary

let issuerId = "99b16628-15e4-4668-972b-eeff55eeff55"
let keyId = "ABCDEFGHIJ"
let bundleId = "com.example"
let encodedKey = try! String(contentsOfFile: "/path/to/key/SubscriptionKey_ABCDEFGHIJ.p8")
let environment = Environment.SANDBOX

// try! used for example purposes only
let client = try! AppStoreServerAPIClient(signingKey: encodedKey, keyId: keyId, issuerId: issuerId, bundleId: bundleId, environment: environment)

let appReceipt = "MI..."
let receiptUtil = ReceiptUtility()
let transactionIdOptional = receiptUtil.extractTransactionId(appReceipt: appReceipt)
if let transactionId = transactionIdOptional {
    var transactionHistoryRequest = TransactionHistoryRequest()
    transactionHistoryRequest.sort = TransactionHistoryRequest.Order.ascending
    transactionHistoryRequest.revoked = false
    transactionHistoryRequest.productTypes = [TransactionHistoryRequest.ProductType.autoRenewable]

    var response: HistoryResponse?
    var transactions: [String] = []
    repeat {
        let revisionToken = response?.revision
        let apiResponse = await client.getTransactionHistory(originalTransactionId: transactionId, revision: revisionToken, transactionHistoryRequest: transactionHistoryRequest)
        switch apiResponse {
        case .success(let successfulResponse):
            response = successfulResponse
        case .failure:
            // Handle Failure
            throw
        }
        if let signedTransactions = response?.signedTransactions {
            transactions.append(contentsOf: signedTransactions)
        }
    } while (response?.hasMore ?? false)
    print(transactions)
}
```

### Promotional Offer Signature Creation

```swift
import AppStoreServerLibrary

let keyId = "ABCDEFGHIJ"
let bundleId = "com.example"
let encodedKey = try! String(contentsOfFile: "/path/to/key/SubscriptionKey_ABCDEFGHIJ.p8")

let productId = "<product_id>"
let subscriptionOfferId = "<subscription_offer_id>"
let applicationUsername = "<application_username>"

// try! used for example purposes only
let signatureCreator = try! PromotionalOfferSignatureCreator(privateKey: encodedKey, keyId: keyId, bundleId: bundleId)

let nonce = UUID()
let timestamp = Int64(Date().timeIntervalSince1970) * 1000
let signature = signatureCreator.createSignature(productIdentifier: productIdentifier, subscriptionOfferID: subscriptionOfferID, applicationUsername: applicationUsername, nonce: nonce, timestamp: timestamp)
print(signature)
```

## Support

Only the latest major version of the library will receive updates, including security updates. Therefore, it is recommended to update to new major versions.
