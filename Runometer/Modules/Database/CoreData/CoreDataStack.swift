//
//  CoreDataStack.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-28.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStack {
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Runometer")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do { try context.save() }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func deleteRun(_ run: ManagedRunObject) throws {
        let context = persistentContainer.viewContext
        context.delete(run)
        try context.save()
    }
}


