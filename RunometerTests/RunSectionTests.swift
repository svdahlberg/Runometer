//
//  RunSectionTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2019-03-31.
//  Copyright © 2019 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class RunSectionTests: XCTestCase {
    
    var runsMock: [RunMock]!
    
    override func setUp() {
        super.setUp()
        runsMock = [
            RunMock(
                distance: 1,
                duration: 1,
                startDate: Date.date(from: "2016-04-14T10:44:00+0000")!,
                endDate: Date.date(from: "2016-04-17T10:44:00+0000")!
            ),
            RunMock(
                distance: 2,
                duration: 1,
                startDate: Date.date(from: "2016-04-15T10:44:00+0000")!,
                endDate: Date.date(from: "2016-04-15T10:44:00+0000")!
            ),
            RunMock(
                distance: 3,
                duration: 1,
                startDate: Date.date(from: "2016-05-14T10:44:00+0000")!,
                endDate: Date.date(from: "2016-05-14T10:44:00+0000")!
            )
        ]
    }
    
    override func tearDown() {
        runsMock = nil
        super.tearDown()
    }
    
    func testRunSectionsFromRuns_withTitleDateFormatterReturningMonthOfDate_shouldReturnRunSectionsForEveryMonthOfRunInRuns() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        // When
        let runSections = RunSection.runSections(from: runsMock, filter: .month, titleDateFormatter: dateFormatter)
        
        // Then
        XCTAssertEqual(runSections.count, 2)
    }

    func testRunSectionsFromRuns_shouldReturnRunSectionsSortedByEndDate() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        // When
        let runSections = RunSection.runSections(from: runsMock, filter: .month, titleDateFormatter: dateFormatter)
        
        // Then
        XCTAssertEqual(runSections[0].runs[0].distance, runsMock[2].distance)
        XCTAssertEqual(runSections[1].runs[1].distance, runsMock[1].distance)
        XCTAssertEqual(runSections[1].runs[0].distance, runsMock[0].distance)
    }
    
}

extension Date {
    
    static func date(from string: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: string)
    }
    
}
