// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import Foundation
import JWTKit

protocol DecodedSignedData: JWTPayload {
    var signedDateOptional: Date? { get }
}
