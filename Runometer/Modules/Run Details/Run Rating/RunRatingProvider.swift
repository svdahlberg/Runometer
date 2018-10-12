//
//  RunRatingProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-04.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

struct RunRatingsProvider {
    
    private let run: Run
    private let runProvider: RunProvider
    
    init(run: Run, runProvider: RunProvider = RunProvider()) {
        self.run = run
        self.runProvider = runProvider
    }
    
    func runRatings(_ completion: @escaping ([RunRating]) -> Void) {
        runProvider.runs { allRuns in
            let runRatingProvider = RunRatingProvider(run: self.run, allRuns: allRuns)
            let runRatings = [
                runRatingProvider.allTimeDistanceRating(),
                runRatingProvider.averageDistanceRating(),
                runRatingProvider.allTimeDurationRating(),
                runRatingProvider.averageDurationRating(),
                runRatingProvider.averageDurationComparedToRunsWithSimilarDistanceRating(),
                runRatingProvider.averagePaceRating(),
                runRatingProvider.allTimePaceRating(),
                runRatingProvider.averagePaceComparedToRunsWithSimilarDistanceRating()
                ]
                .compactMap { $0 }
                .sorted { $0.percentage > $1.percentage }
            
            guard !runRatings.isEmpty else {
                completion([])
                return
            }
            
            let bestRunRatings = Array(runRatings[0...runRatings.index(after: 0)])
            
            completion(bestRunRatings)
        }
    }
    
}


class RunRatingProvider {
    
    let run: Run
    let allRuns: [Run]
    
    init(run: Run, allRuns: [Run]) {
        self.run = run
        self.allRuns = allRuns
    }
    
    private lazy var similarDistanceRuns = allRuns.within(self.run.similarRunsRange())
    
    func allTimeDistanceRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: allRuns).allDistancesStatisticsText(for: run.distance) else {
            return nil
        }
        return distanceRating(comparedTo: allRuns, statisticsText: statisticsText)
    }
    
    func averageDistanceRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: allRuns).averageDistanceStatisticsText(for: run.distance) else {
            return nil
        }
        return distanceRating(comparedTo: allRuns, statisticsText: statisticsText)
    }
    
    func allTimeDurationRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: allRuns).allTimesStatisticsText(for: run.duration) else {
            return nil
        }
        return timeRating(comparedTo: allRuns, statisticsText: statisticsText)
    }
    
    func averageDurationRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: allRuns).averageTimeStatisticsText(for: run.duration) else {
            return nil
        }
        return timeRating(comparedTo: allRuns, statisticsText: statisticsText)
    }
    
    func averageDurationComparedToRunsWithSimilarDistanceRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: similarDistanceRuns).averageTimeStatisticsText(for: run.duration, withinDistanceRange: run.similarRunsRange()) else {
            return nil
        }
        return timeRating(comparedTo: similarDistanceRuns, statisticsText: statisticsText)
    }
    
    func allTimePaceRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: allRuns).allPacesStatisticsText(for: run.averagePace()) else {
            return nil
        }
        return paceRating(comparedTo: allRuns, statisticsText: statisticsText)
    }
    
    func averagePaceRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: allRuns).averagePaceStatisticsText(for: run.averagePace()) else {
            return nil
        }
        return paceRating(comparedTo: allRuns, statisticsText: statisticsText)
    }
    
    func averagePaceComparedToRunsWithSimilarDistanceRating() -> RunRating? {
        guard let statisticsText = RunStatisticsTextProvider(runs: allRuns).averagePaceStatisticsText(for: run.averagePace(), withinDistanceRange: run.similarRunsRange()) else {
            return nil
        }
        return paceRating(comparedTo: similarDistanceRuns, statisticsText: statisticsText)
    }
    
    
    private func distanceRating(comparedTo runs: [Run], statisticsText: String) -> RunRating? {
        guard let formattedDistance = DistanceFormatter.format(distance: run.distance) else {
            return nil
        }
        
        let allDistances = runs.map { $0.distance }
        let distanceRating = RunRatingCalculator.distanceRating(for: run.distance, comparedTo: allDistances)
        return RunRating(percentage: distanceRating, title: formattedDistance, subtitle: Settings().distanceUnit.symbol, description: statisticsText)
    }
    
    private func timeRating(comparedTo runs: [Run], statisticsText: String) -> RunRating? {
        guard let formattedTime = TimeFormatter.format(time: Seconds(run.duration)) else {
            return nil
        }
        
        let times = runs.map { Seconds($0.duration) }
        let timeRating = RunRatingCalculator.timeRating(for: Seconds(run.duration), comparedTo: times)
        return RunRating(percentage: timeRating, title: formattedTime, subtitle: "Time", description: statisticsText)
    }
    
    private func paceRating(comparedTo runs: [Run], statisticsText: String) -> RunRating? {
        guard let formattedPace = PaceFormatter.pace(fromDistance: run.distance, time: Seconds(run.duration)) else {
            return nil
        }
        
        let paces = runs.map { $0.averagePace() }
        let paceRating = RunRatingCalculator.timeRating(for: run.averagePace(), comparedTo: paces)
        return RunRating(percentage: paceRating, title: formattedPace, subtitle: Settings().speedUnit.symbol, description: statisticsText)
    }
    
}
