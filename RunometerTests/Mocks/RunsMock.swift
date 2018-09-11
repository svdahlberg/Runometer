//
//  RunsMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-12-26.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer
import CoreData

extension RunMock {
    
    class func runsMock() -> [RunMock] {
        return [
            RunMock(distance: 5000, duration: 1500, startDate: Date(), endDate: Date(timeIntervalSince1970: 2)), // average pace: 300 seconds
            RunMock(distance: 1000, duration: 200, startDate: Date(), endDate: Date(timeIntervalSince1970: 1)), // average pace: 200 seconds
            RunMock(distance: 4000, duration: 1600, startDate: Date(), endDate: Date(timeIntervalSince1970: 2)), // average pace: 400 seconds
            RunMock(distance: 6000, duration: 1800, startDate: Date(), endDate: Date(timeIntervalSince1970: 3)), // average pace: 300 seconds
            RunMock(distance: 10000, duration: 3000, startDate: Date(), endDate: Date(timeIntervalSince1970: 2)) // average pace: 300 seconds
        ]
    }
    
    class func runsWithLongestRunOneKilometerLongerThanNextLongestRun() -> [RunMock] {
        return Array(runsMock().dropLast())
    }
    
    class func runsWithLongestRunOneMeterLongerThanNextLongestRun() -> [RunMock] {
        var runs = Array(runsMock())
        runs.append(RunMock(distance: 10001, duration: 3600, startDate: Date(), endDate: Date(timeIntervalSince1970: 0)))
        return runs
    }
    
    class func runsWithShortestRunOneMeterShorterThanNextShortestRun() -> [RunMock] {
        var runs = Array(runsMock())
        runs.append(RunMock(distance: 999, duration: 360, startDate: Date(), endDate: Date(timeIntervalSince1970: 0)))
        return runs
    }
    
}
