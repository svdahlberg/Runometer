//
//  ManagedRunObjectTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-09-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreLocation

class ManagedRunObjectTests: XCTestCase {

    func testConvenianceInitCreatesOneRunSegmentFromArrayOfOneArrayOfLocations() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let locationSegments = [[CLLocation(latitude: 1, longitude: 1)]]
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        XCTAssertEqual(1, run.runSegments?.count)
    }

    func testConvenianceInitCreatesTwoRunSegmentsFromArrayOfTwoArraysOfLocations() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let locationSegments = [[CLLocation(latitude: 1, longitude: 1)], [CLLocation(latitude: 1, longitude: 1)]]
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        XCTAssertEqual(2, run.runSegments?.count)
    }
    
}
