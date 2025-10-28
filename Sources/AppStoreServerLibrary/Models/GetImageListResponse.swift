// Copyright (c) 2025 Apple Inc. Licensed under MIT License.

import Foundation

///A response that contains status information for all images.
///
///[GetImageListResponse](https://developer.apple.com/documentation/retentionmessaging/getimagelistresponse)
public struct GetImageListResponse: Decodable, Encodable, Hashable, Sendable {

    public init(imageIdentifiers: [GetImageListResponseItem]? = nil) {
        self.imageIdentifiers = imageIdentifiers
    }

    ///An array of all image identifiers and their image state.
    ///
    ///[GetImageListResponseItem](https://developer.apple.com/documentation/retentionmessaging/getimagelistresponseitem)
    public var imageIdentifiers: [GetImageListResponseItem]?
}
