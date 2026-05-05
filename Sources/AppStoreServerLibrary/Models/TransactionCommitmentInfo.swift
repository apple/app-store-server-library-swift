// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///[TransactionCommitmentInfo](https://developer.apple.com/documentation/appstoreserverapi/transactioncommitmentinfo)
public struct TransactionCommitmentInfo: Decodable, Encodable, Hashable, Sendable {

    public init(billingPeriodNumber: Int32? = nil, commitmentExpiresDate: Date? = nil, commitmentPrice: Int64? = nil, totalBillingPeriods: Int32? = nil) throws {
        if let billingPeriodNumber = billingPeriodNumber {
            self.billingPeriodNumber = try HelperValidationUtils.validatePeriodCount(billingPeriodNumber)
        } else {
            self.billingPeriodNumber = nil
        }
        self.commitmentExpiresDate = commitmentExpiresDate
        self.commitmentPrice = commitmentPrice
        self.totalBillingPeriods = totalBillingPeriods
    }

    ///[billingPeriodNumber](https://developer.apple.com/documentation/appstoreserverapi/billingperiodnumber)
    public var billingPeriodNumber: Int32?

    ///[commitmentExpiresDate](https://developer.apple.com/documentation/appstoreserverapi/commitmentexpiresdate)
    public var commitmentExpiresDate: Date?

    ///[commitmentPrice](https://developer.apple.com/documentation/appstoreserverapi/commitmentprice)
    public var commitmentPrice: Int64?

    ///[totalBillingPeriods](https://developer.apple.com/documentation/appstoreserverapi/totalbillingperiods)
    public var totalBillingPeriods: Int32?
}
