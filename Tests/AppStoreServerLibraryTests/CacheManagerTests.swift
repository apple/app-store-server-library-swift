import XCTest
@testable import AppStoreServerLibrary

final class CacheManagerTests: XCTestCase {
    struct DummyKey: Hashable, Sendable {
        let id: Int
    }
    struct DummyValue: Sendable, Equatable {
        let value: String
    }

    actor TestableCacheManager {
        private var cache: [DummyKey: (expiration: Date, value: DummyValue)] = [:]
        private let maxSize: Int
        private let expirationInterval: TimeInterval
        private var now: Date

        init(maxSize: Int = 3, expirationInterval: TimeInterval = 1.0, now: Date = Date()) {
            self.maxSize = maxSize
            self.expirationInterval = expirationInterval
            self.now = now
        }

        func setNow(_ date: Date) {
            self.now = date
        }

        func cacheResult(_ value: DummyValue, for key: DummyKey) {
            cache[key] = (expiration: now.addingTimeInterval(expirationInterval), value: value)
            if cache.count > maxSize {
                // Remove expired entries first
                let expiredKeys = cache.filter { $0.value.expiration < now }.map { $0.key }
                for k in expiredKeys { cache.removeValue(forKey: k) }
                // If still too big, remove oldest
                if cache.count > maxSize {
                    let sorted = cache.sorted { $0.value.expiration < $1.value.expiration }
                    for (k, _) in sorted.prefix(cache.count - maxSize) {
                        cache.removeValue(forKey: k)
                    }
                }
            }
        }

        func getCachedResult(for key: DummyKey) -> DummyValue? {
            guard let entry = cache[key] else { return nil }
            if entry.expiration > now {
                return entry.value
            } else {
                cache.removeValue(forKey: key)
                return nil
            }
        }
    }

    func testCacheStoresAndRetrievesValue() async {
        let cache = TestableCacheManager()
        let key = DummyKey(id: 1)
        let value = DummyValue(value: "foo")
        await cache.cacheResult(value, for: key)
        let result = await cache.getCachedResult(for: key)
        XCTAssertEqual(result, value)
    }

    func testCacheExpiresValue() async {
        let cache = TestableCacheManager(expirationInterval: 1.0, now: Date())
        let key = DummyKey(id: 2)
        let value = DummyValue(value: "bar")
        await cache.cacheResult(value, for: key)
        await cache.setNow(Date().addingTimeInterval(2.0))
        let result = await cache.getCachedResult(for: key)
        XCTAssertNil(result)
    }

    func testCacheEvictsOldestWhenFull() async {
        let cache = TestableCacheManager(maxSize: 2, expirationInterval: 10, now: Date())
        let key1 = DummyKey(id: 1)
        let key2 = DummyKey(id: 2)
        let key3 = DummyKey(id: 3)
        await cache.cacheResult(DummyValue(value: "a"), for: key1)
        await cache.cacheResult(DummyValue(value: "b"), for: key2)
        await cache.cacheResult(DummyValue(value: "c"), for: key3)
        let result1 = await cache.getCachedResult(for: key1)
        let result2 = await cache.getCachedResult(for: key2)
        let result3 = await cache.getCachedResult(for: key3)
        // Only two should remain
        let results = [result1, result2, result3].compactMap { $0 }
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.contains(DummyValue(value: "b")) || results.contains(DummyValue(value: "c")))
    }
}
