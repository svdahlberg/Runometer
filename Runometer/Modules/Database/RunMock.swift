//
//  RunMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-09-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreLocation

class RunMock: Run {
    
    var distance: Meters
    var duration: Seconds
    var startDate: Date
    var endDate: Date
    
    var locationSegmentsInvokeCount: Int = 0
    var locationSegmentsCompletionArgument: [[CLLocation]]?
    
    func locationSegments(completion: @escaping ([[CLLocation]]) -> Void) {
        locationSegmentsInvokeCount += 1
        completion(locationSegmentsCompletionArgument ?? [])
    }
    
    init(distance: Meters, duration: Seconds, startDate: Date, endDate: Date) {
        self.distance = distance
        self.duration = duration
        self.startDate = startDate
        self.endDate = endDate
    }

    static var runs: [RunMock] {
        [
            RunMock(
                distance: 10000,
                duration: 3600,
                startDate: Date(),
                endDate: Date()
            ),
            RunMock(
                distance: 12000,
                duration: 4000,
                startDate: Date.yesterday,
                endDate: Date.yesterday
            ),
            RunMock(
                distance: 10000,
                duration: 3600,
                startDate: Date.lastMonth,
                endDate: Date.lastMonth
            )
        ]
    }

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

extension Date {

    static var yesterday: Date {
        Date(timeIntervalSinceNow: -Double(Seconds.twentyFourHours))
    }

    static var lastWeek: Date {
        Date(timeIntervalSinceNow: -Double(Seconds.twentyFourHours * 7))
    }

    static var lastMonth: Date {
        Date(timeIntervalSinceNow: -Double(Seconds.twentyFourHours * 31))
    }

}

extension Seconds {

    static var oneHour: Seconds { 3600 }

    static var twentyFourHours: Seconds { 86400 }

}
