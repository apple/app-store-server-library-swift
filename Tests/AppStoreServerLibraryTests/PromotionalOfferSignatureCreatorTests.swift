// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import X509

final class PromotionalOfferSignatureCreatorTests: XCTestCase {

    public func testSignatureCreator() throws {
        let key = TestingUtility.readFile("resources/certs/testSigningKey.p8")
        
        let signatureCreator = try PromotionalOfferSignatureCreator(privateKey: key, keyId: "keyId", bundleId: "bundleId")
        let signature = try signatureCreator.createSignature(productIdentifier: "productId", subscriptionOfferID: "offerId", applicationUsername: "applicationUsername", nonce: UUID(uuidString: "20fba8a0-2b80-4a7d-a17f-85c1854727f8")!, timestamp: 1698148900000)
        XCTAssertNotNil(signature)
    }
}
