# Changelog

## Version 4.0.0
- Support Retention Messaging API [https://github.com/apple/app-store-server-library-swift/pull/101]
  - This changes internal details of AppStoreServerAPIClient, which is a breaking change for subclassing clients
- Incorporate changes for App Store Server API v1.17 [https://github.com/apple/app-store-server-library-swift/pull/102] from @riyazpanjwani
- Add a new VerificationError case for retryable OCSP network failures [https://github.com/apple/app-store-server-library-swift/pull/104]
- Incorporate changes for App Store Server API v1.18 [https://github.com/apple/app-store-server-library-swift/pull/106] from @izanger
  - This changes OfferType's case subscriptionOfferCode to offerCode, which is a breaking change
- Fix Base64URL decoding [https://github.com/apple/app-store-server-library-swift/pull/107] from @shimastripe

## Version 3.1.0
- Incorporate changes for App Store Server API v1.16 [https://github.com/apple/app-store-server-library-swift/pull/89]
- Update Swift docs to v6 [https://github.com/apple/app-store-server-library-swift/pull/85]

## Version 3.0.0
- Incorporate changes for App Store Server API v1.15 and App Store Server Notifications v2.15 [https://github.com/apple/app-store-server-library-swift/pull/82]
- Add verified chain caching to improve performance [https://github.com/apple/app-store-server-library-swift/pull/80]
- Rename Environment -> AppStoreEnvironment [https://github.com/apple/app-store-server-library-swift/pull/81]
  - This change is a breaking change
- Rename Data -> NotificationData to deconflict with Foundation.Data [https://github.com/apple/app-store-server-library-swift/pull/79]
  - This change is a breaking change
- Move to Swift and Swift Tools Version 6 [https://github.com/apple/app-store-server-library-swift/pull/78]
  - This change is a breaking change
- Update to JWTKit5 [https://github.com/apple/app-store-server-library-swift/pull/68] from @dimitribouniol
- Make data models conform to Sendable [https://github.com/apple/app-store-server-library-swift/pull/64] from @shimastripe

## Version 2.3.0
- Incorporate changes for App Store Server API v1.13 and App Store Server Notifications v2.13 [https://github.com/apple/app-store-server-library-swift/pull/61]
- Resolve issue where a Date passed as an input that contained a microsecond portiion would cause an API exception [https://github.com/apple/app-store-server-library-swift/pull/62]

## Version 2.2.0
- Incorporate changes for App Store Server API v1.12 and App Store Server Notifications v2.12 [https://github.com/apple/app-store-server-library-swift/pull/57]
- Improve README installation code [https://github.com/apple/app-store-server-library-swift/pull/56] from @philmodin
- Handle null appAccountToken appropriately in PromotionalOfferSignatureCreator and update JSON parsing logic to follow standard patterns [https://github.com/apple/app-store-server-library-java/pull/100]

## Version 2.1.0
- Incorporate changes for App Store Server API v1.11 and App Store Server Notifications v2.11 [https://github.com/apple/app-store-server-library-swift/pull/49]
- Various documentation and quality of life improvements, including contributions from @Fidetro

## Version 2.0.0
- Incorporate changes for App Store Server API v1.10.1 [https://github.com/apple/app-store-server-library-swift/pull/42]
  - This change is a breaking change, as the datatype of the price field has changed from Int32? to Int64?

## Version 1.1.0
- Support App Store Server Notifications v2.10 [https://github.com/apple/app-store-server-library-swift/pull/37]
- Require appAppleId in SignedDataVerifier for the Production environment from @shimastripe [https://github.com/apple/app-store-server-library-swift/pull/35]

## Version 1.0.2
- Limit platforms to supported platforms [https://github.com/apple/app-store-server-library-swift/pull/29]

## Version 1.0.1
- Add public constructors to all models [https://github.com/apple/app-store-server-library-swift/pull/26]

## Version 1.0.0
- Add status field to the data model [https://github.com/apple/app-store-server-library-swift/pull/7]
- Adding new error codes from App Store Server API v1.9 [https://github.com/apple/app-store-server-library-swift/pull/9]
- Adding new fields from App Store Server API v1.10 [https://github.com/apple/app-store-server-library-swift/pull/12]
- Migrate to AsyncHTTPClient [https://github.com/apple/app-store-server-library-swift/pull/15]
- Add support for LocalTesting and Xcode environments [https://github.com/apple/app-store-server-library-swift/pull/19]
- Allow reading unknown enum values [https://github.com/apple/app-store-server-library-swift/pull/20]
- Add errorMessage to APIException [https://github.com/apple/app-store-server-library-swift/pull/21]
