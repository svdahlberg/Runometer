//
//  CoreDataRunProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreData
import CoreLocation

struct CoreDataRunProvider: RunProviding {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.context) {
        self.context = context
    }
    
    func runs(completion: ([RunProtocol]) -> Void) {
        let fetchRequest: NSFetchRequest<ManagedRunObject> = ManagedRunObject.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(ManagedRunObject.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let runs = try? context.fetch(fetchRequest).map { CoreDataRun(managedRunObject: $0) }
        completion(runs ?? [])
    }
    
}
