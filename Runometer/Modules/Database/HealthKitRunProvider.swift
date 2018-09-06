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

struct HealthKitRunProvider {
    
    func runs() -> [Run] {
        guard HKHealthStore.isHealthDataAvailable() else { return [] }
        let healthStore = HealthStoreManager.shared.healthStore
        healthStore.requestAuthorization(toShare: Set([HKObjectType.workoutType()]), read: Set([HKObjectType.workoutType()])) { (success, error) in
            
            let predicate = HKQuery.predicateForWorkouts(with: .running)
            let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                      predicate: predicate,
                                      limit: 0,
                                      sortDescriptors: nil,
                                      resultsHandler: { (query, results, error) in
//                                        print(results)
                                        
                                        results?.forEach {
                                            guard let workout = $0 as? HKWorkout else { return }
                                            let runningObjectQuery = HKQuery.predicateForObjects(from: workout)
                                            
                                            let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
                                                
                                                print(samples)
                                                
                                            }
                                            
                                            healthStore.execute(routeQuery)
                                        }
                                        

                                        
            })
            
            healthStore.execute(query)
        }
        
        return []
    }
    
}
