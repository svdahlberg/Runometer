//
//  RunStatisticsTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-12-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreData

class RunStatisticsTests: XCTestCase {
    
    private var sut: RunStatistics!
    
    override func setUp() {
        super.setUp()
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = RunStatistics(appConfiguration: AppConfigurationMock(), runService: RunServiceMock(context: context))
    }
    
    // MARK: Average pace of all runs

    func testAveragePaceStatisticsText_withAveragePaceFasterThanAveragePaceOfSavedRuns_returnsFasterThanAveragePaceText() {
        let averagePace = 200
        let statisticsText = sut.averagePaceStatisticsText(for: averagePace)
        XCTAssertEqual(statisticsText, "1:40 faster than your average pace!")
    }

    func testAveragePaceStatisticsText_withAveragePaceSlowerThanAveragePaceOfSavedRuns_returnsSlowerThanAveragePaceText() {
        let averagePace = 400
        let statisticsText = sut.averagePaceStatisticsText(for: averagePace)
        XCTAssertEqual(statisticsText, "1:40 slower than your average pace!")
    }

    func testAveragePaceStatisticsText_withAveragePaceTheSameAsAveragePaceOfSavedRuns_returnsSameAveragePaceText() {
        let averagePace = 300
        let statisticsText = sut.averagePaceStatisticsText(for: averagePace)
        XCTAssertEqual(statisticsText, "As fast as your average pace.")
    }

    // MARK: Average pace for similar runs

    func testAveragePaceStatisticsTextForRunWithinRange_withPaceFasterThanAveragePaceOfRunsWithinRange_returnsFasterThanAveragePaceText() {
        let averagePace = 200
        let range = Meters(6000)...Meters(10000)
        let statisticsText = sut.averagePaceStatisticsText(for: averagePace, withinDistanceRange: range)
        XCTAssertEqual(statisticsText, "1:40 faster than your average pace for 6 - 10 km runs!")
    }

    func testAveragePaceStatisticsTextForRunWithinRange_withPaceSlowerThanAveragePaceOfRunsWithinRange_returnsSlowerThanAveragePaceText() {
        let averagePace = 400
        let range = Meters(6000)...Meters(10000)
        let statisticsText = sut.averagePaceStatisticsText(for: averagePace, withinDistanceRange: range)
        XCTAssertEqual(statisticsText, "1:40 slower than your average pace for 6 - 10 km runs!")
    }

    func testAveragePaceStatisticsTextForRunWithinRange_withPaceEqualToAveragePaceOfRunsWithinRange_returnsSameAsAveragePaceText() {
        let averagePace = 300
        let range = Meters(6000)...Meters(10000)
        let statisticsText = sut.averagePaceStatisticsText(for: averagePace, withinDistanceRange: range)
        XCTAssertEqual(statisticsText, "As fast as your average paced 6 - 10 km run.")
    }

    // MARK: Average time of all runs
    func testAverageTimeStatisticsText_withAverageTimeFasterThanAverageTimeOfSavedRuns_returnsFasterThanAverageTimeText() {
        let averageTime = 1520
        let statisticsText = sut.averageTimeStatisticsText(for: averageTime)
        XCTAssertEqual(statisticsText, "1 minute, 40 seconds shorter than your average run!")
    }

    func testAverageTimeStatisticsText_withAverageTimeSlowerThanAverageTimeOfSavedRuns_returnsSlowerThanAverageTimeText() {
        let averageTime = 1720
        let statisticsText = sut.averageTimeStatisticsText(for: averageTime)
        XCTAssertEqual(statisticsText, "1 minute, 40 seconds longer than your average run!")
    }

    func testAverageTimeStatisticsText_withAverageTImeTheSameAsAverageTImeOfSavedRuns_returnsSameAverageTimeText() {
        let averageTime = 1620
        let statisticsText = sut.averageTimeStatisticsText(for: averageTime)
        XCTAssertEqual(statisticsText, "As long as your average run.")
    }

