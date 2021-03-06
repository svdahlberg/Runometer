//
//  CoreDataRunPersister.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreData
import CoreLocation

struct CoreDataRunPersister: RunPersisting {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.context) {
        self.context = context
    }
    
    func saveRun(distance: Meters, time: Seconds, locationSegments: [[CLLocation]]) -> Run {
        let run = ManagedRunObject(context: context, distance: distance, time: time, locationSegments: locationSegments)
        CoreDataStack.saveContext()
        return CoreDataRun(managedRunObject: run)
    }
    
    func delete(_ run: Run) {
        guard let run = run as? CoreDataRun else { return }
        try? CoreDataStack.deleteRun(run.managedRunObject)
    }
    
}
