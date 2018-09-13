//
//  StatisticsProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-12.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

struct StatisticsProvider {
    
    let runProvider: RunProvider
    
    init(runProvider: RunProvider = RunProvider()) {
        self.runProvider = runProvider
    }
    
    func statistics(_ completion: @escaping (Statistics) -> Void) {
        runProvider.runs { runs in
            completion(Statistics(runs: runs))
        }
    }
    
}