    // MARK: Average time of similar runs
    func testAverageTimeStatisticsTextForRunWithinRange_withTimeFasterThanAverageTimeOfRunsWithinRange_returnsFasterThanAverageTimeText() {
        let averageTime = 2300
        let range = Meters(6000)...Meters(10000)
        let statisticsText = sut.averageTimeStatisticsText(for: averageTime, withinDistanceRange: range)
        XCTAssertEqual(statisticsText, "1 minute, 40 seconds shorter than your average 6 - 10 km run.")
    }

    func testAverageTimeStatisticsTextForRunWithinRange_withTimeSlowerThanAverageTimeOfRunsWithinRange_returnsSlowerThanAverageTimeText() {
        let averageTime = 2500
        let range = Meters(6000)...Meters(10000)
        let statisticsText = sut.averageTimeStatisticsText(for: averageTime, withinDistanceRange: range)
        XCTAssertEqual(statisticsText, "1 minute, 40 seconds longer than your average 6 - 10 km run.")
    }

    func testAverageTimeStatisticsTextForRunWithinRange_withTimeEqualToAverageTimeOfRunsWithinRange_returnsSameAsAverageTimeText() {
        let averageTime = 2400
        let range = Meters(6000)...Meters(10000)
        let statisticsText = sut.averageTimeStatisticsText(for: averageTime, withinDistanceRange: range)
        XCTAssertEqual(statisticsText, "As long as your average 6 - 10 km run.")
    }

    // MARK: Average distance
    func testAverageDistanceStatisticsText_withAverageDistanceLongerThanAverageDistanceOfSavedRuns_returnsLongerThanAverageDistanceText() {
        let averageDistance: Meters = 4200
        let statisticsText = sut.averageDistanceStatisticsText(for: averageDistance)
        XCTAssertEqual(statisticsText, "1 kilometer shorter than your average run!")
    }

    func testAverageDistanceStatisticsText_withAverageDistanceShorterThanAverageDistanceOfSavedRuns_returnsShorterThanAverageDistanceText() {
        let averageDistance: Meters = 6200
        let statisticsText = sut.averageDistanceStatisticsText(for: averageDistance)
        XCTAssertEqual(statisticsText, "1 kilometer longer than your average run!")
    }

    func testAverageDistanceStatisticsText_withAverageDistanceTheSameAsAverageDistanceOfSavedRuns_returnsSameAsAverageDistanceText() {
        let averageDistance: Meters = 5200
        let statisticsText = sut.averageDistanceStatisticsText(for: averageDistance)
        XCTAssertEqual(statisticsText, "As long as your average run.")
    }
    
    // MARK: All distances
    func testAllDistancesStatisticsText_withDistanceOneKilometerLongerThanNextLongestDistance_returnsLongestDistanceEverStringWithSingularUnitName() {
        let distance: Meters = 6000
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = RunStatistics(appConfiguration: AppConfigurationMock(), runService: RunServiceMockWithLongestRunOneKilometerLongerThanNextLongestRun(context: context))
        let statisticsText = sut.allDistancesStatisticsText(for: distance)
        XCTAssertEqual(statisticsText, "Your longest run by 1 kilometer!")
    }
    
    func testAllDistancesStatisticsText_withDistanceFiveKilometersLongerThanNextLongestDistance_returnsLongestDistanceEverStringWithPluralUnitName() {
        let distance: Meters = 10000
        let statisticsText = sut.allDistancesStatisticsText(for: distance)
        XCTAssertEqual(statisticsText, "Your longest run by 4 kilometers!")
    }
    
    func testAllDistancesStatisticsText_withDistanceLessThanTenMetersLongerThanNextLongestDistance_returnsLongestDistanceEverString() {
        let distance: Meters = 10001
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = RunStatistics(appConfiguration: AppConfigurationMock(), runService: RunServiceMockWithLongestRunOneMeterLongerThanNextLongestRun(context: context))
        let statisticsText = sut.allDistancesStatisticsText(for: distance)
        XCTAssertEqual(statisticsText, "Your longest run by .001 kilometers!")
    }
    
    func testAllDistancesStatisticsText_withDistanceThreeKilometersShorterThanNextShortestDistance_returnsShortestDistanceEverStringWithPluralUnitName() {
        let distance: Meters = 1000
        let statisticsText = sut.allDistancesStatisticsText(for: distance)
        XCTAssertEqual(statisticsText, "Your shortest run by 3 kilometers!")
    }
    
