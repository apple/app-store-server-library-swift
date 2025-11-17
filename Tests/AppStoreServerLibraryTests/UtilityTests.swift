//
//  UtilityTests.swift
//  AppStoreServerLibrary
//
//  Created by shimastripe on 2025/11/17.
//

import XCTest
@testable import AppStoreServerLibrary

final class Base64URLToBase64Tests: XCTestCase {

    func test_noPaddingNeeded() {
        // Base64URL string of length divisible by 4 → no padding needed
        let input = "YWJjZA"
        let expected = "YWJjZA=="
        XCTAssertEqual(base64URLToBase64(input), expected)
    }

    func test_paddingOneCharacterNeeded() {
        // Length % 4 = 3 → one "=" should be added
        let input = "YWJjZGI"
        let expected = "YWJjZGI="
        XCTAssertEqual(base64URLToBase64(input), expected)
    }

    func test_paddingTwoCharactersNeeded() {
        // Length % 4 = 2 → two "=" should be added
        let input = "YWJjZA"
        let expected = "YWJjZA=="
        XCTAssertEqual(base64URLToBase64(input), expected)
    }

    func test_paddingAlreadyPresent() {
        let input = "YWJjZA=="
        let expected = "YWJjZA=="
        XCTAssertEqual(base64URLToBase64(input), expected)
    }

    func test_urlSafeCharactersAreReplaced() {
        // "-" → "+", "_" → "/"
        let input = "ab-cd_ef"
        let expected = "ab+cd/ef"
        XCTAssertEqual(base64URLToBase64(input), expected)
    }
}
