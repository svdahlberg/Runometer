//
//  RunRepositoryTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 4/22/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import DependencyContainer

class RunRepositoryTests: XCTestCase {

    var sut: RunRepository!
    var container: DependencyContainer!

    override func setUp() {
        super.setUp()

        container = DependencyContainer()

        container.register(RunProviding.self, resolver: {
            let runProviderMock = RunProviderMock()
            let runs = [
                RunMock(distance: 1500),
                RunMock(distance: 10000),
                RunMock(distance: 3400),
                RunMock(distance: 21043),
                RunMock(distance: 1401),
                RunMock(distance: 6903),
                RunMock(distance: 5993),
                RunMock(distance: 6005),
                RunMock(distance: 5899),
                RunMock(distance: 10043)
            ]
            runProviderMock.runsCompletionArgument = runs
            return runProviderMock
        })

        container.register(Settings.self, resolver: {
            SettingsMock(
                distanceUnit: .kilometers,
                audioFeedbackDistance: true,
                audioFeedbackTime: true,
                audioFeedbackAveragePace: true,
                audioTrigger: .distance,
                audioTimingInterval: 1
            )
        })

        sut = RunRepository(container: container)
    }

    func testRunsGroupedBySililarDistance_shouldReturnRunsGroupedBySililarDistance() {
        // Given
        let expectaion = self.expectation(description: "should return grouped runs")

        // When
        sut.runsGroupedBySimilarDistance { (groups) in
            // Then
            XCTAssertEqual(groups.count, 5)
            XCTAssertEqual(groups[0].name, "all runs")
            XCTAssertEqual(groups[0].runs.count, 10)
            XCTAssertEqual(groups[1].name, "1 - 4 km runs")
            XCTAssertEqual(groups[1].runs.count, 3)
            XCTAssertEqual(groups[2].name, "5 - 7 km runs")
            XCTAssertEqual(groups[2].runs.count, 4)
            XCTAssertEqual(groups[3].name, "10 - 11 km runs")
            XCTAssertEqual(groups[3].runs.count, 2)
            XCTAssertEqual(groups[4].name, "21 - 22 km runs")
            XCTAssertEqual(groups[4].runs.count, 1)
            expectaion.fulfill()
        }

        wait(for: [expectaion], timeout: 1)
    }

}

extension RunMock {

    /// Convenience initializer that initilizes run with only distance.
    /// Use when the only thing you care about is distance.
    convenience init(distance: Meters) {
        self.init(distance: distance, duration: 0, startDate: Date(), endDate: Date())
    }

}
