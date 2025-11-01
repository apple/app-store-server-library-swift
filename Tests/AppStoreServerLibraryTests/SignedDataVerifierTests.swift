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
    private var REAL_APPLE_SIGNING_CERTIFICATE_BASE64_ENCODED = "MIIEMTCCA7agAwIBAgIQR8KHzdn554Z/UoradNx9tzAKBggqhkjOPQQDAzB1MUQwQgYDVQQDDDtBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTELMAkGA1UECwwCRzYxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMB4XDTI1MDkxOTE5NDQ1MVoXDTI3MTAxMzE3NDcyM1owgZIxQDA+BgNVBAMMN1Byb2QgRUNDIE1hYyBBcHAgU3RvcmUgYW5kIGlUdW5lcyBTdG9yZSBSZWNlaXB0IFNpZ25pbmcxLDAqBgNVBAsMI0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVsYXRpb25zMRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABNnVvhcv7iT+7Ex5tBMBgrQspHzIsXRi0Yxfek7lv8wEmj/bHiWtNwJqc2BoHzsQiEjP7KFIIKg4Y8y0/nynuAmjggIIMIICBDAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFD8vlCNR01DJmig97bB85c+lkGKZMHAGCCsGAQUFBwEBBGQwYjAtBggrBgEFBQcwAoYhaHR0cDovL2NlcnRzLmFwcGxlLmNvbS93d2RyZzYuZGVyMDEGCCsGAQUFBzABhiVodHRwOi8vb2NzcC5hcHBsZS5jb20vb2NzcDAzLXd3ZHJnNjAyMIIBHgYDVR0gBIIBFTCCAREwggENBgoqhkiG92NkBQYBMIH+MIHDBggrBgEFBQcCAjCBtgyBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMDYGCCsGAQUFBwIBFipodHRwOi8vd3d3LmFwcGxlLmNvbS9jZXJ0aWZpY2F0ZWF1dGhvcml0eS8wHQYDVR0OBBYEFIFioG4wMMVA1ku9zJmGNPAVn3eqMA4GA1UdDwEB/wQEAwIHgDAQBgoqhkiG92NkBgsBBAIFADAKBggqhkjOPQQDAwNpADBmAjEA+qXnREC7hXIWVLsLxznjRpIzPf7VHz9V/CTm8+LJlrQepnmcPvGLNcX6XPnlcgLAAjEA5IjNZKgg5pQ79knF4IbTXdKv8vutIDMXDmjPVT3dGvFtsGRwXOywR2kZCdSrfeot"

    private var EFFECTIVE_DATE: Date = Date(timeIntervalSince1970: TimeInterval(1761962975)) // October 2025
    private let CLOCK_DATE: Int64 = 41231

    func testValidChainWithoutOCSP() async throws {
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let root = try! Certificate(derEncoded: Array(Data(base64Encoded: ROOT_CA_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: false, validationTime: EFFECTIVE_DATE)
        XCTAssertEqual(result, .validCertificate([leaf, intermediate, root]))
    }
    
    func testValidChainInvalidIntermediateOIDWithoutOCSP() async throws {
        let verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_INVALID_OID_BASE64_ENCODED)!))
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
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_INVALID_OID_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
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
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_INVALID_OID_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
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
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let result: X509.VerificationResult = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: false, validationTime: EFFECTIVE_DATE)
        switch result {
        case .validCertificate(_):
            XCTAssert(false)
        case .couldNotValidate(_):
            break
        }
    }
    
    func testOcspResponseCaching() async throws {
        var verifier: DateOverrideChainVerifier = DateOverrideChainVerifier(expectedCalls: 1, currentDate: CLOCK_DATE, base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)!
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let _ = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: true, validationTime: EFFECTIVE_DATE)
        verifier.setDate(newDate: CLOCK_DATE + 1) // 1 second
        let _ = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: true, validationTime: EFFECTIVE_DATE)
    }
    
    func testOcspResponseCachingHasExpiration() async throws {
        var verifier: DateOverrideChainVerifier = DateOverrideChainVerifier(expectedCalls: 2, currentDate: CLOCK_DATE, base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)!
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let _ = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: true, validationTime: EFFECTIVE_DATE)
        verifier.setDate(newDate: CLOCK_DATE + 900) // 15 minutes
        let _ = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: true, validationTime: EFFECTIVE_DATE)
    }
    
    func testOcspResponseCachingWithDifferentChains() async throws {
        let verifier: DateOverrideChainVerifier = DateOverrideChainVerifier(expectedCalls: 2, currentDate: CLOCK_DATE, base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)!
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let altLeaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let altIntermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: REAL_APPLE_INTERMEDIATE_BASE64_ENCODED)!))
        let _ = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: true, validationTime: EFFECTIVE_DATE)
        let _ = await verifier.verifyChain(leaf: altLeaf, intermediate: altIntermediate, online: true, validationTime: EFFECTIVE_DATE)
    }
    
    func testOcspResponseCachingWithSlightlyDifferentChains() async throws {
        let verifier: DateOverrideChainVerifier = DateOverrideChainVerifier(expectedCalls: 2, currentDate: CLOCK_DATE, base64EncodedRootCertificate: ROOT_CA_BASE64_ENCODED)!
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: LEAF_CERT_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: INTERMEDIATE_CA_BASE64_ENCODED)!))
        let altIntermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: REAL_APPLE_INTERMEDIATE_BASE64_ENCODED)!))
        let _ = await verifier.verifyChain(leaf: leaf, intermediate: intermediate, online: true, validationTime: EFFECTIVE_DATE)
        let _ = await verifier.verifyChain(leaf: leaf, intermediate: altIntermediate, online: true, validationTime: EFFECTIVE_DATE)
    }
    
    // The following test will communicate with Apple's OCSP servers, disable this test for offline testing
    func testAppleChainIsValidWithOCSP() async throws {
        var verifier: ChainVerifier = getChainVerifier(base64EncodedRootCertificate: REAL_APPLE_ROOT_BASE64_ENCODED)
        let leaf = try! Certificate(derEncoded: Array(Data(base64Encoded: REAL_APPLE_SIGNING_CERTIFICATE_BASE64_ENCODED)!))
        let intermediate = try! Certificate(derEncoded: Array(Data(base64Encoded: REAL_APPLE_INTERMEDIATE_BASE64_ENCODED)!))
        let root = try! Certificate(derEncoded: Array(Data(base64Encoded: REAL_APPLE_ROOT_BASE64_ENCODED)!))
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
            XCTAssertEqual(AppStoreEnvironment.sandbox, renewalInfo.environment)
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
            XCTAssertEqual(AppStoreEnvironment.sandbox, transactionInfo.environment)
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
    
    struct DateOverrideChainVerifier {
        let chainVerifier: ChainVerifier
        var currentDate: Int64
        var expectation : XCTestExpectation
        
        init?(expectedCalls: Int, currentDate: Int64, base64EncodedRootCertificate: String) {
            self.currentDate = currentDate
            self.expectation = XCTestExpectation()
            self.expectation.assertForOverFulfill = true
            self.expectation.expectedFulfillmentCount = expectedCalls
            guard let chainVerifier = try? ChainVerifier(rootCertificates: [Data(base64Encoded: base64EncodedRootCertificate)!])
            else { return nil }
            
            self.chainVerifier = chainVerifier
        }
        
        mutating func setDate(newDate: Int64) {
            self.currentDate = newDate
        }
        
        func verify<T: DecodedSignedData>(signedData: String, type: T.Type, onlineVerification: Bool, environment: AppStoreEnvironment) async -> AppStoreServerLibrary.VerificationResult<T> where T: Decodable & Sendable {
            await chainVerifier.verify(signedData: signedData, type: type, onlineVerification: onlineVerification, environment: environment, currentTime: getDate())
        }
        
        func verifyChain(leaf: Certificate, intermediate: Certificate, online: Bool, validationTime: Date) async -> X509.VerificationResult {
            await chainVerifier.verifyChain(leaf: leaf, intermediate: intermediate, online: online, validationTime: validationTime, currentTime: getDate())
        }
        
        func verifyChainWithoutCaching(leaf: Certificate, intermediate: Certificate, online: Bool, validationTime: Date) async -> X509.VerificationResult {
            expectation.fulfill()
            return .validCertificate([])
        }
        
        func getDate() -> Date {
            return Date(timeIntervalSince1970: TimeInterval(currentDate))
        }
    }
}
