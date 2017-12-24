//
//  MKCoordinateRegionExtensionsTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-05.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import MapKit

class MKCoordinateRegionExtensionsTests: XCTestCase {

    func testRegionFromCoordinatesWhencoordinatesIsEmptyArrayReturnsNil() {
        let coordinates = [CLLocationCoordinate2D]()
        let region = MKCoordinateRegion.region(from: coordinates)
        XCTAssertNil(region)
    }
    
    func testRegionFromCoordinatesWithOneCoordinateReturnsMapRegionWithCenterSameAsTheCoordinate() {
        let coordinates = [CLLocationCoordinate2D(latitude: 1, longitude: 2)]
        let region = MKCoordinateRegion.region(from: coordinates)
        XCTAssertEqual(1, region?.center.latitude)
        XCTAssertEqual(2, region?.center.longitude)
    }

    func testRegionFromCoordinatesWithTwoCoordinatesReturnsMapRegionWithCenterThatIsTheAverageOfTheTwoCoordinates() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 1, longitude: 2),
            CLLocationCoordinate2D(latitude: 2, longitude: 4)]
        let region = MKCoordinateRegion.region(from: coordinates)
        XCTAssertEqual(1.5, region?.center.latitude)
        XCTAssertEqual(3, region?.center.longitude)
    }
    
}
