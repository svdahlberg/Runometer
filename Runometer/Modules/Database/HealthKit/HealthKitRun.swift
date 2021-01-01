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
    private let healthStore: HKHealthStore
    
    init?(workout: HKWorkout, healthStore: HKHealthStore = HealthStoreManager.shared.healthStore) {
        guard let distance = workout.totalDistance?.doubleValue(for: HKUnit.meter()) else {
            return nil
        }
        self.distance = distance
        self.duration = Seconds(workout.duration)
        self.startDate = workout.startDate
        self.endDate = workout.endDate
        self.workout = workout
        self.healthStore = healthStore
    }
    
    func locationSegments(completion: @escaping ([[CLLocation]]) -> Void) {
        
        route(for: workout) { (route: HKWorkoutRoute?) in
            guard let route = route else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            self.locations(for: route) { locations in
                
                DispatchQueue.main.async {
                    completion(self.splitIntoSegments(locations))
                }
                
            }
        }
        
    }
    
    private func route(for workout: HKWorkout, completion: @escaping (HKWorkoutRoute?) -> Void) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: workout)
        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            completion(samples?.first as? HKWorkoutRoute)
        }
        
        healthStore.execute(routeQuery)
    }
    
    private func locations(for route: HKWorkoutRoute, completion: @escaping ([CLLocation]) -> Void) {
        
        var result = [CLLocation]()
        
        let query = HKWorkoutRouteQuery(route: route) { (query, locations, done, error) in
            guard !done else {
                if let locations = locations {
                    result.append(contentsOf: locations)
                }
                
                completion(result)
                return
            }
            
            if let locations = locations {
                result.append(contentsOf: locations)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func splitIntoSegments(_ locations: [CLLocation]) -> [[CLLocation]] {
        let pauseEvents = workout.workoutEvents?.filter {
            $0.type == HKWorkoutEventType.pause
        } ?? []
        
        var result = [[CLLocation]]()
        var index = 0
        
        for pause in pauseEvents {
            guard let pauseLocation = closestValue(in: locations, to: pause.dateInterval.start),
            let pauseLocationIndex = locations.firstIndex(of: pauseLocation) else { continue }
            let segment = Array(locations[index ..< Int(pauseLocationIndex.magnitude)])
            result.append(segment)
            guard let resumeLocation = closestValue(in: locations, to: pause.dateInterval.end),
            let resumeLocationIndex = locations.firstIndex(of: resumeLocation) else { continue }
            index = resumeLocationIndex + 1
        }

        let segment = Array(locations[index ..< locations.count])
        result.append(segment)
        
        return result
    }
    
    private func closestValue(in locations: [CLLocation], to date: Date) -> CLLocation? {
        guard let firstLocation = locations.first else { return nil }
        return locations.reduce(firstLocation) {
            let x = abs($1.timestamp.timeIntervalSince1970 - date.timeIntervalSince1970)
            let y = abs($0.timestamp.timeIntervalSince1970 - date.timeIntervalSince1970)
            return x < y ? $1 : $0
        }
    }
    
}
