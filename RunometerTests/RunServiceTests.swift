//
//  RunServiceTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreData

class RunServiceTests: XCTestCase {
    
    func testSavedRunsReturnsRunsSortedByDateInDescendingOrder() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let _ = Run.runsMock(context: context)
        let savedRuns = RunService(context: context).savedRuns()
        XCTAssertEqual(1000, savedRuns?.last?.distance)
        XCTAssertEqual(6000, savedRuns?.first?.distance)
    }
    
    func testSavedRunsWithinDistanceRangeFourToSixKilometersReturnsAllSavedRunsWithDistancesBetweenFourAndSixKilometers() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let _ = Run.runsMock(context: context)
        let range = Meters(4000)...Meters(6000)
        let runsWithSimilarDistance = RunService(context: context).savedRuns(withinDistanceRange: range)
        XCTAssertEqual(3, runsWithSimilarDistance?.count)
    }
    
    func testAveragePaceForAllRunsReturnsAveragePace() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let _ = Run.runsMock(context: context)
        let averagePace = RunService(context: context).averagePaceOfSavedRuns()
        XCTAssertEqual(300, averagePace)
    }
    
    func testAveragePaceForAllRunsReturnsNilIfThereAreNoSavedRuns() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let averagePace = RunService(context: context).averagePaceOfSavedRuns()
        XCTAssertNil(averagePace)
    }
    
    func testAveragePaceForRunsWithinDistanceRangeFourToSixKilometersReturnsAveragePaceOfAllSavedRunsWithDistancesBetweenFourAndSixKilometer() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let _ = Run.runsMock(context: context)
        let range = Meters(4000)...Meters(6000)
        let averagePace = RunService(context: context).averagePaceOfSavedRuns(withinDistanceRange: range)
        XCTAssertEqual(333, averagePace)
    }
    
    func testAverageTimeOfRunsReturnsAverageTimeOfAllSavedRuns() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let _ = Run.runsMock(context: context)
        let averageTime = RunService(context: context).averageTimeOfSavedRuns()
        XCTAssertEqual(1620, averageTime)
    }
    
    func testAverageTimeForRunsWithinDistanceRangeFourToSixKilometersReturnsAverageTimeOfAllSavedRunsWithDistancesBetweenFourAndSixKilometer() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let _ = Run.runsMock(context: context)
        let range = Meters(4000)...Meters(6000)
        let averageTime = RunService(context: context).averageTimeOfSavedRuns(withinDistanceRange: range)
        XCTAssertEqual(1633, averageTime)
    }
    
    func testAverageDistanceOfRunsReturnsAverageDistanceOfAllSavedRuns() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let _ = Run.runsMock(context: context)
        let averageDistance = RunService(context: context).averageDistanceOfSavedRuns()
        XCTAssertEqual(5200, averageDistance)
    }
}
