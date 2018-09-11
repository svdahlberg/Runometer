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
    func runs(completion: @escaping (_ runs: [Run]) -> Void)
}

struct RunProvider: RunProviding {
    
    private let coreDataRunProvider: RunProviding
    private let healthKitRunProvider: RunProviding
    
    init(coreDataRunProvider: RunProviding = CoreDataRunProvider(),
         healthKitRunProvider: RunProviding = HealthKitRunProvider()) {
        self.coreDataRunProvider = coreDataRunProvider
        self.healthKitRunProvider = healthKitRunProvider
    }
    
    func runs(completion: @escaping (_ runs: [Run]) -> Void) {
        coreDataRunProvider.runs { coreDataRuns in
            self.healthKitRunProvider.runs { healthKitRuns in
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

