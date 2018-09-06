//
//  HealthKitRun.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreLocation
import HealthKit

struct HealthKitRun: Run {
    
    var distance: Meters
    var duration: Seconds
    var startDate: Date
    var endDate: Date
    
    private let workout: HKWorkout
    
    init?(workout: HKWorkout) {
        guard let distance = workout.totalDistance?.doubleValue(for: HKUnit.meter()) else {
            return nil
        }
        self.distance = distance
        self.duration = Seconds(workout.duration)
        self.startDate = workout.startDate
        self.endDate = workout.endDate
        self.workout = workout
    }
    
    func locationSegments() -> [[CLLocation]]? {
        return nil
    }
    
}
