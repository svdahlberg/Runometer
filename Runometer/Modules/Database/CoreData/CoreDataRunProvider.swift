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
    private let notificationCenter: NotificationCenter
    
    init(context: NSManagedObjectContext = CoreDataStack.context, notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.context = context
        self.notificationCenter = notificationCenter
    }
    
    func runs(filter: RunFilter? = nil, completion: @escaping (_ runs: [Run]) -> Void) {

        let fetchRequest: NSFetchRequest<ManagedRunObject> = ManagedRunObject.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(ManagedRunObject.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let filter = filter {
            fetchRequest.predicate = {
                var predicateFormat = ""
                var predicateArguments = [Date]()
                if let startDate = filter.startDate {
                    predicateFormat += "(startDate >= %@)"
                    predicateArguments.append(startDate)
                }
                if let endDate = filter.endDate {
                    if !predicateFormat.isEmpty {
                        predicateFormat += " AND "
                    }
                    predicateFormat += "(startDate <= %@)"
                    predicateArguments.append(endDate)
                }
                if !predicateFormat.isEmpty {
                    return NSPredicate(format: predicateFormat, argumentArray: predicateArguments)
                } else {
                    return nil
                }
            }()
        }

        let runs = try? context.fetch(fetchRequest).map { CoreDataRun(managedRunObject: $0) }
        completion(runs ?? [])
    }
    
}

extension CoreDataRunProvider: RunObserving {

    func observe(_ completion: @escaping ([Run]) -> Void) {
        notificationCenter.addObserver(forName: .NSManagedObjectContextDidSave, object: context, queue: .main) { (_) in
            self.runs { allRuns in
                completion(allRuns)
            }
        }
    }

}
