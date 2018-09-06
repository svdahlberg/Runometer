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
    func runs(completion: (_ runs: [RunProtocol]) -> Void)
}

protocol RunPersisting {
    func saveRun(distance: Meters, time: Seconds, locationSegments: [[CLLocation]]) -> RunProtocol
    func delete(_ run: RunProtocol)
}

class RunProvider {
    
    private let coreDataRunProvider: CoreDataRunProvider
    private let coreDataRunPersister: CoreDataRunPersister
    
    init(coreDataRunProvider: CoreDataRunProvider = CoreDataRunProvider(),
         coreDataRunPersister: CoreDataRunPersister = CoreDataRunPersister()) {
        self.coreDataRunProvider = coreDataRunProvider
        self.coreDataRunPersister = coreDataRunPersister
    }
    
    func saveRun(distance: Meters, time: Seconds, locationSegments: [[CLLocation]]) -> RunProtocol {
        return coreDataRunPersister.saveRun(distance: distance, time: time, locationSegments: locationSegments)
    }
    
    func delete(_ run: RunProtocol) {
        coreDataRunPersister.delete(run)
    }
    
    func savedRuns(completion: ([RunProtocol]) -> Void) {
        coreDataRunProvider.runs {
            completion($0)
        }
    }
    
    func savedRuns(withinDistanceRange range: ClosedRange<Meters>, completion: ([RunProtocol]) -> Void) {
        savedRuns {
            completion($0.within(range))
        }
    }
    
    func averagePaceOfSavedRuns(completion: (Seconds?) -> Void) {
        savedRuns {
            completion(averagePace(of: $0))
        }
    }
    
    func averagePaceOfSavedRuns(withinDistanceRange range: ClosedRange<Meters>, completion: (Seconds?) -> Void) {
        savedRuns(withinDistanceRange: range) {
            completion(averagePace(of: $0))
        }
    }
    
    func averageTimeOfSavedRuns(completion: (Seconds?) -> Void) {
        savedRuns {
            completion(averageTime(of: $0))
        }
    }
    
    func averageTimeOfSavedRuns(withinDistanceRange range: ClosedRange<Meters>, completion: (Seconds?) -> Void) {
        savedRuns(withinDistanceRange: range) {
            completion(averageTime(of: $0))
        }

    }
    
    func averageDistanceOfSavedRuns(completion: (Meters?) -> Void) {
        savedRuns { runs in
            guard !runs.isEmpty else {
                completion(nil)
                return
            }
            completion(runs
                .map { $0.distance }
                .reduce(0, +) / Double(runs.count)
            )
        }
    }
    
    private func averagePace(of runs: [RunProtocol]) -> Seconds? {
        guard !runs.isEmpty else {
            return nil
        }
        let paces = runs.map { $0.averagePace() }
        let sumOfPaces = paces.reduce(0, +)
        return sumOfPaces / runs.count
    }

    private func averageTime(of runs: [RunProtocol]) -> Seconds? {
        guard !runs.isEmpty else {
            return nil
        }
        let times = runs.map { $0.duration }
        let sumOfTimes = times.reduce(0, +)
        return Int(sumOfTimes) / runs.count
    }
}
