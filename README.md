# Apple App Store Server Swift Library
The Swift server library for the [App Store Server API](https://developer.apple.com/documentation/appstoreserverapi) and [App Store Server Notifications](https://developer.apple.com/documentation/appstoreservernotifications). Also available in [Java](https://github.com/apple/app-store-server-library-java), [Python](https://github.com/apple/app-store-server-library-python), and [Node.js](https://github.com/apple/app-store-server-library-node).

## Table of Contents
1. [Installation](#installation)
2. [Documentation](#documentation)
3. [Usage](#usage)
4. [Support](#support)

## Installation

### Swift Package Manager
Add the following dependency
```swift
.package(url: "https://github.com/apple/app-store-server-library-swift.git", .upToNextMinor(from: "2.3.0")),
```

## Documentation

[Documentation](https://apple.github.io/app-store-server-library-swift/documentation/appstoreserverlibrary/)

[WWDC Video](https://developer.apple.com/videos/play/wwdc2023/10143/)

### Obtaining an In-App Purchase key from App Store Connect

To use the App Store Server API or create promotional offer signatures, a signing key downloaded from App Store Connect is required. To obtain this key, you must have the Admin role. Go to Users and Access > Integrations > In-App Purchase. Here you can create and manage keys, as well as find your issuer ID. When using a key, you'll need the key ID and issuer ID as well.

### Obtaining Apple Root Certificates

Download and store the root certificates found in the Apple Root Certificates section of the [Apple PKI](https://www.apple.com/certificateauthority/) site. Provide these certificates as an array to a SignedDataVerifier to allow verifying the signed data comes from Apple.

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
case .failure(let errorCode, let rawApiError, let apiError, let errorMessage, let causedBy):
    print(errorCode)
    print(rawApiError)
    print(apiError)
    print(errorMessage)
    print(causedBy)
}
```

### Verification Usage

```swift
import AppStoreServerLibrary

let bundleId = "com.example"
let appleRootCAs = loadRootCAs() // Specific implementation may vary
let appAppleId: Int64? = nil // appAppleId must be provided for the Production environment
let enableOnlineChecks = true
let environment = Environment.sandbox

// try! used for example purposes only
let verifier = try! SignedDataVerifier(rootCertificates: appleRootCAs, bundleId: bundleId, appAppleId: appAppleId, environment: environment, enableOnlineChecks: enableOnlineChecks)

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
let environment = Environment.sandbox

// try! used for example purposes only
let client = try! AppStoreServerAPIClient(signingKey: encodedKey, keyId: keyId, issuerId: issuerId, bundleId: bundleId, environment: environment)

let appReceipt = "MI..."
let transactionIdOptional = ReceiptUtility.extractTransactionId(appReceipt: appReceipt)
if let transactionId = transactionIdOptional {
    var transactionHistoryRequest = TransactionHistoryRequest()
    transactionHistoryRequest.sort = TransactionHistoryRequest.Order.ascending
    transactionHistoryRequest.revoked = false
    transactionHistoryRequest.productTypes = [TransactionHistoryRequest.ProductType.autoRenewable]

    var response: HistoryResponse?
    var transactions: [String] = []
    repeat {
        let revisionToken = response?.revision
        let apiResponse = await client.getTransactionHistory(transactionId: transactionId, revision: revisionToken, transactionHistoryRequest: transactionHistoryRequest)
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
