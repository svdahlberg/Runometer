//
//  HealthKitRunProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-05.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import HealthKit

class HealthStoreManager {
    static let shared = HealthStoreManager()
    private init() {}
    let healthStore = HKHealthStore()
}

struct HealthKitRun {
    let distance: Meters
    let duration: Seconds
    
}

struct HealthKitRunProvider {
    
    private let healthStore: HKHealthStore
    
    init(healthStore: HKHealthStore = HealthStoreManager.shared.healthStore) {
        self.healthStore = healthStore
    }
    
    func runs() -> [Run] {
        guard HKHealthStore.isHealthDataAvailable() else { return [] }
        
        let healthkitObjectTypes = Set([HKObjectType.workoutType(),
                                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                        HKObjectType.seriesType(forIdentifier: HKSeriesType.workoutRoute().identifier)!])
        
        healthStore.requestAuthorization(toShare: healthkitObjectTypes, read: healthkitObjectTypes) { (success, error) in
            
            let predicate = HKQuery.predicateForWorkouts(with: .running)
            let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                      predicate: predicate,
                                      limit: 0,
                                      sortDescriptors: nil,
                                      resultsHandler: { (query, results, error) in
                                        
//                                        results?.forEach {
                                            self.route(for: results?.first as! HKWorkout)
//                                        }
                                        

                                        
            })
            
            self.healthStore.execute(query)
        }
        
        return []
    }
    
    func route(for workout: HKWorkout) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: workout)
        
        print(workout)
        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in

            
            self.locations(for: samples?.first as! HKWorkoutRoute)
            

        }

        healthStore.execute(routeQuery)
    }
    
    private func locations(for route: HKWorkoutRoute) {
        // Create the route query.
        let query = HKWorkoutRouteQuery(route: route) { (query, locations, done, error) in
            
            
            // Do something with this batch of location data.
            
            print(locations?.count)
            
            if done {
                // The query returned all the location data associated with the route.
                // Do something with the complete data set.
                print(locations?.count)
            }
            
        }
        
        healthStore.execute(query)
    }
    
    
}
