// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The code that represents the reason for the subscription-renewal-date extension.
///
///[extendReasonCode](https://developer.apple.com/documentation/appstoreserverapi/extendreasoncode)
public enum ExtendReasonCode: Int32, Decodable, Encodable, Hashable, Sendable {
    ///Undeclared; no information provided.
    case undeclared = 0

    ///The renewal-date extension is for customer satisfaction.
    case customerSatisfaction = 1

    ///The renewal-date extension is for other reasons.
    case other = 2

    ///The renewal-date extension is due to a service issue or outage.
    case serviceIssueOrOutage = 3
}
