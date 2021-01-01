//
//  RunMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-09-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreLocation

struct RunProviderMock: RunProviding {

    func runs(filter: RunFilter? = nil, completion: @escaping ([Run]) -> Void) {
        completion(RunMock.runsMock)
    }

}

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

    static var runsMock: [RunMock] {
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
