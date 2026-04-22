// Copyright (c) 2026 Apple Inc. Licensed under MIT License.

///The request data your app provides when a customer purchases a one-time-charge product.
///
///[OneTimeChargeCreateRequest](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargecreaterequest)
public struct AdvancedCommerceOneTimeChargeCreateRequest: AdvancedCommerceInAppRequest, Decodable, Hashable, Sendable {

    public init(currency: String, item: AdvancedCommerceOneTimeChargeItem, requestInfo: AdvancedCommerceRequestInfo, taxCode: String, storefront: String? = nil) {
        self.currency = currency
        self.item = item
        self.requestInfo = requestInfo
        self.taxCode = taxCode
        self.storefront = storefront
    }

    ///The currency of the price of the product.
    ///
    ///[currency](https://developer.apple.com/documentation/advancedcommerceapi/currency)
    public var currency: String

    ///The details of the product for purchase.
    ///
    ///[OneTimeChargeItem](https://developer.apple.com/documentation/advancedcommerceapi/onetimechargeitem)
    public var item: AdvancedCommerceOneTimeChargeItem

    ///The constant that represents the operation of this request.
    private var operation: String {
        return "CREATE_ONE_TIME_CHARGE"
    }

    ///The metadata to include in server requests.
    ///
    ///[RequestInfo](https://developer.apple.com/documentation/advancedcommerceapi/requestinfo)
    public var requestInfo: AdvancedCommerceRequestInfo

    ///The storefront for the transaction.
    ///
    ///[storefront](https://developer.apple.com/documentation/advancedcommerceapi/storefront)
    public var storefront: String?

    ///The tax code for this product.
    ///
    ///[taxCode](https://developer.apple.com/documentation/advancedcommerceapi/taxCode)
    public var taxCode: String

    ///The version number of the API.
    private var version: String {
        return "1"
    }

    public enum CodingKeys: String, CodingKey {
        case currency
        case item
        case operation
        case requestInfo
        case storefront
        case taxCode
        case version
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.item = try container.decode(AdvancedCommerceOneTimeChargeItem.self, forKey: .item)
        self.requestInfo = try container.decode(AdvancedCommerceRequestInfo.self, forKey: .requestInfo)
        self.storefront = try container.decodeIfPresent(String.self, forKey: .storefront)
        self.taxCode = try container.decode(String.self, forKey: .taxCode)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.currency, forKey: .currency)
        try container.encode(self.item, forKey: .item)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.requestInfo, forKey: .requestInfo)
        try container.encodeIfPresent(self.storefront, forKey: .storefront)
        try container.encode(self.taxCode, forKey: .taxCode)
        try container.encode(self.version, forKey: .version)
    }
}
