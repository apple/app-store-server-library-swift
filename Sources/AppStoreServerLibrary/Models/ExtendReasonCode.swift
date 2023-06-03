// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

///The code that represents the reason for the subscription-renewal-date extension.
///
///[extendReasonCode](https://developer.apple.com/documentation/appstoreserverapi/extendreasoncode)
public enum ExtendReasonCode: Int32, Decodable, Encodable, Hashable {
    case undeclared = 0
    case customerSatisfaction = 1
    case other = 2
    case serviceIssueOrOutage = 3
}
