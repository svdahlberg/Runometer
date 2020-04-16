//
//  PaceFormatterTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-10-08.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class PaceFormatterTests: XCTestCase {
    
    func testPaceReturnsFormatMSSForDistance0Time0() {
        let pace = PaceFormatter.pace(fromDistance: 0, time: 0)
        XCTAssertEqual("00:00", pace)
    }

    func testPaceReturns6FromDistance10kmTime3600UnitMinutesPerKilometer() {
        let pace = PaceFormatter.pace(fromDistance: 10000, time: 3600, outputUnit: .minutesPerKilometer)
        XCTAssertEqual("06:00", pace)
    }
    
    func testPaceReturns6FromDistance10milesTime3600UnitMinutesPerMile() {
        let pace = PaceFormatter.pace(fromDistance: 16093.44, time: 3600, outputUnit: .minutesPerMile)
        XCTAssertEqual("06:00", pace)
    }
    
}
