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
    
    
    
//    func route(for workout: HKWorkout) {
//        let runningObjectQuery = HKQuery.predicateForObjects(from: workout)
//        
//        print(workout)
//        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
//            
//            
//            self.locations(for: samples?.first as! HKWorkoutRoute)
//            
//            
//        }
//        
//        healthStore.execute(routeQuery)
//    }
//    
//    private func locations(for route: HKWorkoutRoute, completion: ([[CLLocation]] -> Void)) {
//        // Create the route query.
//        let query = HKWorkoutRouteQuery(route: route) { (query, locations, done, error) in
//            
//            
//            // Do something with this batch of location data.
//            
//            print(locations?.count)
//            
//            if done {
//                // The query returned all the location data associated with the route.
//                // Do something with the complete data set.
//                print(locations?.count)
//            }
//            
//        }
//        
//        healthStore.execute(query)
//    }
    
    
}
