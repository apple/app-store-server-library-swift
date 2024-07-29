// Copyright (c) 2023 Apple Inc. Licensed under MIT License.

import XCTest
@testable import AppStoreServerLibrary

import X509

final class SignedDataVerifierTests: XCTestCase {

    private var ROOT_CA_BASE64_ENCODED = "MIIBgjCCASmgAwIBAgIJALUc5ALiH5pbMAoGCCqGSM49BAMDMDYxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRIwEAYDVQQHDAlDdXBlcnRpbm8wHhcNMjMwMTA1MjEzMDIyWhcNMzMwMTAyMjEzMDIyWjA2MQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJQ3VwZXJ0aW5vMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEc+/Bl+gospo6tf9Z7io5tdKdrlN1YdVnqEhEDXDShzdAJPQijamXIMHf8xWWTa1zgoYTxOKpbuJtDplz1XriTaMgMB4wDAYDVR0TBAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwCgYIKoZIzj0EAwMDRwAwRAIgemWQXnMAdTad2JDJWng9U4uBBL5mA7WI05H7oH7c6iQCIHiRqMjNfzUAyiu9h6rOU/K+iTR0I/3Y/NSWsXHX+acc"
    private var INTERMEDIATE_CA_BASE64_ENCODED = "MIIBnzCCAUWgAwIBAgIBCzAKBggqhkjOPQQDAzA2MQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJQ3VwZXJ0aW5vMB4XDTIzMDEwNTIxMzEwNVoXDTMzMDEwMTIxMzEwNVowRTELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRIwEAYDVQQHDAlDdXBlcnRpbm8xFTATBgNVBAoMDEludGVybWVkaWF0ZTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABBUN5V9rKjfRiMAIojEA0Av5Mp0oF+O0cL4gzrTF178inUHugj7Et46NrkQ7hKgMVnjogq45Q1rMs+cMHVNILWqjNTAzMA8GA1UdEwQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgEGMBAGCiqGSIb3Y2QGAgEEAgUAMAoGCCqGSM49BAMDA0gAMEUCIQCmsIKYs41ullssHX4rVveUT0Z7Is5/hLK1lFPTtun3hAIgc2+2RG5+gNcFVcs+XJeEl4GZ+ojl3ROOmll+ye7dynQ="
    private var LEAF_CERT_BASE64_ENCODED = "MIIBoDCCAUagAwIBAgIBDDAKBggqhkjOPQQDAzBFMQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExEjAQBgNVBAcMCUN1cGVydGlubzEVMBMGA1UECgwMSW50ZXJtZWRpYXRlMB4XDTIzMDEwNTIxMzEzNFoXDTMzMDEwMTIxMzEzNFowPTELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRIwEAYDVQQHDAlDdXBlcnRpbm8xDTALBgNVBAoMBExlYWYwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATitYHEaYVuc8g9AjTOwErMvGyPykPa+puvTI8hJTHZZDLGas2qX1+ErxgQTJgVXv76nmLhhRJH+j25AiAI8iGsoy8wLTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIHgDAQBgoqhkiG92NkBgsBBAIFADAKBggqhkjOPQQDAwNIADBFAiBX4c+T0Fp5nJ5QRClRfu5PSByRvNPtuaTsk0vPB3WAIAIhANgaauAj/YP9s0AkEhyJhxQO/6Q2zouZ+H1CIOehnMzQ"

