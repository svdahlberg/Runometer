//
//  RunService.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-04.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import CoreData
import CoreLocation

struct RunService {
    static func saveRun(distance: Meters, time: Seconds, locationSegments: [[CLLocation]]) -> Run {
        let run = Run(context: CoreDataStack.context, distance: distance, time: time, locationSegments: locationSegments)
        CoreDataStack.saveContext()
        return run
    }
    
    static func savedRuns(context: NSManagedObjectContext = CoreDataStack.context) -> [Run]? {
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return try? context.fetch(fetchRequest)
    }
    
    static func delete(_ run: Run) {
        try? CoreDataStack.deleteRun(run)
    }
    
    static func savedRuns(withDifferenceInDistanceSmallerThanOrEqualTo distance: Meters, toDistanceOf run: Run, context: NSManagedObjectContext = CoreDataStack.context) -> [Run]? {
        return savedRuns(context: context)?.filter {
            abs(run.distance - $0.distance) <= distance
        }
    }
}
