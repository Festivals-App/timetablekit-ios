import XCTest
@testable import TimetableKit

final class TimetableKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TimetableKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
