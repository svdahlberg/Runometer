//
//  CoreDataProviderTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 12/6/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import XCTest
import CoreData
@testable import Runometer

class CoreDataProviderTests: XCTestCase {

    var sut: CoreDataRunProvider!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        context = CoreDataHelper.inMemoryManagedObjectContext()!
        sut = CoreDataRunProvider(context: context)
    }

    func testRuns_withStartAndEndDateFilter_shouldReturnFilteredRuns() {
        // Given
        let runsMock = [
            runMock(date: Date().startOfYear!),
            runMock(date: Date().startOfMonth!),
            runMock(date: Date().startOfWeek!)
        ]
        let filter = RunFilter(
            startDate: Date().startOfMonth?.addingTimeInterval(-.twentyFourHours),
            endDate: Date()
        )
        let expectation = self.expectation(description: "should return filtered runs")

        // When
        sut.runs(filter: filter) { filteredRuns in
            // Then
            XCTAssertEqual(filteredRuns.count, 2)
            XCTAssertEqual(filteredRuns[0].startDate, runsMock[1].startDate)
            XCTAssertEqual(filteredRuns[1].startDate, runsMock[2].startDate)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Helpers

    /// Returns instance of `ManagedRunObject` with the `startDate` and `endDate` properties set to `date`
    func runMock(date: Date) -> ManagedRunObject {
        ManagedRunObject(context: context, distance: 0, time: 0, locationSegments: [], date: date)
    }

}

extension TimeInterval {

    static var twentyFourHours: TimeInterval { 86400 }

}
