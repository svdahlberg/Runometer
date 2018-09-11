//
//  StatisticsViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-10.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class Statistics {
    
    private let settings: Settings
    private let runs: [Run]
    
    init(settings: Settings = Settings(), runs: [Run]) {
        self.settings = settings
        self.runs = runs
    }
    
    private lazy var distances: [Meters] = runs.map { $0.distance }
    private lazy var paces: [Seconds] = runs.map { $0.averagePace() }
    
    lazy var totalDistance: RunStatistic = {
        let totalDistance = distances.reduce(0, +)
        return RunStatistic(value: totalDistance, title: "Total Distance", unit: settings.distanceUnit)
    }()
    
    var longestDistance: RunStatistic? {
        guard let longestDistance = distances.max() else { return nil }
        return RunStatistic(value: longestDistance, title: "Longest Run", unit: settings.distanceUnit)
    }
    
    var fastestPace: RunStatistic? {
        guard let fastestPace = paces.min() else { return nil }
        return RunStatistic(value: Double(fastestPace), title: "Fastest Pace", unit: settings.speedUnit)
    }
    
    var averageDistance: RunStatistic? {
        guard runs.count > 0 else { return nil }
        let averageDistance = totalDistance.value / Double(runs.count)
        return RunStatistic(value: averageDistance, title: "Average Distance", unit: settings.distanceUnit)
    }
    
    var averagePace: RunStatistic? {
        guard runs.count > 0 else { return nil }
        let averagePace = paces.reduce(0, +) / runs.count
        return RunStatistic(value: Double(averagePace), title: "Average Pace", unit: settings.speedUnit)
    }
    
}

class StatisticsViewController: UIViewController {
    
    @IBOutlet private weak var totalDistanceStatisticView: RunStatisticView!
    @IBOutlet private weak var longestRunStatisticView: RunStatisticView!
    @IBOutlet private weak var fastestPaceStatisticView: RunStatisticView!
    @IBOutlet private weak var averageDistanceStatisticView: RunStatisticView!
    @IBOutlet private weak var averagePaceStatisticView: RunStatisticView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RunProvider().runs { [weak self] runs in
            let statistics = Statistics(runs: runs)
            self?.totalDistanceStatisticView.statistic = statistics.totalDistance
            self?.longestRunStatisticView.statistic = statistics.longestDistance
            self?.fastestPaceStatisticView.statistic = statistics.fastestPace
            self?.averageDistanceStatisticView.statistic = statistics.averageDistance
            self?.averagePaceStatisticView.statistic = statistics.averagePace
        }
    }
    
}
