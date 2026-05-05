// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

import Foundation

///[RenewalCommitmentInfo](https://developer.apple.com/documentation/appstoreserverapi/renewalcommitmentinfo)
public struct RenewalCommitmentInfo: Decodable, Encodable, Hashable, Sendable {

    public init(commitmentAutoRenewProductId: String? = nil, commitmentAutoRenewStatus: AutoRenewStatus? = nil, commitmentRenewalBillingPlanType: RenewalBillingPlanType? = nil, commitmentRenewalDate: Date? = nil, commitmentRenewalPrice: Int64? = nil) {
        self.init(commitmentAutoRenewProductId: commitmentAutoRenewProductId, rawCommitmentAutoRenewStatus: commitmentAutoRenewStatus?.rawValue, rawCommitmentRenewalBillingPlanType: commitmentRenewalBillingPlanType?.rawValue, commitmentRenewalDate: commitmentRenewalDate, commitmentRenewalPrice: commitmentRenewalPrice)
    }

    public init(commitmentAutoRenewProductId: String? = nil, rawCommitmentAutoRenewStatus: Int32? = nil, rawCommitmentRenewalBillingPlanType: String? = nil, commitmentRenewalDate: Date? = nil, commitmentRenewalPrice: Int64? = nil) {
        self.commitmentAutoRenewProductId = commitmentAutoRenewProductId
        self.rawCommitmentAutoRenewStatus = rawCommitmentAutoRenewStatus
        self.rawCommitmentRenewalBillingPlanType = rawCommitmentRenewalBillingPlanType
        self.commitmentRenewalDate = commitmentRenewalDate
        self.commitmentRenewalPrice = commitmentRenewalPrice
    }

    ///[commitmentAutoRenewProductId](https://developer.apple.com/documentation/appstoreserverapi/commitmentautorenewproductid)
    public var commitmentAutoRenewProductId: String?

    ///[commitmentAutoRenewStatus](https://developer.apple.com/documentation/appstoreserverapi/commitmentautorenewstatus)
    public var commitmentAutoRenewStatus: AutoRenewStatus? {
        get {
            return rawCommitmentAutoRenewStatus.flatMap { AutoRenewStatus(rawValue: $0) }
        }
        set {
            self.rawCommitmentAutoRenewStatus = newValue.map { $0.rawValue }
        }
    }

    ///See ``commitmentAutoRenewStatus``
    public var rawCommitmentAutoRenewStatus: Int32?

    ///[commitmentRenewalBillingPlanType](https://developer.apple.com/documentation/appstoreserverapi/commitmentrenewalbillingplantype)
    public var commitmentRenewalBillingPlanType: RenewalBillingPlanType? {
        get {
            return rawCommitmentRenewalBillingPlanType.flatMap { RenewalBillingPlanType(rawValue: $0) }
        }
        set {
            self.rawCommitmentRenewalBillingPlanType = newValue.map { $0.rawValue }
        }
    }

    ///See ``commitmentRenewalBillingPlanType``
    public var rawCommitmentRenewalBillingPlanType: String?

    ///[commitmentRenewalDate](https://developer.apple.com/documentation/appstoreserverapi/commitmentrenewaldate)
    public var commitmentRenewalDate: Date?

    ///[commitmentRenewalPrice](https://developer.apple.com/documentation/appstoreserverapi/commitmentrenewalprice)
    public var commitmentRenewalPrice: Int64?

    public enum CodingKeys: CodingKey {
        case commitmentAutoRenewProductId
        case commitmentAutoRenewStatus
        case commitmentRenewalBillingPlanType
        case commitmentRenewalDate
        case commitmentRenewalPrice
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commitmentAutoRenewProductId = try container.decodeIfPresent(String.self, forKey: .commitmentAutoRenewProductId)
        self.rawCommitmentAutoRenewStatus = try container.decodeIfPresent(Int32.self, forKey: .commitmentAutoRenewStatus)
        self.rawCommitmentRenewalBillingPlanType = try container.decodeIfPresent(String.self, forKey: .commitmentRenewalBillingPlanType)
        self.commitmentRenewalDate = try container.decodeIfPresent(Date.self, forKey: .commitmentRenewalDate)
        self.commitmentRenewalPrice = try container.decodeIfPresent(Int64.self, forKey: .commitmentRenewalPrice)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.commitmentAutoRenewProductId, forKey: .commitmentAutoRenewProductId)
        try container.encodeIfPresent(self.rawCommitmentAutoRenewStatus, forKey: .commitmentAutoRenewStatus)
        try container.encodeIfPresent(self.rawCommitmentRenewalBillingPlanType, forKey: .commitmentRenewalBillingPlanType)
        try container.encodeIfPresent(self.commitmentRenewalDate, forKey: .commitmentRenewalDate)
        try container.encodeIfPresent(self.commitmentRenewalPrice, forKey: .commitmentRenewalPrice)
    }
}
