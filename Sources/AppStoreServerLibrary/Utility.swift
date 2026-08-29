// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

internal func getJsonDecoder() -> JSONDecoder  {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    return decoder
}

internal func getJsonEncoder() -> JSONEncoder  {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .custom({ date, e in
        // To encode the same as millisecondsSince1970, however truncating the decimal part
        var container = e.singleValueContainer()
        try container.encode((date.timeIntervalSince1970 * 1000.0).rounded(.towardZero))
    })
    return encoder
}
