//
//  DoubleExtensionsTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-19.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class DoubleExtensionsTests: XCTestCase {
    
    func testTrailingZeroRemovedReturnsNumberAsStringWithoutTrailingZero() {
        XCTAssertEqual("3", 3.0.trailingZeroRemoved())
    }
    
    func testTrailingZeroRemovedReturnsNumberAsStringIfThereAreNoTrailingZeros() {
        XCTAssertEqual("3.1", 3.1.trailingZeroRemoved())
    }
}