    private var INTERMEDIATE_CA_INVALID_OID_BASE64_ENCODED = "MIIBnjCCAUWgAwIBAgIBDTAKBggqhkjOPQQDAzA2MQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTESMBAGA1UEBwwJQ3VwZXJ0aW5vMB4XDTIzMDEwNTIxMzYxNFoXDTMzMDEwMTIxMzYxNFowRTELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRIwEAYDVQQHDAlDdXBlcnRpbm8xFTATBgNVBAoMDEludGVybWVkaWF0ZTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABBUN5V9rKjfRiMAIojEA0Av5Mp0oF+O0cL4gzrTF178inUHugj7Et46NrkQ7hKgMVnjogq45Q1rMs+cMHVNILWqjNTAzMA8GA1UdEwQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgEGMBAGCiqGSIb3Y2QGAgIEAgUAMAoGCCqGSM49BAMDA0cAMEQCIFROtTE+RQpKxNXETFsf7Mc0h+5IAsxxo/X6oCC/c33qAiAmC5rn5yCOOEjTY4R1H1QcQVh+eUwCl13NbQxWCuwxxA=="
    private var LEAF_CERT_FOR_INTERMEDIATE_CA_INVALID_OID_BASE64_ENCODED = "MIIBnzCCAUagAwIBAgIBDjAKBggqhkjOPQQDAzBFMQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExEjAQBgNVBAcMCUN1cGVydGlubzEVMBMGA1UECgwMSW50ZXJtZWRpYXRlMB4XDTIzMDEwNTIxMzY1OFoXDTMzMDEwMTIxMzY1OFowPTELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRIwEAYDVQQHDAlDdXBlcnRpbm8xDTALBgNVBAoMBExlYWYwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATitYHEaYVuc8g9AjTOwErMvGyPykPa+puvTI8hJTHZZDLGas2qX1+ErxgQTJgVXv76nmLhhRJH+j25AiAI8iGsoy8wLTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIHgDAQBgoqhkiG92NkBgsBBAIFADAKBggqhkjOPQQDAwNHADBEAiAUAs+gzYOsEXDwQquvHYbcVymyNqDtGw9BnUFp2YLuuAIgXxQ3Ie9YU0cMqkeaFd+lyo0asv9eyzk6stwjeIeOtTU="
    private var LEAF_CERT_INVALID_OID_BASE64_ENCODED = "MIIBoDCCAUagAwIBAgIBDzAKBggqhkjOPQQDAzBFMQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExEjAQBgNVBAcMCUN1cGVydGlubzEVMBMGA1UECgwMSW50ZXJtZWRpYXRlMB4XDTIzMDEwNTIxMzczMVoXDTMzMDEwMTIxMzczMVowPTELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRIwEAYDVQQHDAlDdXBlcnRpbm8xDTALBgNVBAoMBExlYWYwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATitYHEaYVuc8g9AjTOwErMvGyPykPa+puvTI8hJTHZZDLGas2qX1+ErxgQTJgVXv76nmLhhRJH+j25AiAI8iGsoy8wLTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIHgDAQBgoqhkiG92NkBgsCBAIFADAKBggqhkjOPQQDAwNIADBFAiAb+7S3i//bSGy7skJY9+D4VgcQLKFeYfIMSrUCmdrFqwIhAIMVwzD1RrxPRtJyiOCXLyibIvwcY+VS73HYfk0O9lgz"

    private var LEAF_CERT_PUBLIC_KEY_BASE64_ENCODED = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE4rWBxGmFbnPIPQI0zsBKzLxsj8pD2vqbr0yPISUx2WQyxmrNql9fhK8YEEyYFV7++p5i4YUSR/o9uQIgCPIhrA=="

