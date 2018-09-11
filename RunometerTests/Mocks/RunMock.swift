//
//  RunMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-09-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer
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
    
}
