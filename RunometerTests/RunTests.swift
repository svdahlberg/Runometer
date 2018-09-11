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
    
    // MARK: - averagePace
    
    func testAveragePace_withSpeedUnitMinutesPerKilometer_shouldReturnCorrectlyCalculatedPace() {
        // Given
        let run = RunMock(distance: 1000, duration: 500, startDate: Date(), endDate: Date())
        
        // When
        let averagePace = run.averagePace(speedUnit: .minutesPerKilometer)
        
        // Then
        XCTAssertEqual(averagePace, 500)
    }
    
    func testAveragePace_withSpeedUnitMinutesPerMile_shouldReturnCorrectlyCalculatedPace() {
        // Given
        let run = RunMock(distance: 1609, duration: 500, startDate: Date(), endDate: Date())
        
        // When
        let averagePace = run.averagePace(speedUnit: .minutesPerMile)
        
        // Then
        XCTAssertEqual(averagePace, 500)
    }
    
    // MARK: - similarRunsRange
    
    func testSimilarRunsRangeForTwoKilometerRunReturnsLowerBoundOneKilometerAndUpperBoundThreeKilometers() {
        let run = RunMock(distance: 2000, duration: 1, startDate: Date(), endDate: Date())
        let range = run.similarRunsRange(distanceUnit: .kilometers)
        XCTAssertEqual(1000, range.lowerBound)
        XCTAssertEqual(3000, range.upperBound)
    }
    
    func testSimilarRunsRangeFor500MeterRunReturnsLowerBoundZeroKilometerAndUpperBoundTwoKilometers() {
        let run = RunMock(distance: 500, duration: 1, startDate: Date(), endDate: Date())
        let range = run.similarRunsRange(distanceUnit: .kilometers)
        XCTAssertEqual(0, range.lowerBound)
        XCTAssertEqual(2000, range.upperBound)
    }
    
    func testSimilarRunsRange_withRangeContainingUpperAndLowerBoundsThatAreNotEqualToWholeKilometers_shouldReturnRangeWithLowerBoundRoundedDownToNearestKilometerAndUpperBoundRoundedUpToNearestKilometer() {
        let run = RunMock(distance: 10500, duration: 1, startDate: Date(), endDate: Date())
        let range = run.similarRunsRange(distanceUnit: .kilometers)
        XCTAssertEqual(9000, range.lowerBound)
        XCTAssertEqual(11000, range.upperBound)
    }
    
    func testSimilarRunsRange_withRangeContainingUpperAndLowerBoundsThatAreNotEqualToWholeMiles_shouldReturnRangeWithLowerBoundRoundedDownToNearestMilAndUpperBoundRoundedUpToNearestMile() {
        let run = RunMock(distance: 10500, duration: 1, startDate: Date(), endDate: Date())
        let range = run.similarRunsRange(distanceUnit: .miles)
        XCTAssertEqual(8046.72, range.lowerBound)
        XCTAssertEqual(11265.408, range.upperBound)
    }
    
}