    private var REAL_APPLE_ROOT_BASE64_ENCODED = "MIICQzCCAcmgAwIBAgIILcX8iNLFS5UwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMTQwNDMwMTgxOTA2WhcNMzkwNDMwMTgxOTA2WjBnMRswGQYDVQQDDBJBcHBsZSBSb290IENBIC0gRzMxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzB2MBAGByqGSM49AgEGBSuBBAAiA2IABJjpLz1AcqTtkyJygRMc3RCV8cWjTnHcFBbZDuWmBSp3ZHtfTjjTuxxEtX/1H7YyYl3J6YRbTzBPEVoA/VhYDKX1DyxNB0cTddqXl5dvMVztK517IDvYuVTZXpmkOlEKMaNCMEAwHQYDVR0OBBYEFLuw3qFYM4iapIqZ3r6966/ayySrMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMDA2gAMGUCMQCD6cHEFl4aXTQY2e3v9GwOAEZLuN+yRhHFD/3meoyhpmvOwgPUnPWTxnS4at+qIxUCMG1mihDK1A3UT82NQz60imOlM27jbdoXt2QfyFMm+YhidDkLF1vLUagM6BgD56KyKA=="
    private var REAL_APPLE_INTERMEDIATE_BASE64_ENCODED = "MIIDFjCCApygAwIBAgIUIsGhRwp0c2nvU4YSycafPTjzbNcwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMjEwMzE3MjAzNzEwWhcNMzYwMzE5MDAwMDAwWjB1MUQwQgYDVQQDDDtBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTELMAkGA1UECwwCRzYxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEbsQKC94PrlWmZXnXgtxzdVJL8T0SGYngDRGpngn3N6PT8JMEb7FDi4bBmPhCnZ3/sq6PF/cGcKXWsL5vOteRhyJ45x3ASP7cOB+aao90fcpxSv/EZFbniAbNgZGhIhpIo4H6MIH3MBIGA1UdEwEB/wQIMAYBAf8CAQAwHwYDVR0jBBgwFoAUu7DeoVgziJqkipnevr3rr9rLJKswRgYIKwYBBQUHAQEEOjA4MDYGCCsGAQUFBzABhipodHRwOi8vb2NzcC5hcHBsZS5jb20vb2NzcDAzLWFwcGxlcm9vdGNhZzMwNwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NybC5hcHBsZS5jb20vYXBwbGVyb290Y2FnMy5jcmwwHQYDVR0OBBYEFD8vlCNR01DJmig97bB85c+lkGKZMA4GA1UdDwEB/wQEAwIBBjAQBgoqhkiG92NkBgIBBAIFADAKBggqhkjOPQQDAwNoADBlAjBAXhSq5IyKogMCPtw490BaB677CaEGJXufQB/EqZGd6CSjiCtOnuMTbXVXmxxcxfkCMQDTSPxarZXvNrkxU3TkUMI33yzvFVVRT4wxWJC994OsdcZ4+RGNsYDyR5gmdr0nDGg="
    private var REAL_APPLE_SIGNING_CERTIFICATE_BASE64_ENCODED = "MIIEMDCCA7agAwIBAgIQaPoPldvpSoEH0lBrjDPv9jAKBggqhkjOPQQDAzB1MUQwQgYDVQQDDDtBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTELMAkGA1UECwwCRzYxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMB4XDTIxMDgyNTAyNTAzNFoXDTIzMDkyNDAyNTAzM1owgZIxQDA+BgNVBAMMN1Byb2QgRUNDIE1hYyBBcHAgU3RvcmUgYW5kIGlUdW5lcyBTdG9yZSBSZWNlaXB0IFNpZ25pbmcxLDAqBgNVBAsMI0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVsYXRpb25zMRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABOoTcaPcpeipNL9eQ06tCu7pUcwdCXdN8vGqaUjd58Z8tLxiUC0dBeA+euMYggh1/5iAk+FMxUFmA2a1r4aCZ8SjggIIMIICBDAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFD8vlCNR01DJmig97bB85c+lkGKZMHAGCCsGAQUFBwEBBGQwYjAtBggrBgEFBQcwAoYhaHR0cDovL2NlcnRzLmFwcGxlLmNvbS93d2RyZzYuZGVyMDEGCCsGAQUFBzABhiVodHRwOi8vb2NzcC5hcHBsZS5jb20vb2NzcDAzLXd3ZHJnNjAyMIIBHgYDVR0gBIIBFTCCAREwggENBgoqhkiG92NkBQYBMIH+MIHDBggrBgEFBQcCAjCBtgyBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMDYGCCsGAQUFBwIBFipodHRwOi8vd3d3LmFwcGxlLmNvbS9jZXJ0aWZpY2F0ZWF1dGhvcml0eS8wHQYDVR0OBBYEFCOCmMBq//1L5imvVmqX1oCYeqrMMA4GA1UdDwEB/wQEAwIHgDAQBgoqhkiG92NkBgsBBAIFADAKBggqhkjOPQQDAwNoADBlAjEAl4JB9GJHixP2nuibyU1k3wri5psGIxPME05sFKq7hQuzvbeyBu82FozzxmbzpogoAjBLSFl0dZWIYl2ejPV+Di5fBnKPu8mymBQtoE/H2bES0qAs8bNueU3CBjjh1lwnDsI="

    private var EFFECTIVE_DATE: Date = Date(timeIntervalSince1970: TimeInterval(1681312846.0)) // April 2023

