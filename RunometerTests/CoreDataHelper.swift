//
//  CoreDataHelper.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import CoreData

struct CoreDataHelper {
    static func inMemoryManagedObjectContext() -> NSManagedObjectContext? {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            return nil
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            return nil
        }
        let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
}
