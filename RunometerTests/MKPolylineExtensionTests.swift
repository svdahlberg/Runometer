//
//  MKPolylineExtensionTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-05.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import MapKit

class MKPolylineExtensionTests: XCTestCase {
    
    func testPolylinesFromOneCoordinateSegmentReturnsOnePolyLine() {
        let coordinateSegments = [[CLLocationCoordinate2D(latitude: 1, longitude: 1)]]
        let polylines = MKPolyline.polylines(from: coordinateSegments)
        XCTAssertEqual(1, polylines.count)
    }
    
    func testPolylinesFromTwoCoordinateSegmentReturnsTwoPolyLines() {
        let coordinateSegments = [[CLLocationCoordinate2D(latitude: 1, longitude: 1)], [CLLocationCoordinate2D(latitude: 1, longitude: 1)]]
        let polylines = MKPolyline.polylines(from: coordinateSegments)
        XCTAssertEqual(2, polylines.count)
    }
    
}
