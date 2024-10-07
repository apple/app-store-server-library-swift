// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///A response that includes the order lookup status and an array of signed transactions for the in-app purchases in the order.
///
///[OrderLookupResponse](https://developer.apple.com/documentation/appstoreserverapi/orderlookupresponse)
public struct OrderLookupResponse: Decodable, Encodable, Hashable, Sendable {
    
    public init(status: OrderLookupStatus? = nil, signedTransactions: [String]? = nil) {
        self.status = status
        self.signedTransactions = signedTransactions
    }
    
    public init(rawStatus: Int32? = nil, signedTransactions: [String]? = nil) {
        self.rawStatus = rawStatus
        self.signedTransactions = signedTransactions
    }
    
    ///The status that indicates whether the order ID is valid.
    ///
    ///[OrderLookupStatus](https://developer.apple.com/documentation/appstoreserverapi/orderlookupstatus)
    public var status: OrderLookupStatus? {
        get {
            return rawStatus.flatMap { OrderLookupStatus(rawValue: $0) }
        }
        set {
            self.rawStatus = newValue.map { $0.rawValue }
        }
    }
    
    ///See ``status``
    public var rawStatus: Int32?
    
    ///An array of in-app purchase transactions that are part of order, signed by Apple, in JSON Web Signature format.
    ///
    ///[JWSTransaction](https://developer.apple.com/documentation/appstoreserverapi/jwstransaction)
    public var signedTransactions: [String]?
    
    public enum CodingKeys: CodingKey {
        case status
        case signedTransactions
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rawStatus = try container.decodeIfPresent(Int32.self, forKey: .status)
        self.signedTransactions = try container.decodeIfPresent([String].self, forKey: .signedTransactions)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.rawStatus, forKey: .status)
        try container.encodeIfPresent(self.signedTransactions, forKey: .signedTransactions)
    }
}
