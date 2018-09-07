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

struct HealthKitRunProvider: RunProviding {
    
    private let healthStore: HKHealthStore
    
    init(healthStore: HKHealthStore = HealthStoreManager.shared.healthStore) {
        self.healthStore = healthStore
    }
    
    func runs(completion: @escaping (_ runs: [Run]) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion([])
            return
        }
        
        let healthkitObjectTypes = Set([HKObjectType.workoutType(),
                                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                        HKObjectType.seriesType(forIdentifier: HKSeriesType.workoutRoute().identifier)!])
        
        healthStore.requestAuthorization(toShare: healthkitObjectTypes,
                                         read: healthkitObjectTypes) { (success, error) in
            let predicate = HKQuery.predicateForWorkouts(with: .running)
            let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                      predicate: predicate,
                                      limit: 0,
                                      sortDescriptors: nil,
                                      resultsHandler: { (query, results, error) in
                                        
                                        let runs: [HealthKitRun]? = results?.compactMap {
                                            guard let workout = $0 as? HKWorkout else { return nil }
                                            return HealthKitRun(workout: workout)
                                        }
                                        
                                        completion(runs ?? [])
            })
            
            self.healthStore.execute(query)
        }
    }
    
}
