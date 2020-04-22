//
//  StatisticsViewModel.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/19/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import Foundation

class StatisticsViewModel {

    private let runRepository: RunRepository

    var didLoadStatistics: (() -> Void)? {
        didSet { loadStatistics() }
    }

    private(set) var runStatistics: [RunStatistic] = [] {
        didSet { didLoadStatistics?() }
    }

    private(set) var runStatisticFilters: [RunGroup] = []

    var selectedRunStatisticFilter: RunGroup? {
        didSet {
            guard let selectedRunStatisticFilter = selectedRunStatisticFilter else { return }
            let statistics = Statistics(runs: selectedRunStatisticFilter.runs)
            runStatistics = [
                statistics.numberOfRuns(),
                statistics.totalDistance(),
                statistics.totalDuration(),
                statistics.longestDistance(),
                statistics.fastestPace(),
                statistics.averageDistance(),
                statistics.averagePace()
                ].compactMap { $0 }
        }
    }

    init(runRepository: RunRepository = RunRepository()) {
        self.runRepository = runRepository
    }

    func loadStatistics() {
        runRepository.runsGroupedBySimilarDistance { filters in
            self.runStatisticFilters = filters
            self.selectedRunStatisticFilter = filters.first {
                $0.name == self.selectedRunStatisticFilter?.name
                } ?? filters.first
        }
    }

}
