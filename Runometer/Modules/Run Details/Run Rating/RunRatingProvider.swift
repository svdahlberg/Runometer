//
//  RunRatingProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-04.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

struct RunRatingProvider {
    
    let run: Run
    
    func distanceRating() -> RunRating? {
        guard let formattedDistance = DistanceFormatter.format(distance: run.distance),
            let statisticsText = RunStatistics().allDistancesStatisticsText(for: run.distance),
            let runs = RunProvider().savedRuns() else {
                return nil
        }
        
        let allDistances = runs.map { $0.distance }
        let distanceRating = RunRatingCalculator.distanceRating(for: run.distance, comparedTo: allDistances)
        return RunRating(percentage: distanceRating, title: formattedDistance, subtitle: Settings().distanceUnit.symbol, description: statisticsText)
    }
    
    func timeRating() -> RunRating? {
        guard let formattedTime = TimeFormatter.format(time: Seconds(run.duration)),
            let runsWithSimilarDistances = RunProvider().savedRuns(withinDistanceRange: run.similarRunsRange()),
            let timeRatingStatisticsText = RunStatistics().averageTimeStatisticsText(for: Seconds(run.duration), withinDistanceRange: run.similarRunsRange())
            else {
                return nil
        }
        
        let times = runsWithSimilarDistances.map { Seconds($0.duration) }
        let timeRating = RunRatingCalculator.timeRating(for: Seconds(run.duration), comparedTo: times)
        return RunRating(percentage: timeRating, title: formattedTime, subtitle: "Time", description: timeRatingStatisticsText)
    }
    
    func paceRating() -> RunRating? {
        guard
            let runs = RunProvider().savedRuns(),
            let formattedPace = PaceFormatter.pace(fromDistance: run.distance, time: Seconds(run.duration)),
            let paceRatingStatisticsText = RunStatistics().averagePaceStatisticsText(for: run.averagePace())
            else {
                return nil
        }
        
        let paces = runs.map { $0.averagePace() }
        let paceRating = RunRatingCalculator.timeRating(for: run.averagePace(), comparedTo: paces)
        return RunRating(percentage: paceRating, title: formattedPace, subtitle: Settings().speedUnit.symbol, description: paceRatingStatisticsText)
    }
}
