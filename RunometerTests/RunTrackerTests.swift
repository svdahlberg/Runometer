//
//  RunTrackerTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-10-08.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreLocation

class RunTrackerTests: XCTestCase {
    
    private var sut: RunTracker!
    
    override func setUp() {
        super.setUp()
        sut = RunTracker()
        sut.startTracking()
    }
    
    override func tearDown() {
        super.tearDown()
        sut.reset()
    }
    
    func testDistanceIsInitializedToZero() {
        XCTAssertEqual(sut.distance, 0)
    }
    
    func testTimeIsInitializedToZero() {
        XCTAssertEqual(sut.distance, 0)
    }
    
    func testRunSegmentsIsInitializedToEmptyArray() {
        let runTracker = RunTracker()
        XCTAssertTrue(runTracker.runSegments.isEmpty)
    }
    
    func testOneLocationIsAddedToLocations() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        XCTAssertEqual(sut.runSegments.first!.count, 1)
    }
    
    func testTwoLocationsAreAddedToLocations() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: [CLLocationManagerMock.mockLocationsA.first!, CLLocationManagerMock.mockLocationsB.first!])
        XCTAssertEqual(sut.runSegments.first!.count, 2)
    }
    
    func testLocationWithHorizontalAccuracyOver20IsNotAddedToLocations() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsWithHighHorizontalAccuracy)
        XCTAssertEqual(sut.runSegments.first!.count, 0)
    }
    
    func testLocationWithOldDateIsNotAddedToLocations() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsWithOldDate)
        XCTAssertEqual(sut.runSegments.first!.count, 0)
    }
    
    func testDistanceIsNotUpdatedForFirstLocationAdded() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        XCTAssertEqual(sut.distance, 0)
    }
    
    func testDistanceIsUpdatedWhenSecondLocationIsAdded() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsB)
        XCTAssertEqual(sut.distance, CLLocationManagerMock.distanceBetweenLocationAandB)
    }
    
    func testDistanceIsUpdatedWhenThirdLocationIsAdded() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsB)
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsC)
        XCTAssertEqual(sut.distance, CLLocationManagerMock.distanceBetweenLocationAandC)
    }
    
    func testDistanceIsNotUpdatedWhenAddingTheSameLocationTwice() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsB)
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        XCTAssertEqual(sut.distance, CLLocationManagerMock.distanceBetweenLocationAandB)
    }
    
    func testLastRunSegmentIsUpdated() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        sut.stopTracking()
        sut.startTracking()
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsB)
        XCTAssertEqual(1, sut.runSegments[0].count)
        XCTAssertEqual(1, sut.runSegments[1].count)
    }
    
    func testDistanceBetweenRunSegmentsAreNotIncludedInDistance() {
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsA)
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsB)
        sut.stopTracking()
        sut.startTracking()
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsC)
        sut.locationManager(CLLocationManagerMock(), didUpdateLocations: CLLocationManagerMock.mockLocationsB)
        XCTAssertEqual(sut.distance, CLLocationManagerMock.distanceBetweenLocationAandB + CLLocationManagerMock.distanceBetweenLocationBandC)
    }
    
    
}

class CLLocationManagerMock: CLLocationManager {
    override var location: CLLocation? {
        return CLLocationManagerMock.locationA
    }
    
    private static var locationA = CLLocation(latitude: 1, longitude: 1)
    private static var locationB = CLLocation(latitude: 2, longitude: 2)
    private static var locationC = CLLocation(latitude: 3, longitude: 3)
    static var distanceBetweenLocationAandB = Meters(locationB.distance(from: locationA))
    static var distanceBetweenLocationBandC = Meters(locationC.distance(from: locationB))
    static var distanceBetweenLocationAandC = distanceBetweenLocationAandB + distanceBetweenLocationBandC
    static var mockLocationsA = [
        locationA
    ]
    static var mockLocationsB = [
        locationB
    ]
    static var mockLocationsC = [
        locationC
    ]
    static var mockLocationsWithHighHorizontalAccuracy = [
        CLLocation(coordinate: CLLocationCoordinate2D(latitude: 2, longitude: 2), altitude: 0, horizontalAccuracy: 21, verticalAccuracy: 0, timestamp: Date())
    ]
    static var mockLocationsWithOldDate = [
        CLLocation(coordinate: CLLocationCoordinate2D(latitude: 2, longitude: 2), altitude: 0, horizontalAccuracy: 21, verticalAccuracy: 0, timestamp: Date.distantPast)
    ]
}
