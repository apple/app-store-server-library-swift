# Changelog

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
