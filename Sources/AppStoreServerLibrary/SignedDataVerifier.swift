// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

///A verifier and decoder class designed to decode signed data from the App Store.
public struct SignedDataVerifier: Sendable {

    public enum ConfigurationError: Error, Hashable, Sendable {
        case INVALID_APP_APPLE_ID
    }

    private var bundleId: String
    private var appAppleId: Int64?
    private var environment: AppStoreEnvironment
    private var chainVerifier: ChainVerifier
    private var enableOnlineChecks: Bool
     
    /// - Parameter rootCertificates: The set of Apple Root certificate authority certificates, as found on [Apple PKI](https://www.apple.com/certificateauthority/)
    /// - Parameter bundleId: The: bundle identifier of the app.
    /// - Parameter appAppleId: The unique identifier of the app in the App Store.
    /// - Parameter environment: The server environment, either sandbox or production.
    /// - Parameter enableOnlineChecks: Whether to enable revocation checking and check expiration using the current date
    /// - Throws: When the root certificates are malformed
    public init(rootCertificates: [Data], bundleId: String, appAppleId: Int64?, environment: AppStoreEnvironment, enableOnlineChecks: Bool) throws {

        guard !(environment == .production && appAppleId == nil) else {
            throw ConfigurationError.INVALID_APP_APPLE_ID
        }

        self.bundleId = bundleId
        self.appAppleId = appAppleId
        self.environment = environment
        self.chainVerifier = try ChainVerifier(rootCertificates: rootCertificates)
        self.enableOnlineChecks = enableOnlineChecks
    }
    /// Verifies and decodes a signedRenewalInfo obtained from the App Store Server API, an App Store Server Notification, or from a device
    /// See [JWSRenewalInfo](https://developer.apple.com/documentation/appstoreserverapi/jwsrenewalinfo)
    ///
    ///  - Parameter signedRenewalInfo The signedRenewalInfo field
    ///  - Returns: If success, the decoded renewal info after verification, else the reason for verification failure
    public func verifyAndDecodeRenewalInfo(signedRenewalInfo: String) async -> VerificationResult<JWSRenewalInfoDecodedPayload> {
        let renewalInfoResult = await decodeSignedData(signedData: signedRenewalInfo, type: JWSRenewalInfoDecodedPayload.self)
        switch renewalInfoResult {
        case .valid(let renewalInfo):
            if self.environment != renewalInfo.environment {
                return VerificationResult.invalid(VerificationError.INVALID_ENVIRONMENT)
            }
        case .invalid(_):
            break
        }
        return renewalInfoResult
    }
    ///  Verifies and decodes a signedTransaction obtained from the App Store Server API, an App Store Server Notification, or from a device
    ///  See [JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    ///
    ///  - Parameter signedTransaction The signedTransaction field
    ///  - Returns: If success, the decoded transaction info after verification, else the reason for verification failure
    public func verifyAndDecodeTransaction(signedTransaction: String) async -> VerificationResult<JWSTransactionDecodedPayload> {
        let transactionResult = await decodeSignedData(signedData: signedTransaction, type: JWSTransactionDecodedPayload.self)
        switch transactionResult {
        case .valid(let transaction):
            if self.bundleId != transaction.bundleId {
                return VerificationResult.invalid(VerificationError.INVALID_APP_IDENTIFIER)
            }
            if self.environment != transaction.environment {
                return VerificationResult.invalid(VerificationError.INVALID_ENVIRONMENT)
            }
        case .invalid(_):
            break
        }
        return transactionResult
    }
    ///  Verifies and decodes an App Store Server Notification signedPayload
    ///  See [signedPayload](https://developer.apple.com/documentation/appstoreservernotifications/signedpayload)
    ///
    ///  - Parameter signedPayload The payload received by your server
    ///  - Returns: If success, the decoded payload after verification, else the reason for verification failure
    public func verifyAndDecodeNotification(signedPayload: String) async -> VerificationResult<ResponseBodyV2DecodedPayload> {
        return await verifyAndDecodeNotification(signedPayload: signedPayload, validateNotification: self.verifyNotificationAppIdentifierAndEnvironment)
    }
        
    internal func verifyAndDecodeNotification(signedPayload: String, validateNotification: (_ appBundleID: String?, _ appAppleID: Int64?, _ environment: AppStoreEnvironment?) -> VerificationError?) async -> VerificationResult<ResponseBodyV2DecodedPayload> {
        let notificationResult = await decodeSignedData(signedData: signedPayload, type: ResponseBodyV2DecodedPayload.self)
        switch notificationResult {
        case .valid(let notification):
            let appAppleId: Int64?
            let bundleId : String?
            let environment: AppStoreEnvironment?
            if let data = notification.data {
                appAppleId = data.appAppleId
                bundleId = data.bundleId
                environment = data.environment
            } else if let summary = notification.summary {
                appAppleId = summary.appAppleId
                bundleId = summary.bundleId
                environment = summary.environment
            } else if let externalPurchaseToken = notification.externalPurchaseToken {
                appAppleId = externalPurchaseToken.appAppleId
                bundleId = externalPurchaseToken.bundleId
                if externalPurchaseToken.externalPurchaseId?.starts(with: "SANDBOX") == true {
                    environment = .sandbox
                } else {
                    environment = .production
                }
            } else {
                appAppleId = nil
                bundleId = nil
                environment = nil
            }
            if let result = validateNotification(bundleId, appAppleId, environment) {
                return .invalid(result)
            }
        case .invalid(_):
            break
        }
        return notificationResult
    }

    internal func verifyNotificationAppIdentifierAndEnvironment(bundleId: String?, appAppleId: Int64?, environment: AppStoreEnvironment?) -> VerificationError? {
        if self.bundleId != bundleId || (self.environment == .production && self.appAppleId != appAppleId) {
            return .INVALID_APP_IDENTIFIER
        }
        if self.environment != environment {
            return .INVALID_ENVIRONMENT
        }
        return nil
    }
    
    ///Verifies and decodes a signed AppTransaction
    ///See [AppTransaction](https://developer.apple.com/documentation/storekit/apptransaction)
    ///
    ///- Parameter signedAppTransaction The signed AppTransaction
    ///- Returns: If success, the decoded AppTransaction after validation, else the reason for verification failure
    public func verifyAndDecodeAppTransaction(signedAppTransaction: String) async -> VerificationResult<AppTransaction> {
        let appTransactionResult = await decodeSignedData(signedData: signedAppTransaction, type: AppTransaction.self)
        switch appTransactionResult {
        case .valid(let appTransaction):
            let environment = appTransaction.receiptType
            if self.bundleId != appTransaction.bundleId || (self.environment == .production && self.appAppleId != appTransaction.appAppleId) {
                return VerificationResult.invalid(VerificationError.INVALID_APP_IDENTIFIER)
            }
            if self.environment != environment {
                return VerificationResult.invalid(VerificationError.INVALID_ENVIRONMENT)
            }
        case .invalid(_):
            break
        }
        return appTransactionResult
    }
    
    private func decodeSignedData<T: DecodedSignedData>(signedData: String, type: T.Type) async -> VerificationResult<T> where T : Decodable & Sendable {
        return await chainVerifier.verify(signedData: signedData, type: type, onlineVerification: self.enableOnlineChecks, environment: self.environment)
    }
}
