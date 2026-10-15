// Copyright (c) 2023 Apple Inc. Licensed under MIT License.


public struct ErrorPayload: Decodable, Encodable, Hashable, Sendable {

    public init(errorCode: Int64? = nil, errorMessage: String? = nil) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }

    public var errorCode: Int64?
    public var errorMessage: String?
}
