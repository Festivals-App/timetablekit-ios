//
//  TimeFormatterTests.swift
//  TimetableKitTests
//
//  Created by Simon Gaus on 01.04.21.
//

import XCTest
@testable import TimetableKit

class TimeFormatterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStringFromDate() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let formatter = TimeFormatter()
        let date = Date(timeIntervalSince1970: 1617410987)
        XCTAssertEqual(formatter.string(from: date), "02:49")
    }
    
    func testStringFromInterval() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let formatter = TimeFormatter()
        let start = Date(timeIntervalSince1970: 1617410987)
        XCTAssertEqual(formatter.string(from: DateInterval(start: start, duration: 60*60)), "02:49 - 03:49")
    }

    func testDayStringFromDate() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let formatter = TimeFormatter()
        let date = Date(timeIntervalSince1970: 1617410987)
        XCTAssertEqual(formatter.dayString(from: date), "Samstag, 3 Apr.")
    }

    func testDescriptionOfDate() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let formatter = TimeFormatter()
        let date = Date(timeIntervalSince1970: 1617410987)
        let start = Date(timeIntervalSince1970: 1617410987)
        let interval = DateInterval(start: start, duration: 60*60)
        
        XCTAssertEqual(formatter.description(of: date.advanced(by:-(60*60*25)), relativeTo:interval), "Noch mehr als 24 Stunden")
        XCTAssertEqual(formatter.description(of: date.advanced(by:-(60*60*7)), relativeTo:interval), "Noch 7 Stunden")
        XCTAssertEqual(formatter.description(of: date.advanced(by:-(60*5)), relativeTo:interval), "Noch 5 Minuten")
        XCTAssertEqual(formatter.description(of: date, relativeTo:interval), "Jetzt!")
        XCTAssertEqual(formatter.description(of: date.advanced(by:(60*5)), relativeTo:interval), "Läuft seit 5 Minuten")
        XCTAssertEqual(formatter.description(of: date.advanced(by:((60*60)-(60*5))), relativeTo:interval), "Läuft noch ca. 5 Minuten")
        XCTAssertEqual(formatter.description(of: date.advanced(by:60*60), relativeTo:interval), "Vorbei")
        XCTAssertEqual(formatter.description(of: date.advanced(by:((60*60)+(60*5))), relativeTo:interval), "Seit 5 Minuten vorbei")
        XCTAssertEqual(formatter.description(of: date.advanced(by:(60*60*7)), relativeTo:interval), "Seit 6 Stunden vorbei")
        XCTAssertEqual(formatter.description(of: date.advanced(by:(60*60*25)), relativeTo:interval), "Seit mehr als 24 Stunden vorbei")
    }
}
