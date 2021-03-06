//
//  RunPersister.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreData
import CoreLocation

protocol RunPersisting {
    func saveRun(distance: Meters, time: Seconds, locationSegments: [[CLLocation]]) -> Run
    func delete(_ run: Run)
}

struct RunPersister: RunPersisting {
    
    private let coreDataRunPersister: CoreDataRunPersister
    
    init(coreDataRunPersister: CoreDataRunPersister = CoreDataRunPersister()) {
        self.coreDataRunPersister = coreDataRunPersister
    }
    
    func saveRun(distance: Meters, time: Seconds, locationSegments: [[CLLocation]]) -> Run {
        return coreDataRunPersister.saveRun(distance: distance, time: time, locationSegments: locationSegments)
    }
    
    func delete(_ run: Run) {
        coreDataRunPersister.delete(run)
    }
    
}
