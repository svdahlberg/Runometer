//
//  HealthKitRunProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-05.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import HealthKit
import WidgetKit

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
    
    func runs(filter: RunFilter? = nil, completion: @escaping (_ runs: [Run]) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion([])
            return
        }

        let healthkitObjectTypes = Set([
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKObjectType.seriesType(forIdentifier: HKSeriesType.workoutRoute().identifier)
            ].compactMap { $0 })
        
        healthStore.requestAuthorization(toShare: nil, read: healthkitObjectTypes) { (success, error) in

            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                HKQuery.predicateForSamples(withStart: filter?.startDate, end: filter?.endDate, options: []),
                HKQuery.predicateForWorkouts(with: .running)
            ])

            let query = HKSampleQuery(
                sampleType: HKObjectType.workoutType(),
                predicate: predicate,
                limit: 0,
                sortDescriptors: nil,
                resultsHandler: { (query, results, error) in

                    let runs: [HealthKitRun]? = results?.compactMap {
                        guard let workout = $0 as? HKWorkout else { return nil }
                        return HealthKitRun(workout: workout)
                    }

                    completion(runs ?? [])
                }
            )
            
            self.healthStore.execute(query)
        }
    }

}

extension HealthKitRunProvider: RunObserving {

    func observe(_ completion: @escaping ([Run]) -> Void) {

        healthStore.enableBackgroundDelivery(for: HKObjectType.workoutType(), frequency: .immediate) { (success, error) in
            
        }
        
        let observerQuery = HKObserverQuery(sampleType: HKObjectType.workoutType(), predicate: nil) { (query, completionHandler, error) in

            // I would like to call this in the completion block in `AppCoordinator.swift`. But for some reason that does not get called when the app is in the background, so this code goes here for now.
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadTimelines(ofKind: "RunStatisticWidget")
            }

            self.runs { allRuns in
                completion(allRuns)
                completionHandler()
            }
        }

        healthStore.execute(observerQuery)
    }

}
