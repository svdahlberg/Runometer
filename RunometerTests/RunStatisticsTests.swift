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
    
    // MARK: All distances
    func testAllDistancesStatisticsText_withDistanceOneKilometerLongerThanLongestDistance_returnsLongestDistanceEverStringWithSingularUnitName() {
        let distance: Meters = 6000
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.allDistancesStatisticsText(for: distance, runService: RunServiceMockWithLongestRunOneKilometerLongerThanNextLongestRun(context: context))
        XCTAssertEqual(statisticsText, "Your longest run by 1 kilometer!")
    }

    func testAllDistancesStatisticsText_withDistanceFiveKilometersLongerThanLongestDistance_returnsLongestDistanceEverStringWithPluralUnitName() {
        let distance: Meters = 10000
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.allDistancesStatisticsText(for: distance, runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "Your longest run by 4 kilometers!")
    }

    func testAllDistancesStatisticsText_withDistanceLessThanTenMetersLongerThanLongestDistance_returnsLongestDistanceEverStringWithOutUnit() {
        let distance: Meters = 10001
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.allDistancesStatisticsText(for: distance, runService: RunServiceMockWithLongestRunOneMeterLongerThanNextLongestRun(context: context))
        XCTAssertEqual(statisticsText, "Your longest run!")
    }

    func testAllDistancesStatisticsText_withDistanceThreeKilometersShorterThanNextShortestDistance_returnsShortestDistanceEverStringWithPluralUnitName() {
        let distance: Meters = 1000
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.allDistancesStatisticsText(for: distance, runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "Your shortest run by 3 kilometers!")
    }

    func testAllDistancesStatisticsText_withDistanceShorterThanShortestDistanceByOneMeter_returnsShortestDistanceEverStringWithoutUnitName() {
        let distance: Meters = 999
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.allDistancesStatisticsText(for: distance, runService: RunServiceMockWithShortestRunOneMeterShorterThanNextShortestRun(context: context))
        XCTAssertEqual(statisticsText, "Your shortest run!")
    }
    
    func testAllDistancesStatisticsText_withDistanceShorterThanLongestDistance_returnsNumberOfKilometersShorterThanLongestRunText() {
        let distance: Meters = 5000
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.allDistancesStatisticsText(for: distance, runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "5 kilometers shorter than your farthest run.")
    }
    
    // MARK: Average pace of all runs
    
    func testAveragePaceStatisticsText_withAveragePaceFasterThanAveragePaceOfSavedRuns_returnsFasterThanAveragePaceText() {
        let averagePace = 200
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averagePaceStatisticsText(for: averagePace, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "1:40 faster than your average pace!")
    }
    
    func testAveragePaceStatisticsText_withAveragePaceSlowerThanAveragePaceOfSavedRuns_returnsSlowerThanAveragePaceText() {
        let averagePace = 400
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averagePaceStatisticsText(for: averagePace, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "1:40 slower than your average pace!")
    }
    
    func testAveragePaceStatisticsText_withAveragePaceTheSameAsAveragePaceOfSavedRuns_returnsSameAveragePaceText() {
        let averagePace = 300
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averagePaceStatisticsText(for: averagePace, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "As fast as your average pace.")
    }
    
    // MARK: Average pace for similar runs
    
    func testAveragePaceStatisticsTextForRunWithinRange_withPaceFasterThanAveragePaceOfRunsWithinRange_returnsFasterThanAveragePaceText() {
        let averagePace = 200
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let range = Meters(6000)...Meters(10000)
        let statisticsText = RunStatistics.averagePaceStatisticsText(for: averagePace, withinDistanceRange: range,  appConfiguration: AppConfigurationMock(), runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "1:40 faster than your average pace for 6 - 10 km runs!")
    }
    
    func testAveragePaceStatisticsTextForRunWithinRange_withPaceSlowerThanAveragePaceOfRunsWithinRange_returnsSlowerThanAveragePaceText() {
        let averagePace = 400
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let range = Meters(6000)...Meters(10000)
        let statisticsText = RunStatistics.averagePaceStatisticsText(for: averagePace, withinDistanceRange: range, runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "1:40 slower than your average pace for 6 - 10 km runs!")
    }
    
    func testAveragePaceStatisticsTextForRunWithinRange_withPaceEqualToAveragePaceOfRunsWithinRange_returnsSameAsAveragePaceText() {
        let averagePace = 300
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let range = Meters(6000)...Meters(10000)
        let statisticsText = RunStatistics.averagePaceStatisticsText(for: averagePace, withinDistanceRange: range,  appConfiguration: AppConfigurationMock(), runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "As fast as your average paced 6 - 10 km run.")
    }
    
    // MARK: Average time of all runs
    func testAverageTimeStatisticsText_withAverageTimeFasterThanAverageTimeOfSavedRuns_returnsFasterThanAverageTimeText() {
        let averageTime = 1520
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averageTimeStatisticsText(for: averageTime, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "1:40 shorter than your average run!")
    }
    
    func testAverageTimeStatisticsText_withAverageTimeSlowerThanAverageTimeOfSavedRuns_returnsSlowerThanAverageTimeText() {
        let averageTime = 1720
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averageTimeStatisticsText(for: averageTime, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "1:40 longer than your average run!")
    }
    
    func testAverageTimeStatisticsText_withAverageTImeTheSameAsAverageTImeOfSavedRuns_returnsSameAverageTimeText() {
        let averageTime = 1620
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averageTimeStatisticsText(for: averageTime, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "As long as your average run.")
    }
    
    // MARK: Average time of similar runs
    func testAverageTimeStatisticsTextForRunWithinRange_withTimeFasterThanAverageTimeOfRunsWithinRange_returnsFasterThanAverageTimeText() {
        let averageTime = 2300
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let range = Meters(6000)...Meters(10000)
        let statisticsText = RunStatistics.averageTimeStatisticsText(for: averageTime, withinDistanceRange: range, appConfiguration: AppConfigurationMock(), runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "1:40 shorter than your average 6 - 10 km run.")
    }
    
    func testAverageTimeStatisticsTextForRunWithinRange_withTimeSlowerThanAverageTimeOfRunsWithinRange_returnsSlowerThanAverageTimeText() {
        let averageTime = 2500
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let range = Meters(6000)...Meters(10000)
        let statisticsText = RunStatistics.averageTimeStatisticsText(for: averageTime, withinDistanceRange: range, appConfiguration: AppConfigurationMock(), runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "1:40 longer than your average 6 - 10 km run.")
    }
    
    func testAverageTimeStatisticsTextForRunWithinRange_withTimeEqualToAverageTimeOfRunsWithinRange_returnsSameAsAverageTimeText() {
        let averageTime = 2400
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let range = Meters(6000)...Meters(10000)
        let statisticsText = RunStatistics.averageTimeStatisticsText(for: averageTime, withinDistanceRange: range, appConfiguration: AppConfigurationMock(), runService: RunServiceMock(context: context))
        XCTAssertEqual(statisticsText, "As long as your average 6 - 10 km run.")
    }
    
    // MARK: Average distance
    func testAverageDistanceStatisticsText_withAverageDistanceLongerThanAverageDistanceOfSavedRuns_returnsLongerThanAverageDistanceText() {
        let averageDistance: Meters = 4200
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averageDistanceStatisticsText(for: averageDistance, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "1 kilometer shorter than your average run!")
    }
    
    func testAverageDistanceStatisticsText_withAverageDistanceShorterThanAverageDistanceOfSavedRuns_returnsShorterThanAverageDistanceText() {
        let averageDistance: Meters = 6200
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averageDistanceStatisticsText(for: averageDistance, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "1 kilometer longer than your average run!")
    }
    
    func testAverageDistanceStatisticsText_withAverageDistanceTheSameAsAverageDistanceOfSavedRuns_returnsSameAsAverageDistanceText() {
        let averageDistance: Meters = 5200
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let statisticsText = RunStatistics.averageDistanceStatisticsText(for: averageDistance, runService: RunServiceMock(context: context), appConfiguration: AppConfigurationMock())
        XCTAssertEqual(statisticsText, "As long as your average run.")
    }
    
    
    // MARK All times
    
    
    
    // MARK All paces
    
    
}

