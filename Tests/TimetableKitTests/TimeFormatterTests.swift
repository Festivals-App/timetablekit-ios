//
//  TimeFormatterTests.swift
//  TimetableKitTests
//
//  Created by Simon Gaus on 01.04.21.
//

import XCTest
@testable import TimetableKit

class TimeFormatterTests: XCTestCase {
    
    func testStringFromDate() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let nice = TimeFormatter()
        let date = Date(timeIntervalSince1970: 1617410987)
        XCTAssertEqual(nice.string(from: date), "02:49")
    }
    
    func testStringFromInterval() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let nice = TimeFormatter()
        let start = Date(timeIntervalSince1970: 1617410987)
        XCTAssertEqual(nice.string(from: DateInterval(start: start, duration: 60*60)), "02:49 - 03:49")
    }

    func testDayStringFromDate() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let nice = TimeFormatter()
        let date = Date(timeIntervalSince1970: 1617410987)
        XCTAssertEqual(nice.dayString(from: date), "Samstag, 3 Apr.")
    }

    func testDescriptionOfDate() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let nice = TimeFormatter()
        let date = Date(timeIntervalSince1970: 1617410987)
        let start = Date(timeIntervalSince1970: 1617410987)
        let interval = DateInterval(start: start, duration: 60*60)
        
        XCTAssertEqual(nice.description(of: date.advanced(by:-(60*60*25)), relativeTo:interval), "In mehr als 24 Stunden")
        XCTAssertEqual(nice.description(of: date.advanced(by:-(60*60*7)), relativeTo:interval), "In 7 Stunden")
        XCTAssertEqual(nice.description(of: date.advanced(by:-(60*5)), relativeTo:interval), "In 5 Minuten")
        XCTAssertEqual(nice.description(of: date, relativeTo:interval), "Jetzt!")
        XCTAssertEqual(nice.description(of: date.advanced(by:(60*5)), relativeTo:interval), "Läuft seit 5 Minuten")
        XCTAssertEqual(nice.description(of: date.advanced(by:((60*60)-(60*5))), relativeTo:interval), "Läuft noch ca. 5 Minuten")
        XCTAssertEqual(nice.description(of: date.advanced(by:60*60), relativeTo:interval), "Vorbei")
        XCTAssertEqual(nice.description(of: date.advanced(by:((60*60)+(60*5))), relativeTo:interval), "Seit 5 Minuten vorbei")
        XCTAssertEqual(nice.description(of: date.advanced(by:(60*60*7)), relativeTo:interval), "Seit 6 Stunden vorbei")
        XCTAssertEqual(nice.description(of: date.advanced(by:(60*60*25)), relativeTo:interval), "Seit mehr als 24 Stunden vorbei")
    }
}
