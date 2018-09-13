//
//  Statistics.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-12.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

class Statistics {
    
    private let settings: Settings
    private let runs: [Run]
    
    init(settings: Settings = Settings(), runs: [Run]) {
        self.settings = settings
        self.runs = runs
    }
    
    private lazy var distances: [Meters] = runs.map { $0.distance }
    private lazy var paces: [Seconds] = runs.map { $0.averagePace() }
    private lazy var durations: [Seconds] = runs.map { $0.duration }
    
    lazy var totalDistance: RunStatistic = {
        let totalDistance = distances.reduce(0, +)
        return RunStatistic(value: totalDistance, title: "Total Distance", unitType: .distance)
    }()
    
    var numberOfRuns: RunStatistic {
        return RunStatistic(value: Double(runs.count), title: "Number of Runs", unitType: .count)
    }
    
    var totalDuration: RunStatistic {
        let totalDuration = durations.reduce(0, +)
        return RunStatistic(value: Double(totalDuration), title: "Total Duration", unitType: .time)
    }
    
    var longestDistance: RunStatistic? {
        guard let longestDistance = distances.max() else { return nil }
        return RunStatistic(value: longestDistance, title: "Longest Run", unitType: .distance)
    }
    
    var fastestPace: RunStatistic? {
        guard let fastestPace = paces.min() else { return nil }
        return RunStatistic(value: Double(fastestPace), title: "Fastest Pace", unitType: .speed)
    }
    
    var averageDistance: RunStatistic? {
        guard runs.count > 0 else { return nil }
        let averageDistance = totalDistance.value / Double(runs.count)
        return RunStatistic(value: averageDistance, title: "Average Distance", unitType: .distance)
    }
    
    var averagePace: RunStatistic? {
        guard runs.count > 0 else { return nil }
        let averagePace = paces.reduce(0, +) / runs.count
        return RunStatistic(value: Double(averagePace), title: "Average Pace", unitType: .speed)
    }
    
}
