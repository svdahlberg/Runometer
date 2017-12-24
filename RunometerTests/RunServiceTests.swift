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
    
    func testSavedRunsReturnsRunsSortedByDate() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let runs = runsMock(context: context)
        XCTAssertEqual(runs.last?.distance, RunService.savedRuns(context: context)?.first?.distance)
        XCTAssertEqual(runs.first?.distance, RunService.savedRuns(context: context)?.last?.distance)
    }
 
    func testSavedRunsWithDifferenceInDistanceSmallerThanOrEqualToOneKilometerToRunWithDistanceFiveKilometerReturnsRunsWithDistancesBetweenFourAndSixKilometers() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let runs = runsMock(context: context)
        let run = runs[2]
        let runsWithSimilarDistance = RunService.savedRuns(withDifferenceInDistanceSmallerThanOrEqualTo: 1000, toDistanceOf: run, context: context)
        XCTAssertEqual(3, runsWithSimilarDistance?.count)
    }
    
    
}

private extension RunServiceTests {
    func runsMock(context: NSManagedObjectContext) -> [Run] {
        return [
            Run(context: context, distance: 1, time: 1, locationSegments: [], date: Date(timeIntervalSince1970: 1)),
            Run(context: context, distance: 4000, time: 2, locationSegments: [], date: Date(timeIntervalSince1970: 2)),
            Run(context: context, distance: 5000, time: 2, locationSegments: [], date: Date(timeIntervalSince1970: 2)),
            Run(context: context, distance: 6000, time: 2, locationSegments: [], date: Date(timeIntervalSince1970: 2)),
            Run(context: context, distance: 3, time: 3, locationSegments: [], date: Date(timeIntervalSince1970: 3))
        ]
    }
}
