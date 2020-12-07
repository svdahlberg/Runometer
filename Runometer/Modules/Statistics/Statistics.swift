//
//  Statistics.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-12.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

enum RunStatisticType {
    case averageDistance
    case totalDistance
    case numberOfRuns
    case totalDuration
    case longestDistance
    case fastestPace
    case averagePace
}

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
    private lazy var totalDistanceValue: Meters = distances.reduce(0, +)
    
    func statistic(of type: RunStatisticType, with title: String? = nil) -> RunStatistic? {

        if let title = title {
            switch type {
            case .averageDistance: return averageDistance(with: title)
            case .totalDistance: return totalDistance(with: title)
            case .numberOfRuns: return numberOfRuns(with: title)
            case .fastestPace: return fastestPace(with: title)
            case .averagePace: return averagePace(with: title)
            case .longestDistance: return longestDistance(with: title)
            case .totalDuration: return totalDuration(with: title)
            }
        } else {
            switch type {
            case .averageDistance: return averageDistance()
            case .totalDistance: return totalDistance()
            case .numberOfRuns: return numberOfRuns()
            case .fastestPace: return fastestPace()
            case .averagePace: return averagePace()
            case .longestDistance: return longestDistance()
            case .totalDuration: return totalDuration()
            }
        }
    }
    
    func totalDistance(with title: String = "Total Distance") -> RunStatistic {
        let totalDistance = distances.reduce(0, +)
        return RunStatistic(value: totalDistance, title: title, unitType: .distance, type: .totalDistance)
    }
    
    func numberOfRuns(with title: String = "Number of Runs") -> RunStatistic {
        return RunStatistic(value: Double(runs.count), title: title, unitType: .count, type: .numberOfRuns)
    }
    
    func totalDuration(with title: String = "Total Duration") -> RunStatistic {
        let totalDuration = durations.reduce(0, +)
        return RunStatistic(value: Double(totalDuration), title: title, unitType: .time, type: .totalDuration)
    }
    
    func longestDistance(with title: String = "Longest Run") -> RunStatistic? {
        guard let longestDistance = distances.max() else { return nil }
        return RunStatistic(value: longestDistance, title: title, unitType: .distance, type: .longestDistance)
    }
    
    func fastestPace(with title: String = "Fastest Pace") -> RunStatistic? {
        guard let fastestPace = paces.min() else { return nil }
        return RunStatistic(value: Double(fastestPace), title: title, unitType: .speed, type: .fastestPace)
    }
    
    func averageDistance(with title: String = "Average Distance") -> RunStatistic? {
        guard runs.count > 0 else { return nil }
        let averageDistance = totalDistanceValue / Double(runs.count)
        return RunStatistic(value: averageDistance, title: title, unitType: .distance, type: .averageDistance)
    }
    
    func averagePace(with title: String = "Average Pace") -> RunStatistic? {
        guard runs.count > 0 else { return nil }
        let averagePace = paces.reduce(0, +) / runs.count
        return RunStatistic(value: Double(averagePace), title: title, unitType: .speed, type: .averagePace)
    }
    
}
