//
//  RunProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-04.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import CoreData
import CoreLocation

protocol RunProviding {
    func runs(filter: RunFilter?, completion: @escaping (_ runs: [Run]) -> Void)
}

protocol RunObserving {
    func observe(_ completion: @escaping (_ runs: [Run]) -> Void)
}

struct RunProvider: RunProviding {

    typealias RunProvidingAndObserving = RunProviding & RunObserving

    private let coreDataRunProvider: RunProvidingAndObserving
    private let healthKitRunProvider: RunProvidingAndObserving
    
    init(coreDataRunProvider: RunProvidingAndObserving = CoreDataRunProvider(),
         healthKitRunProvider: RunProvidingAndObserving = HealthKitRunProvider()) {
        self.coreDataRunProvider = coreDataRunProvider
        self.healthKitRunProvider = healthKitRunProvider
    }
    
    func runs(filter: RunFilter? = nil, completion: @escaping (_ runs: [Run]) -> Void) {
        coreDataRunProvider.runs(filter: filter) { coreDataRuns in
            self.healthKitRunProvider.runs(filter: filter) { healthKitRuns in
                let allRuns = (healthKitRuns + coreDataRuns).sorted {
                    $1.endDate < $0.endDate
                }

                DispatchQueue.main.async {
                    completion(allRuns)
                }
            }
        }
    }
    
}

extension RunProvider: RunObserving {

    func observe(_ completion: @escaping ([Run]) -> Void) {
        healthKitRunProvider.observe { runs in
            self.runs { allRuns in
                completion(allRuns)
            }
        }

        coreDataRunProvider.observe { runs in
            self.runs { allRuns in
                completion(allRuns)
            }
        }
    }

}
