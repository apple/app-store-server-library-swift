// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///The request body that contains consumption information for an In-App Purchase.
///
///[ConsumptionRequest](https://developer.apple.com/documentation/appstoreserverapi/consumptionrequest)
public struct ConsumptionRequest: Decodable, Encodable, Hashable, Sendable {

    public init(customerConsented: Bool, deliveryStatus: DeliveryStatus, sampleContentProvided: Bool, consumptionPercentage: Int32? = nil, refundPreference: RefundPreference? = nil) {
        self.customerConsented = customerConsented
        self.sampleContentProvided = sampleContentProvided
        self.consumptionPercentage = consumptionPercentage
        self.rawDeliveryStatus = deliveryStatus.rawValue
        self.rawRefundPreference = refundPreference?.rawValue
    }

    public init(customerConsented: Bool, rawDeliveryStatus: String, sampleContentProvided: Bool, consumptionPercentage: Int32? = nil, rawRefundPreference: String? = nil) {
        self.customerConsented = customerConsented
        self.rawDeliveryStatus = rawDeliveryStatus
        self.sampleContentProvided = sampleContentProvided
        self.consumptionPercentage = consumptionPercentage
        self.rawRefundPreference = rawRefundPreference
    }

    ///A Boolean value that indicates whether the customer consented to provide consumption data to the App Store.
    ///
    ///[customerConsented](https://developer.apple.com/documentation/appstoreserverapi/customerconsented)
    public var customerConsented: Bool

    ///An integer that indicates the percentage, in milliunits, of the In-App Purchase the customer consumed.
    ///
    ///[consumptionPercentage](https://developer.apple.com/documentation/appstoreserverapi/consumptionpercentage)
    public var consumptionPercentage: Int32?

    ///A value that indicates whether the app successfully delivered an In-App Purchase that works properly.
    ///
    ///[deliveryStatus](https://developer.apple.com/documentation/appstoreserverapi/deliverystatus)
    public var deliveryStatus: DeliveryStatus? {
        get {
            return rawDeliveryStatus.flatMap { DeliveryStatus(rawValue: $0) }
        }
        set {
            self.rawDeliveryStatus = newValue.map { $0.rawValue }
        }
    }

    ///See ``deliveryStatus``
    public var rawDeliveryStatus: String?

    ///A value that indicates your preferred outcome for the refund request.
    ///
    ///[refundPreference](https://developer.apple.com/documentation/appstoreserverapi/refundpreference)
    public var refundPreference: RefundPreference? {
        get {
            return rawRefundPreference.flatMap { RefundPreference(rawValue: $0) }
        }
        set {
            self.rawRefundPreference = newValue.map { $0.rawValue }
        }
    }

    ///See ``refundPreference``
    public var rawRefundPreference: String?

    ///A Boolean value that indicates whether you provided, prior to its purchase, a free sample or trial of the content, or information about its functionality.
    ///
    ///[sampleContentProvided](https://developer.apple.com/documentation/appstoreserverapi/samplecontentprovided)
    public var sampleContentProvided: Bool

    public enum CodingKeys: CodingKey {
        case customerConsented
        case consumptionPercentage
        case deliveryStatus
        case refundPreference
        case sampleContentProvided
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.customerConsented = try container.decode(Bool.self, forKey: .customerConsented)
        self.consumptionPercentage = try container.decodeIfPresent(Int32.self, forKey: .consumptionPercentage)
        self.rawDeliveryStatus = try container.decode(String.self, forKey: .deliveryStatus)
        self.rawRefundPreference = try container.decodeIfPresent(String.self, forKey: .refundPreference)
        self.sampleContentProvided = try container.decode(Bool.self, forKey: .sampleContentProvided)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.customerConsented, forKey: .customerConsented)
        try container.encodeIfPresent(self.consumptionPercentage, forKey: .consumptionPercentage)
        try container.encodeIfPresent(self.rawDeliveryStatus, forKey: .deliveryStatus)
        try container.encodeIfPresent(self.rawRefundPreference, forKey: .refundPreference)
        try container.encode(self.sampleContentProvided, forKey: .sampleContentProvided)
    }
}
