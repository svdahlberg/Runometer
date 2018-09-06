//
//  RunTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreLocation
import CoreData

class RunTests: XCTestCase {
    
    func testInitSetsStartDateToDateMinusDurationOfRun() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context, distance: 1000, time: 900, locationSegments: [], date: Date(timeIntervalSince1970: 1000))
        let expectedStartDate = Date(timeIntervalSince1970: 100)
        XCTAssertEqual(expectedStartDate, run.startDate)
    }
    
    func testLocationSegmentsReturnsOneSegmentOfOneLocationWithTheCorrectPropertiesWhenRunHasOneRunSegmentWithOneLocation() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.addToRunSegments(runSegmentMock(context: context))
        let locationSegments = run.locationSegments()
        XCTAssertEqual(1, run.runSegments?.count)
        XCTAssertEqual(1, locationSegments?.first?.count)
        XCTAssertEqual(2, locationSegments?.first?.first?.coordinate.latitude)
        XCTAssertEqual(1, locationSegments?.first?.first?.coordinate.longitude)
        XCTAssertEqual(Date(timeIntervalSince1970: 100), locationSegments?.first?.first?.timestamp)
    }
    
    func testCoordinateSegmentsReturnsOneSegmentOfOneCoordinateWhenRunHasOneRunSegmentWithOneLocation() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.addToRunSegments(runSegmentMock(context: context))
        XCTAssertEqual(1, run.runSegments?.count)
        XCTAssertEqual(1, run.coordinateSegments()?.first?.count)
    }
    
    func testCoordinateSegmentsReturnsOneSegmentOfTwoCoordinatesWhenRunHasOneRunSegmentWithTwoLocations() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.addToRunSegments(runSegmentMock(context: context, numberOfLocations: 2))
        XCTAssertEqual(1, run.runSegments?.count)
        XCTAssertEqual(2, run.coordinateSegments()?.first?.count)
    }
    
    func testCoordinateSegmentsReturnsTwoSegmentsOfTwoCoordinatesEachWhenRunHasTwoRunSegmentsWithTwoLocationsEach() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.addToRunSegments(runSegmentMock(context: context, numberOfLocations: 2))
        run.addToRunSegments(runSegmentMock(context: context, numberOfLocations: 2))
        XCTAssertEqual(2, run.runSegments?.count)
        XCTAssertEqual(2, run.coordinateSegments()?.first?.count)
        XCTAssertEqual(2, run.coordinateSegments()?.last?.count)
    }
    
    func testCoordinateSegmentsReturnsCoordinateWithLatitudeTwoAndLongitudeOneForLocationWithLatitudeTwoAndLongitudeOne() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.addToRunSegments(runSegmentMock(context: context))
        let coordinate = run.coordinateSegments()?.first?.first
        XCTAssertEqual(2, coordinate?.latitude)
        XCTAssertEqual(1, coordinate?.longitude)
    }
    
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
    
    func testFlattenedCoordinateSegmentsReturnsCoordinateSegmentsAsOneArray() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let locationSegments = [[CLLocation(latitude: 1, longitude: 1)], [CLLocation(latitude: 2, longitude: 2)]]
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        XCTAssertEqual(2, run.flattenedCoordinateSegments()?.count)
    }
    
    func testReachedCheckpointsForRunWithOneLocationSegmentContainingTwoLocationsWithDistanceBetweenOneAndTwoKilometersReturnsOneCheckpoint() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 1.01, longitude: 1)]
        ]
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        let checkpoints = run.reachedCheckpoints(distanceUnit: .kilometers)
        XCTAssertEqual(1, checkpoints?.count)
    }
    
    func testReachedCheckpointsForRunWithTwoLocationSegmentsContainingTwoLocationsEachDistanceBetweenOneAndTwoKilometersInEachSegmentReturnsTwoCheckpoints() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 1.01, longitude: 1)],
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 1.01, longitude: 1)]
        ]
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        let checkpoints = run.reachedCheckpoints(distanceUnit: .kilometers)
        XCTAssertEqual(2, checkpoints?.count)
    }
    
    func testStartAnnotationReturnsNilIfRunHasNoLocations() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: [])
        let startAnnotation = run.startAnnotation()
        XCTAssertNil(startAnnotation)
    }

    func testStartAnnotationReturnsAnnotationWithLocationOfFirstLocationOfRun() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 2, longitude: 2)]
        ]
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        let startAnnotation = run.startAnnotation()
        XCTAssertEqual(1, startAnnotation?.coordinate.latitude)
        XCTAssertEqual(1, startAnnotation?.coordinate.longitude)
    }

    func testEndAnnotationReturnsNilIfRunHasNoLocations() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: [])
        let endAnnotation = run.endAnnotation()
        XCTAssertNil(endAnnotation)
    }
    
    func testEndAnnotationReturnsAnnotationWithLocationOfLastLocationOfRun() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let locationSegments = [
            [CLLocation(latitude: 1, longitude: 1), CLLocation(latitude: 2, longitude: 2)]
        ]
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        let endAnnotation = run.endAnnotation()
        XCTAssertEqual(2, endAnnotation?.coordinate.latitude)
        XCTAssertEqual(2, endAnnotation?.coordinate.longitude)
    }
    
    func testSplitTimesReturnsPaceFiveMinutesPerKilometerForFirstKilometerAndSixMinutesPerKilometerForSecondKilometerWhenItTookFiveMinutesToRunFirstKilomerAndSixMinutesForSecond() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
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
        let run = ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: locationSegments)
        let splitTimes = run.splitTimes(distanceUnit: .kilometers, speedUnit: .minutesPerKilometer)
        XCTAssertEqual(2, splitTimes?.count)
        XCTAssertEqual("5:00", splitTimes?.first)
        XCTAssertEqual("6:00", splitTimes?.last)
    }
    
    func testAveragePaceReturnsSixMinutesForRunWithDistanceTenKilometersAndTimeSixtyMinutes() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context, distance: 10000, time: 3600, locationSegments: [])
        XCTAssertEqual(360, run.averagePace())
    }
    
    func testSimilarRunsRangeForTwoKilometerRunReturnsLowerBoundOneKilometerAndUpperBoundThreeKilometers() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.distance = 2000
        let range = run.similarRunsRange(distanceUnit: .kilometers)
        XCTAssertEqual(1000, range.lowerBound)
        XCTAssertEqual(3000, range.upperBound)
    }
    
    func testSimilarRunsRangeFor500MeterRunReturnsLowerBoundZeroKilometerAndUpperBoundTwoKilometers() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.distance = 500
        let range = run.similarRunsRange(distanceUnit: .kilometers)
        XCTAssertEqual(0, range.lowerBound)
        XCTAssertEqual(2000, range.upperBound)
    }
    
    func testSimilarRunsRange_withRangeContainingUpperAndLowerBoundsThatAreNotEqualToWholeKilometers_shouldReturnRangeWithLowerBoundRoundedDownToNearestKilometerAndUpperBoundRoundedUpToNearestKilometer() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.distance = 10500
        let range = run.similarRunsRange(distanceUnit: .kilometers)
        XCTAssertEqual(9000, range.lowerBound)
        XCTAssertEqual(11000, range.upperBound)
    }
    
    func testSimilarRunsRange_withRangeContainingUpperAndLowerBoundsThatAreNotEqualToWholeMiles_shouldReturnRangeWithLowerBoundRoundedDownToNearestMilAndUpperBoundRoundedUpToNearestMile() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let run = ManagedRunObject(context: context)
        run.distance = 10500
        let range = run.similarRunsRange(distanceUnit: .miles)
        XCTAssertEqual(8046.72, range.lowerBound)
        XCTAssertEqual(11265.408, range.upperBound)
    }
    

}

// MARK: Mocks
private extension RunTests {
    func runSegmentMock(context: NSManagedObjectContext, numberOfLocations: Int = 1) -> RunSegment {
        let runSegment = RunSegment(context: context)
        for _ in 1...numberOfLocations {
            runSegment.addToLocations(locationMock(context: context))
        }
        return runSegment
    }
    
    func locationMock(context: NSManagedObjectContext) -> Location {
        let location = Location(context: context)
        location.longitude = 1
        location.latitude = 2
        location.timestamp = Date(timeIntervalSince1970: 100)
        return location
    }
}


