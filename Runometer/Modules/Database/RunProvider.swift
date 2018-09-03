//
//  RunProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-04.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import CoreData
import CoreLocation

class RunProvider {
    
    private(set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.context) {
        self.context = context
    }
    
    func saveRun(distance: Meters, time: Seconds, locationSegments: [[CLLocation]]) -> Run {
        let run = Run(context: context, distance: distance, time: time, locationSegments: locationSegments)
        CoreDataStack.saveContext()
        return run
    }
    
    class func delete(_ run: Run) {
        try? CoreDataStack.deleteRun(run)
    }
    
    func savedRuns() -> [Run]? {
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return try? context.fetch(fetchRequest)
    }
    
    func savedRuns(withinDistanceRange range: ClosedRange<Meters>) -> [Run]? {
        return savedRuns()?.filter { range.contains($0.distance) }
    }
    
    func averagePaceOfSavedRuns() -> Seconds? {
        guard let runs = savedRuns() else { return nil }
        return averagePace(of: runs)
    }
    
    func averagePaceOfSavedRuns(withinDistanceRange range: ClosedRange<Meters>) -> Seconds? {
        guard let runs = savedRuns(withinDistanceRange: range) else { return nil }
        return averagePace(of: runs)
    }
    
    func averageTimeOfSavedRuns() -> Seconds? {
        guard let runs = savedRuns() else { return nil }
        return averageTime(of: runs)
    }
    
    func averageTimeOfSavedRuns(withinDistanceRange range: ClosedRange<Meters>) -> Seconds? {
        guard let runs = savedRuns(withinDistanceRange: range) else { return nil }
        return averageTime(of: runs)
    }
    
    func averageDistanceOfSavedRuns() -> Meters? {
        guard let runs = savedRuns(), !runs.isEmpty else { return nil }
        return runs
            .map { $0.distance }
            .reduce(0, +) / Double(runs.count)
    }
    
    private func averagePace(of runs: [Run]) -> Seconds? {
        guard !runs.isEmpty else {
            return nil
        }
        let paces = runs.map { $0.averagePace() }
        let sumOfPaces = paces.reduce(0, +)
        return sumOfPaces / runs.count
    }

    private func averageTime(of runs: [Run]) -> Seconds? {
        guard !runs.isEmpty else {
            return nil
        }
        let times = runs.map { $0.duration }
        let sumOfTimes = times.reduce(0, +)
        return Int(sumOfTimes) / runs.count
    }
}