    func testAllDistancesStatisticsText_withDistanceShorterThanNextShortestDistanceByOneMeter_returnsShortestDistanceEverString() {
        let distance: Meters = 999
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = RunStatistics(appConfiguration: AppConfigurationMock(), runService: RunServiceMockWithShortestRunOneMeterShorterThanNextShortestRun(context: context))
        let statisticsText = sut.allDistancesStatisticsText(for: distance)
        XCTAssertEqual(statisticsText, "Your shortest run by .001 kilometers!")
    }
    
    func testAllDistancesStatisticsText_withDistanceShorterThanNextLongestDistance_returnsNumberOfKilometersShorterThanLongestRunText() {
        let distance: Meters = 5000
        let statisticsText = sut.allDistancesStatisticsText(for: distance)
        XCTAssertEqual(statisticsText, "5 kilometers shorter than your farthest run.")
    }
    
    func testAllDistancesStatisticsText_withOneSavedRun_returnsLongestRunText() {
        let distance: Meters = 5000
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = RunStatistics(appConfiguration: AppConfigurationMock(), runService: RunServiceMockWithOneSavedRun(context: context))
        let statisticsText = sut.allDistancesStatisticsText(for: distance)
        XCTAssertEqual(statisticsText, "Your longest run!")
    }
    
    
    // MARK All times
    
    func testAllTimesStatisticsText_withFastestTime_returnsFastestRunString() {
        let time: Seconds = 200
        let statisticsText = sut.allTimesStatisticsText(for: time)
        XCTAssertEqual(statisticsText, "Your shortest run by 21 minutes, 40 seconds!")
    }
    
    func testAllTimesStatisticsText_withLongestTime_returnsLongestRunString() {
        let time: Seconds = 3000
        let statisticsText = sut.allTimesStatisticsText(for: time)
        XCTAssertEqual(statisticsText, "Your longest run by 20 minutes!")
    }
    
    func testAllTimesStatisticsText_withTimeBetweenFastestAndLongestTime_returnsAmountOfTimeShorterThanLongestRun() {
        let time: Seconds = 1500
        let statisticsText = sut.allTimesStatisticsText(for: time)
        XCTAssertEqual(statisticsText, "25 minutes shorter than your longest run.")
    }
    
    func testAllTimesStatisticsText_withOneSavedRun_returnsLongestRunText() {
        let time: Seconds = 1500
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = RunStatistics(appConfiguration: AppConfigurationMock(), runService: RunServiceMockWithOneSavedRun(context: context))
        let statisticsText = sut.allTimesStatisticsText(for: time)
        XCTAssertEqual(statisticsText, "Your longest run!")
    }
    
    // MARK All paces
    
    func testAllPacesStatisticsText_withFastestPace_returnsFastestRunString() {
        let pace: Seconds = 200
        let statisticsText = sut.allPacesStatisticsText(for: pace)
        XCTAssertEqual(statisticsText, "Your fastest pace by 1:40!")
    }
    
    func testAllPacesStatisticsText_withSlowestPace_returnsSlowestRunString() {
        let pace: Seconds = 400
        let statisticsText = sut.allPacesStatisticsText(for: pace)
        XCTAssertEqual(statisticsText, "Your slowest pace by 1:40!")
    }
    
    func testAllPacesStatisticsText_withPaceBetweenFastestAndSlowestPace_returnsDifferenceInPaceBetweenRunAndFastestRunString() {
        let pace: Seconds = 300
        let statisticsText = sut.allPacesStatisticsText(for: pace)
        XCTAssertEqual(statisticsText, "1:40 slower than your fastest pace.")
    }
    
    func testAllPacesStatisticsText_withOneSavedRun_returnsFastestPaceText() {
        let pace: Seconds = 300
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = RunStatistics(appConfiguration: AppConfigurationMock(), runService: RunServiceMockWithOneSavedRun(context: context))
        let statisticsText = sut.allPacesStatisticsText(for: pace)
        XCTAssertEqual(statisticsText, "Your fastest pace!")
    }
}

