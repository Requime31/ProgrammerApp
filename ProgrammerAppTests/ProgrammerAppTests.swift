//
//  ProgrammerAppTests.swift
//  ProgrammerAppTests
//
//  Created by Roman Shevchenko on 16/01/2026.
//

import XCTest
@testable import ProgrammerApp

final class ProgrammerAppTests: XCTestCase {

    private var persistence: PersistenceService!
    private let suiteName = "ProgrammerAppTests"

    override func setUpWithError() throws {
        try super.setUpWithError()
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        persistence = PersistenceService(userDefaults: defaults)
    }

    override func tearDownWithError() throws {
        persistence = nil
        try super.tearDownWithError()
    }

    // MARK: - PersistenceService primitive types

    func testPersistenceService_IntRoundTrip() throws {
        persistence.set(42, forKey: "testInt")
        XCTAssertEqual(persistence.getInt(forKey: "testInt"), 42)
        persistence.remove(forKey: "testInt")
        XCTAssertEqual(persistence.getInt(forKey: "testInt"), 0)
    }

    func testPersistenceService_BoolRoundTrip() throws {
        persistence.set(true, forKey: "testBool")
        XCTAssertTrue(persistence.getBool(forKey: "testBool"))
        persistence.set(false, forKey: "testBool")
        XCTAssertFalse(persistence.getBool(forKey: "testBool"))
    }

    func testPersistenceService_StringRoundTrip() throws {
        persistence.set("hello", forKey: "testString")
        XCTAssertEqual(persistence.getString(forKey: "testString"), "hello")
        persistence.remove(forKey: "testString")
        XCTAssertNil(persistence.getString(forKey: "testString"))
    }

    func testPersistenceService_DoubleRoundTrip() throws {
        persistence.set(3.14, forKey: "testDouble")
        XCTAssertEqual(persistence.getDouble(forKey: "testDouble"), 3.14, accuracy: 0.001)
    }

    func testPersistenceService_CodableRoundTrip() throws {
        struct TestItem: Codable, Equatable {
            let id: Int
            let name: String
        }
        let item = TestItem(id: 1, name: "Test")
        try persistence.set(item, forKey: "testCodable")
        let loaded: TestItem? = try persistence.get(TestItem.self, forKey: "testCodable")
        XCTAssertEqual(loaded, item)
    }

    func testPersistenceService_RemoveClearsValue() throws {
        persistence.set(100, forKey: "testRemove")
        XCTAssertEqual(persistence.getInt(forKey: "testRemove"), 100)
        persistence.remove(forKey: "testRemove")
        XCTAssertEqual(persistence.getInt(forKey: "testRemove"), 0)
    }
}
