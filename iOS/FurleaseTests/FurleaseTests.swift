import XCTest
@testable import Furlease

@MainActor
final class FurleaseTests: XCTestCase {
    func makeEntry(_ i: Int) -> LeaseEntry {
        LeaseEntry(propertyName: "Test i", depositAmount: Double(i))
    }

    func testSeedDataNotEmpty() {
        let store = Store()
        XCTAssertFalse(store.entries.isEmpty)
    }

    func testSeedCountBelowFreeLimit() {
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(makeEntry(999))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteDecreasesCount() {
        let store = Store()
        let before = store.entries.count
        guard let first = store.entries.first else { return XCTFail("no entries") }
        store.delete(first)
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWithoutPro() {
        let store = Store()
        while store.entries.count < Store.freeLimit {
            store.add(makeEntry(store.entries.count))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProBypassesLimit() {
        let store = Store()
        store.isPro = true
        while store.entries.count < Store.freeLimit {
            store.add(makeEntry(store.entries.count))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateMutatesEntry() {
        let store = Store()
        guard var first = store.entries.first else { return XCTFail("no entries") }
        first.date = Date.distantPast
        store.update(first)
        XCTAssertEqual(store.entries.first(where: { $0.id == first.id })?.date, Date.distantPast)
    }
}
