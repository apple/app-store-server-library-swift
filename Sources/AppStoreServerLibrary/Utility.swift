// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation

internal func base64URLToBase64(_ encodedString: String) -> String {
    let replacedString = encodedString
        .replacingOccurrences(of: "/", with: "+")
        .replacingOccurrences(of: "_", with: "-")
    if (replacedString.count % 4 != 0) {
        return replacedString + String(repeating: "=", count: 4 - replacedString.count % 4)
    }
    return replacedString
}

internal func getJsonDecoder() -> JSONDecoder  {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    return decoder
}

internal func getJsonEncoder() -> JSONEncoder  {
    let decoder = JSONEncoder()
    decoder.dateEncodingStrategy = .millisecondsSince1970
    return decoder
}