    func testValidChainWithoutOCSP() async throws {
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let root = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: ROOT_CA_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: false, validationTime: EFFECTIVE_DATE)
        XCTAssertEqual(result, .validCertificate([leaf, intermediate, root]))
    }
    
    func testValidChainInvalidIntermediateOIDWithoutOCSP() async throws {
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: INTERMEDIATE_CA_INVALID_OID_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: false, validationTime: EFFECTIVE_DATE)
        switch result {
        case .validCertificate(_):
            XCTAssert(false)
        case .couldNotValidate(_):
            break
        }
    }
    
    func testValidChainInvalidLeafOIDWithoutOCSP() async throws {
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: LEAF_CERT_INVALID_OID_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: false, validationTime: EFFECTIVE_DATE)
        switch result {
        case .validCertificate(_):
            XCTAssert(false)
        case .couldNotValidate(_):
            break
        }
    }

    func testValidChainExpired() async throws {
        let EXPIRED_DATE: Date = Date(timeIntervalSince1970: TimeInterval(2280946846))
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: LEAF_CERT_INVALID_OID_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: false, validationTime: EXPIRED_DATE)
        switch result {
        case .validCertificate(_):
            XCTAssert(false)
        case .couldNotValidate(_):
            break
        }
    }
    
    func testChainDifferentThanRootCertificate() async throws {
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: REAL_APPLE_ROOT_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: false, validationTime: EFFECTIVE_DATE)
        switch result {
        case .validCertificate(_):
            XCTAssert(false)
        case .couldNotValidate(_):
            break
        }
    }
    
    // The following test will communicate with Apple's OCSP servers, disable this test for offline testing
    func testAppleChainIsValidWithOCSP() async throws {
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: REAL_APPLE_ROOT_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: REAL_APPLE_SIGNING_CERTIFICATE_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: REAL_APPLE_INTERMEDIATE_BASE64_ENCODED)!))
        let root = try! Certificate(derEncoded: Array(Foundation.Data(base64Encoded: REAL_APPLE_ROOT_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: true, validationTime: EFFECTIVE_DATE)
        XCTAssertEqual(result, .validCertificate([leaf, intermediate, root]))
    }

    public func testAppStoreServerNotificationDecoding() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.sandbox, "com.example")
        let testNotification = TestingUtility.readFile("resources/mock_signed_data/testNotification")
        let notificationResult = await verifier.verifyAndDecodeNotification(signedPayload: testNotification)
        switch notificationResult {
        case .valid(let responseBody):
            XCTAssertEqual(NotificationTypeV2.test, responseBody.notificationType)
        case .invalid(_):
            XCTAssert(false)
        }
    }
    
    public func testMissingX5CHeader() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.sandbox, "com.example")
        let missingX5CHeaderClaim = TestingUtility.readFile("resources/mock_signed_data/missingX5CHeaderClaim")
        let notificationResult = await verifier.verifyAndDecodeNotification(signedPayload: missingX5CHeaderClaim)
        switch notificationResult {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.INVALID_JWT_FORMAT, error)
        }
    }
    
    public func testWrongBundleIdForServerNotification() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.sandbox, "com.example")
        let wrongBundleId = TestingUtility.readFile("resources/mock_signed_data/wrongBundleId")
        let notificationResult = await verifier.verifyAndDecodeNotification(signedPayload: wrongBundleId)
        switch notificationResult {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.INVALID_APP_IDENTIFIER, error)
        }
    }
    
    public func testWrongAppAppleIdForNotification() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.sandbox, "com.example", 1235)
        let testNotification = TestingUtility.readFile("resources/mock_signed_data/testNotification")
        let transactionResult = await verifier.verifyAndDecodeTransaction(signedTransaction: testNotification)
        switch transactionResult {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.INVALID_APP_IDENTIFIER, error)
        }
    }
    
    public func testWrongBundleIdForTransaction() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.sandbox, "com.example.x")
        let transactionInfo = TestingUtility.readFile("resources/mock_signed_data/transactionInfo")
        let transactionResult = await verifier.verifyAndDecodeTransaction(signedTransaction: transactionInfo)
        switch transactionResult {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.INVALID_APP_IDENTIFIER, error)
        }
    }
    
    public func testWrongEnvironmentForServerNotification() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.production, "com.example")
        let testNotification = TestingUtility.readFile("resources/mock_signed_data/testNotification")
        let notificationResult = await verifier.verifyAndDecodeNotification(signedPayload: testNotification)
        switch notificationResult {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.INVALID_ENVIRONMENT, error)
        }
    }

    public func testRenewalInfoDecoding() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.sandbox, "com.example")
        let renewalInfo = TestingUtility.readFile("resources/mock_signed_data/renewalInfo")
        let renewalInfoResult = await verifier.verifyAndDecodeRenewalInfo(signedRenewalInfo: renewalInfo)
        switch renewalInfoResult {
        case .valid(let renewalInfo):
            XCTAssertEqual(Environment.sandbox, renewalInfo.environment)
        case .invalid(_):
            XCTAssert(false)
        }
    }
    
    public func testTransactionInfoDecoding() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier(.sandbox, "com.example")
        let transactionInfo = TestingUtility.readFile("resources/mock_signed_data/transactionInfo")
        let transactionInfoResult = await verifier.verifyAndDecodeTransaction(signedTransaction: transactionInfo)
        switch transactionInfoResult {
        case .valid(let transactionInfo):
            XCTAssertEqual(Environment.sandbox, transactionInfo.environment)
        case .invalid(_):
            XCTAssert(false)
        }
    }
    
    public func testMalformedJWTWithTooManyParts() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier()
        let notificationResult = await verifier.verifyAndDecodeNotification(signedPayload: "a.b.c.d")
        switch notificationResult {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.INVALID_JWT_FORMAT, error)
        }
    }
    
    public func testMalformedJWTWithMalformedData() async {
        let verifier: SignedDataVerifier = TestingUtility.getSignedDataVerifier()
        let notificationResult = await verifier.verifyAndDecodeNotification(signedPayload: "a.b.c")
        switch notificationResult {
        case .valid(_):
            XCTAssert(false)
        case .invalid(let error):
            XCTAssertEqual(VerificationError.INVALID_JWT_FORMAT, error)
        }
    }
    
    private func getChainVerifier(base64EncodedRootCertificate: String) -> ChainVerifier {
        return try! ChainVerifier(rootCertificates: [Data(base64Encoded: base64EncodedRootCertificate)!])
    }
}
