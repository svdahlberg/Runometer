//
//  DistanceFormatterTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-10-08.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class DistanceFormatterTests: XCTestCase {
    
    func testFormatDistanceReturns0ifDistanceIs0() {
        let distance = DistanceFormatter.format(distance: 0)
        XCTAssertEqual("0", distance)
    }
    
    func testFormatDistanceReturns1IfDistanceIs1000AndOutputUnitIsKilometers() {
        let distance = DistanceFormatter.format(distance: 1000, outputUnit: .kilometers)
        XCTAssertEqual("1", distance)
    }

    func testFormatDistanceReturns1IfDistanceIs1609344AndOutputUnitIsMiles() {
        let distance = DistanceFormatter.format(distance: 1609.344, outputUnit: .miles)
        XCTAssertEqual("1", distance)
    }
    
    func testFormatDistanceReturnsOnePointFiveIfDistanceIs1500AndOutputUnitIsKilometers() {
        let distance = DistanceFormatter.format(distance: 1500, outputUnit: .kilometers)
        XCTAssertEqual("1.5", distance)
    }
}
