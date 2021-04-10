//
//  RunRepository.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/18/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import Foundation

struct RunGroup {
    let name: String
    let runs: [Run]
}

class RunRepository {

    private let runProvider: RunProviding
    private let settings: Settings

    init(container: DependencyContainer = DependencyManager.shared.container) {
        self.runProvider = container.resolve(RunProviding.self) ?? RunProvider()
        self.settings = container.resolve(Settings.self) ?? Settings()
    }

    func allRuns(_ completion: @escaping (_ runs: [Run]) -> Void) {
        runProvider.runs(filter: nil, completion: completion)
    }

    func runsGroupedBySimilarDistance(_ completion: @escaping (_ runs: [RunGroup]) -> Void) {
        allRuns { runs in
            let sortedRuns = runs.sorted { $0.distance < $1.distance }
            let diff: Meters = 4000
            let eps = 0.0000001
            let grouped = sortedRuns.reduce(([], [])) { (accumulated: ([Run], [[Run]]), run: Run) -> ([Run], [[Run]]) in
                if accumulated.0.count == 0 || abs(accumulated.0[0].distance - run.distance) - diff <= eps {
                    return (accumulated.0 + [run], accumulated.1)
                } else {
                    return ([run], accumulated.1 + [accumulated.0])
                }
            }

            let groups = grouped.1 + [grouped.0]

            let runGroups: [RunGroup] = groups.compactMap {
                guard let shortestRun = $0.first, let longestRun = $0.last else {
                    return nil
                }

                let shortestDistance = shortestRun.distance.roundedDownToNearestDistanceUnit(self.settings.distanceUnit)
                let longestDistance = (longestRun.distance + self.settings.distanceUnit.meters).roundedDownToNearestDistanceUnit(self.settings.distanceUnit)

                let name = "\(shortestDistance) - \(longestDistance) \(self.settings.distanceUnit.symbol) runs"
                return RunGroup(name: name, runs: $0)
            }

            completion([RunGroup(name: "all runs", runs: runs)] + runGroups)
        }
    }

    func runs(filter: RunFilter?, _ completion: @escaping (_ runs: [Run]) -> Void) {
        runProvider.runs(filter: filter, completion: completion)
    }

}

extension Meters {

    func roundedDownToNearestDistanceUnit(_ distanceUnit: DistanceUnit) -> Int {
        Int(self / distanceUnit.meters)
    }

}
