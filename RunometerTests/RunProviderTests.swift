//
//  RunProviderTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreData

class RunProviderTests: XCTestCase {
    
    var sut: RunProvider!
    var coreDataProviderMock: RunProviderMock!
    var healthKitProviderMock: RunProviderMock!
    
    override func setUp() {
        super.setUp()
        coreDataProviderMock = RunProviderMock()
        healthKitProviderMock = RunProviderMock()
        sut = RunProvider(coreDataRunProvider: coreDataProviderMock, healthKitRunProvider: healthKitProviderMock)
    }
    
    override func tearDown() {
        coreDataProviderMock = nil
        healthKitProviderMock = nil
        sut = nil
        super.tearDown()
    }
    
    func testRuns_shouldInvokeRunsOnHealthKitProviderAndCoreDataProvider() {
        // Given
        let expectation = self.expectation(description: "should call completion")
        
        // When
        sut.runs { runs in
            // Then
            XCTAssertEqual(self.coreDataProviderMock.runsInvokeCount, 1)
            XCTAssertEqual(self.healthKitProviderMock.runsInvokeCount, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testRuns_shouldCallCompletionWithArgumentRunsEqualToSumOfRunsFromCoreDataProviderAndHealthKitProviderSortedByEndDate() {
        // Given
        let expectation = self.expectation(description: "should call completion")
        coreDataProviderMock.runsCompletionArgument = [RunMock(distance: 1, duration: 10, startDate: Date(timeIntervalSince1970: 1), endDate: Date(timeIntervalSince1970: 11)), RunMock(distance: 2, duration: 10, startDate: Date(timeIntervalSince1970: 2), endDate: Date(timeIntervalSince1970: 31))]
        healthKitProviderMock.runsCompletionArgument = [RunMock(distance: 3, duration: 10, startDate: Date(timeIntervalSince1970: 1), endDate: Date(timeIntervalSince1970: 21))]
        
        // When
        sut.runs { runs in
            // Then
            XCTAssertEqual(runs.count, 3)
            XCTAssertEqual(runs[0].distance, 2)
            XCTAssertEqual(runs[1].distance, 3)
            XCTAssertEqual(runs[2].distance, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
}

