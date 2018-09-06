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
    func runs(completion: (_ runs: [Run]) -> Void)
}

struct RunProvider: RunProviding {
    
    private let coreDataRunProvider: CoreDataRunProvider
    
    init(coreDataRunProvider: CoreDataRunProvider = CoreDataRunProvider(),
         coreDataRunPersister: CoreDataRunPersister = CoreDataRunPersister()) {
        self.coreDataRunProvider = coreDataRunProvider
    }
    
    func runs(completion: ([Run]) -> Void) {
        coreDataRunProvider.runs {
            completion($0)
        }
    }
    
}

