//
//  LocationSegmentExtensionsTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-09-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreLocation

class LocationSegmentExtensionsTests: XCTestCase {
    
    func testCoordinateSegmentsReturnsOneSegmentOfOneCoordinateWhenLocationSegmentsHasOneSegmentWithOneLocation() {
        let locationSegments = [[CLLocation(latitude: 0, longitude: 0)]]
        XCTAssertEqual(1, locationSegments.coordinateSegments().count)
        XCTAssertEqual(1, locationSegments.coordinateSegments().first?.count)
    }

    func testCoordinateSegmentsReturnsOneSegmentOfTwoCoordinatesWhenLocationSegmentHasOneSegmentWithTwoLocations() {
        let locationSegments = [[CLLocation(latitude: 0, longitude: 0), CLLocation(latitude: 0, longitude: 0)]]
        XCTAssertEqual(1, locationSegments.coordinateSegments().count)
        XCTAssertEqual(2, locationSegments.coordinateSegments().first?.count)
    }

    func testCoordinateSegmentsReturnsTwoSegmentsOfTwoCoordinatesEachWhenLocationSegmentsHasTwoRunSegmentsWithTwoLocationsEach() {
        let locationSegments = [[CLLocation(latitude: 0, longitude: 0), CLLocation(latitude: 0, longitude: 0)], [CLLocation(latitude: 0, longitude: 0), CLLocation(latitude: 0, longitude: 0)]]
        XCTAssertEqual(2, locationSegments.coordinateSegments().count)
        XCTAssertEqual(2, locationSegments.coordinateSegments().first?.count)
        XCTAssertEqual(2, locationSegments.coordinateSegments().last?.count)
    }

    func testCoordinateSegmentsReturnsCoordinateWithLatitudeTwoAndLongitudeOneForLocationWithLatitudeTwoAndLongitudeOne() {
        let locationSegments = [[CLLocation(latitude: 2, longitude: 1)]]
        let coordinate = locationSegments.coordinateSegments().first?.first
        XCTAssertEqual(2, coordinate?.latitude)
        XCTAssertEqual(1, coordinate?.longitude)
    }

    func testFlattenedCoordinateSegmentsReturnsCoordinateSegmentsAsOneArray() {
        let locationSegments = [[CLLocation(latitude: 1, longitude: 1)], [CLLocation(latitude: 2, longitude: 2)]]
        XCTAssertEqual(2, locationSegments.flattenedCoordinateSegments().count)
    }

    func testReachedCheckpointsForRunWithOneLocationSegmentContainingTwoLocationsWithDistanceBetweenOneAndTwoKilometersReturnsOneCheckpoint() {
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 1.01, longitude: 1)]
        ]
        let checkpoints = locationSegments.reachedCheckpoints(distanceUnit: .kilometers)
        XCTAssertEqual(1, checkpoints?.count)
    }

    func testReachedCheckpointsForRunWithTwoLocationSegmentsContainingTwoLocationsEachDistanceBetweenOneAndTwoKilometersInEachSegmentReturnsTwoCheckpoints() {
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 1.01, longitude: 1)],
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 1.01, longitude: 1)]
        ]
        let checkpoints = locationSegments.reachedCheckpoints(distanceUnit: .kilometers)
        XCTAssertEqual(2, checkpoints?.count)
    }

    func testStartAnnotationReturnsNilIfRunHasNoLocations() {
        let startAnnotation = [].startAnnotation()
        XCTAssertNil(startAnnotation)
    }

    func testStartAnnotationReturnsAnnotationWithLocationOfFirstLocationOfRun() {
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 2, longitude: 2)]
        ]
        let startAnnotation = locationSegments.startAnnotation()
        XCTAssertEqual(1, startAnnotation?.coordinate.latitude)
        XCTAssertEqual(1, startAnnotation?.coordinate.longitude)
    }

    func testEndAnnotationReturnsNilIfRunHasNoLocations() {
        let endAnnotation = [].endAnnotation()
        XCTAssertNil(endAnnotation)
    }

    func testEndAnnotationReturnsAnnotationWithLocationOfLastLocationOfRun() {
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 2, longitude: 2)]
        ]
        let endAnnotation = locationSegments.endAnnotation()
        XCTAssertEqual(2, endAnnotation?.coordinate.latitude)
        XCTAssertEqual(2, endAnnotation?.coordinate.longitude)
    }

    func testSplitTimesReturnsPaceFiveMinutesPerKilometerForFirstKilometerAndSixMinutesPerKilometerForSecondKilometerWhenItTookFiveMinutesToRunFirstKilomerAndSixMinutesForSecond() {
        
        let coordinate1 = CLLocationCoordinate2D(latitude: 1, longitude: 1)
        let coordinate2 = CLLocationCoordinate2D(latitude: 1, longitude: 1.01)
        let coordinate3 = CLLocationCoordinate2D(latitude: 1, longitude: 1.02)
        let time1 = Date(timeIntervalSince1970: 0)
        let time2 = Date(timeIntervalSince1970: 300) // 300 seconds = 5 minutes
        let time3 = Date(timeIntervalSince1970: 660) // 360 seconds = 6 minutes
        let location1 = CLLocation(coordinate: coordinate1, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: time1)
        let location2 = CLLocation(coordinate: coordinate2, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: time2)
        let location3 = CLLocation(coordinate: coordinate3, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: time3)
        let locationSegments = [ [location1, location2, location3] ]
        let splitTimes = locationSegments.splitTimes(distanceUnit: .kilometers, speedUnit: .minutesPerKilometer)
        XCTAssertEqual(2, splitTimes?.count)
        XCTAssertEqual("5:00", splitTimes?.first)
        XCTAssertEqual("6:00", splitTimes?.last)
    }

    
}
