// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request data your app provides when a customer purchases a one-time-charge product.
///
///[OneTimeChargeCreateRequest](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargecreaterequest)
public struct AdvancedCommerceOneTimeChargeCreateRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(requestInfo: AdvancedCommerceRequestInfo, currency: String, item: AdvancedCommerceOneTimeChargeItem, taxCode: String, storefront: String? = nil) {
        self.requestInfo = requestInfo
        self.currency = currency
        self.item = item
        self.taxCode = taxCode
        self.storefront = storefront
    }

    ///The metadata of the request.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///The constant that represents the operation of this request.
    ///
    ///[OneTimeChargeCreateRequest](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargecreaterequest)
    private var operation: String {
        return "CREATE_ONE_TIME_CHARGE"
    }

    ///The version number of the API.
    ///
    ///[version](https://developer.apple.com/documentation/advancedcommerceapi/version)
    private var version: String {
        return "1"
    }

    ///The currency of the price of the product.
    ///
    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String

    ///The details of the product for purchase.
    ///
    ///[OneTimeChargeItem](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargeitem)
    public var item: AdvancedCommerceOneTimeChargeItem

    ///The storefront for the transaction.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///The tax code for this product.
    ///
    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxcode)
    public var taxCode: String

    public enum CodingKeys: CodingKey {
        case requestInfo
        case operation
        case version
        case currency
        case item
        case storefront
        case taxCode
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.item = try container.decode(AdvancedCommerceOneTimeChargeItem.self, forKey: .item)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.taxCode = try container.decode(String.self, forKey: .taxCode)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.version, forKey: .version)
        try container.encode(self.currency, forKey: .currency)
        try container.encode(self.item, forKey: .item)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encode(self.taxCode, forKey: .taxCode)
    }
}
