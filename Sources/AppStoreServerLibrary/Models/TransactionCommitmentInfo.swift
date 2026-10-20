// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///[TransactionCommitmentInfo](https://developer.apple.com/documentation/appstoreserverapi/transactioncommitmentinfo)
public struct TransactionCommitmentInfo: Decodable, Encodable, Hashable, Sendable {

    private static let minimumBillingPeriodNumber: Int32 = 1
    private static let maximumBillingPeriodNumber: Int32 = 12

    public enum ValidationError: Error {
        case billingPeriodNumberOutOfRange
    }

    public init(billingPeriodNumber: Int32? = nil, commitmentExpiresDate: Date? = nil, commitmentPrice: Int64? = nil, totalBillingPeriods: Int32? = nil) throws {
        if let billingPeriodNumber = billingPeriodNumber {
            guard billingPeriodNumber >= Self.minimumBillingPeriodNumber && billingPeriodNumber <= Self.maximumBillingPeriodNumber else {
                throw ValidationError.billingPeriodNumberOutOfRange
            }
        }
        self.billingPeriodNumber = billingPeriodNumber
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

    public enum CodingKeys: CodingKey {
        case billingPeriodNumber
        case commitmentExpiresDate
        case commitmentPrice
        case totalBillingPeriods
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.billingPeriodNumber = try container.decodeIfPresent(Int32.self, forKey: .billingPeriodNumber)
        self.commitmentExpiresDate = try container.decodeIfPresent(Double.self, forKey: .commitmentExpiresDate).map { Date(timeIntervalSince1970: $0 / 1000.0) }
        self.commitmentPrice = try container.decodeIfPresent(Int64.self, forKey: .commitmentPrice)
        self.totalBillingPeriods = try container.decodeIfPresent(Int32.self, forKey: .totalBillingPeriods)
        if let billingPeriodNumber = billingPeriodNumber {
            guard billingPeriodNumber >= Self.minimumBillingPeriodNumber && billingPeriodNumber <= Self.maximumBillingPeriodNumber else {
                throw ValidationError.billingPeriodNumberOutOfRange
            }
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if let billingPeriodNumber = billingPeriodNumber {
            guard billingPeriodNumber >= Self.minimumBillingPeriodNumber && billingPeriodNumber <= Self.maximumBillingPeriodNumber else {
                throw ValidationError.billingPeriodNumberOutOfRange
            }
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.billingPeriodNumber, forKey: .billingPeriodNumber)
        try container.encodeIfPresent(self.commitmentExpiresDate.map { ($0.timeIntervalSince1970 * 1000.0).rounded(.towardZero) }, forKey: .commitmentExpiresDate)
        try container.encodeIfPresent(self.commitmentPrice, forKey: .commitmentPrice)
        try container.encodeIfPresent(self.totalBillingPeriods, forKey: .totalBillingPeriods)
    }
}
