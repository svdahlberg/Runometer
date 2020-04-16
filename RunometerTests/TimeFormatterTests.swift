//
//  TimeFormatterTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-10-08.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class TimeFormatterTests: XCTestCase {
    
    func testFormatTimeReturnsFormatHMMSSForTime0() {
        let time = TimeFormatter.format(time: 0)
        XCTAssertEqual("00:00:00", time)
    }
    
    func testFormatTimeReturnsCorrectTimeForTime1Hour() {
        let time = TimeFormatter.format(time: 3600)
        XCTAssertEqual("01:00:00", time)
    }

    func testFormatTimeReturnsCorrectTimeForTime0Hour1Minute1Second() {
        let time = TimeFormatter.format(time: 61)
        XCTAssertEqual("00:01:01", time)
    }
    
    func testFormatTimeReturnsCorrectTimeForTime1Hour15Minutes30Seconds() {
        let time = TimeFormatter.format(time: 4530)
        XCTAssertEqual("01:15:30", time)
    }
    
    func testFormatTimeReturnsFormatHHMMSSFOrTime10Hours() {
        let time = TimeFormatter.format(time: 36000)
        XCTAssertEqual("10:00:00", time)
    }
    
    func testFormatTimeReturnsFormatHHHMMSSFOrTime100Hours() {
        let time = TimeFormatter.format(time: 360000)
        XCTAssertEqual("100:00:00", time)
    }
}
