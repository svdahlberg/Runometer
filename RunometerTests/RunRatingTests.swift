//
//  RunRatingTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreData


class RunRatingTests: XCTestCase {
    
    // MARK: Distance Rating
    func testDistanceRatingReturnsOneIfDistanceIsTheLongestOfTheDistances() {
        let distances = distancesMock()
        let distance = distances.last!
        let distanceRating = RunRating.distanceRating(for: distance, comparedTo: distances)
        XCTAssertEqual(1, distanceRating)
    }
    
    func testDistanceRatingReturnsZeroIfDistanceIsTheShortestOfTheDistances() {
        let distances = distancesMock()
        let distance = distances.first!
        let distanceRating = RunRating.distanceRating(for: distance, comparedTo: distances)
        XCTAssertEqual(0, distanceRating)
    }

    func testDistanceRatingReturnsZeroIfDistancesIsEmpty() {
        let distances = [Meters]()
        let distance: Meters = 1
        let distanceRating = RunRating.distanceRating(for: distance, comparedTo: distances)
        XCTAssertEqual(0, distanceRating)
    }

    func testDistanceRatingReturnsZeroPointFiveIfDistanceIsTheSameAsTheAverageDistanceOfDistances() {
        let distances = distancesMock()
        let distance = distances[4]
        let distanceRating = RunRating.distanceRating(for: distance, comparedTo: distances)
        XCTAssertEqual(0.5, distanceRating)
    }
    
    func testDistanceRatingReturnsZeroPointTwentyFiveIfDistanceIsTheSameAsAverageDistanceOfDistancesLessThanAverageDistance() {
        let distances = distancesMock()
        let distance = distances[2]
        let distanceRating = RunRating.distanceRating(for: distance, comparedTo: distances)
        XCTAssertEqual(0.25, distanceRating)
    }
    
    func testDistanceRatingReturnsZeroPointSeventyFiveIfDistanceIsTheSameAsAverageDistanceOfDistancesMoreThanAverageDistance() {
        let distances = distancesMock()
        let distance = distances[6]
        let distanceRating = RunRating.distanceRating(for: distance, comparedTo: distances)
        XCTAssertEqual(0.75, distanceRating)
    }
    
    // MARK: Time Rating
    func testTimeRatingReturnsZeroIfRunsIsEmpty() {
        let durations = [Seconds]()
        let duration = 0
        let timeRating = RunRating.timeRating(for: duration, comparedTo: durations)
        XCTAssertEqual(0, timeRating)
    }
    
    func testTimeRatingReturnsOneIfPaceOfRunIsTheFastestOutOfRuns() {
        let durations = durationsMock()
        let duration = durations.first!
        let timeRating = RunRating.timeRating(for: duration, comparedTo: durations)
        XCTAssertEqual(1, timeRating)
    }

    func testTimeRatingReturnsZeroIfPaceOfRunIsTheSlowestOutOfRuns() {
        let durations = durationsMock()
        let duration = durations.last!
        let timeRating = RunRating.timeRating(for: duration, comparedTo: durations)
        XCTAssertEqual(0, timeRating)
    }
    
    func testTimeRatingReturnsZeroPointFiveIfRunHasAveragePaceThatIsTheSameAsTheAverageAveragePaceRuns() {
        let durations = durationsMock()
        let duration = durations[4]
        let timeRating = RunRating.timeRating(for: duration, comparedTo: durations)
        XCTAssertEqual(0.5, timeRating)
    }
    
    func testTimeRatingReturnsZeroPointSeventyFiveIfRunHasAveragePaceThatIsTheSameAsTheAverageAveragePaceOfTheFastestHalfOfRuns() {
        let durations = durationsMock()
        let duration = durations[2]
        let timeRating = RunRating.timeRating(for: duration, comparedTo: durations)
        XCTAssertEqual(0.75, timeRating)
    }
    
    func testTimeRatingReturnsZeroPointTwentyFiveIfRunHasAveragePaceThatIsTheSameAsTheAverageAveragePaceOfTheSlowestHalfOfRuns() {
        let durations = durationsMock()
        let duration = durations[6]
        let timeRating = RunRating.timeRating(for: duration, comparedTo: durations)
        XCTAssertEqual(0.25, timeRating)
    }
}


private extension RunRatingTests {
    func distancesMock() -> [Meters] {
        return [
            1, 2, 3, 4, 5, 6, 7, 8, 9
        ]
    }
    
    func durationsMock() -> [Seconds] {
        return [
            1, 2, 3, 4, 5, 6, 7, 8, 9
        ]
    }
}
