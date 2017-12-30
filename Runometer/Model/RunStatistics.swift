//
//  RunStatistics.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-12-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreGraphics

class RunStatistics {
    
    class func allDistancesStatisticsText(for distance: Meters, outputUnit: DistanceUnit = AppConfiguration().distanceUnit, runService: RunService = RunService()) -> String {
        
        guard let allRuns = runService.savedRuns(), !allRuns.isEmpty else {
            return "Your longest run!"
        }
        let distances = allRuns.map { $0.distance }.sorted()
        
        if let longestDistance = distances.last, distance == longestDistance {
            let secondLongestIndex = distances.index(before: distances.count - 1)
            let secondLongestDistance = distances[secondLongestIndex]
            if let formattedDistanceBetweenLongestAndSecondLongest = DistanceFormatter.formatWithLongUnitName(distance: distance - secondLongestDistance, outputUnit: outputUnit), (distance - secondLongestDistance) > 1 {
                return "Your longest run by \(formattedDistanceBetweenLongestAndSecondLongest)!"
            } else {
                return "Your longest run!"
            }
        }
        else if let shortestDistance = distances.first, distance == shortestDistance {
            let secondShortestIndex = distances.index(after: 0)
            let secondShortestDistance = distances[secondShortestIndex]
            if let formattedDistanceBetweenShortestAndSecondShortest = DistanceFormatter.formatWithLongUnitName(distance: secondShortestDistance - distance, outputUnit: outputUnit), (secondShortestDistance - distance) > 1 {
                return "Your shortest run by \(formattedDistanceBetweenShortestAndSecondShortest)!"
            } else {
                return "Your shortest run!"
            }
        }
        else if let longestDistance = distances.last, let shorterThanLongestDistance = DistanceFormatter.formatWithLongUnitName(distance: longestDistance - distance, outputUnit: outputUnit) {
            return "\(shorterThanLongestDistance) shorter than your farthest run."
        }
        
        return ""
    }
    
    
    
    
    
    class func averagePaceStatisticsText(for pace: Seconds, withinDistanceRange range: ClosedRange<Meters>, appConfiguration: AppConfiguration = AppConfiguration(), runService: RunService = RunService()) -> String {
        guard let averagePace = runService.averagePaceOfSavedRuns(withinDistanceRange: range) else { return "" }
        return statisticsText(for: pace, comparedTo: averagePace, withinDistanceRange: range, using: averagePaceForSimilarRunsStatisticsTexts, appConfiguration: appConfiguration)
    }
    
    class func averageTimeStatisticsText(for time: Seconds, withinDistanceRange range: ClosedRange<Meters>, appConfiguration: AppConfiguration = AppConfiguration(), runService: RunService = RunService()) -> String {
        guard let averageTime = runService.averageTimeOfSavedRuns(withinDistanceRange: range) else { return "" }
        return statisticsText(for: time, comparedTo: averageTime, withinDistanceRange: range, using: averageTimeForSimilarRunsStatisticsTexts, appConfiguration: appConfiguration)
    }
    
    class func averageDistanceStatisticsText(for distance: Meters, runService: RunService = RunService(), appConfiguration: AppConfiguration = AppConfiguration()) -> String {
        guard let averageDistance = runService.averageDistanceOfSavedRuns() else { return "" }
        return statisticsText(for: distance, comparedTo: averageDistance, using: averageDistanceStatisticsTexts, appConfiguration: appConfiguration)
    }
    
    class func averageTimeStatisticsText(for time: Seconds, runService: RunService = RunService(), appConfiguration: AppConfiguration = AppConfiguration()) -> String {
        guard let averageTime = runService.averageTimeOfSavedRuns() else { return "" }
        return statisticsText(for: time, comparedTo: averageTime, using: averageTimeStatisticsTexts, appConfiguration: appConfiguration)
    }
    
    class func averagePaceStatisticsText(for pace: Seconds, runService: RunService = RunService(), appConfiguration: AppConfiguration = AppConfiguration()) -> String {
        guard let averagePace = runService.averagePaceOfSavedRuns() else { return "" }
        return statisticsText(for: Pace(integerLiteral: pace), comparedTo: Pace(integerLiteral: averagePace), using: averagePaceStatisticsTexts, appConfiguration: appConfiguration)
    }
    
    
    
    private class func statisticsText<T: Numeric & Comparable>(for value: T, comparedTo averageValue: T, withinDistanceRange range: ClosedRange<Meters>? = nil, using statisticsTexts: StatisticsTexts, appConfiguration: AppConfiguration) -> String {
        let lengthOfRunString = rangeString(range: range, distanceUnit: appConfiguration.distanceUnit)
        if value < averageValue {
            if let formattedDifference = format(value: averageValue - value, appConfiguration: appConfiguration) {
                return statisticsTexts.lessThanAverage.replacingOccurrences(of: "[X]", with: formattedDifference).replacingOccurrences(of: "[Y]", with: lengthOfRunString ?? "")
            } else { return "" }
        } else if value > averageValue {
            if let formattedDifference = format(value: value - averageValue, appConfiguration: appConfiguration) {
                return statisticsTexts.moreThanAverage.replacingOccurrences(of: "[X]", with: formattedDifference).replacingOccurrences(of: "[Y]", with: lengthOfRunString ?? "")
            } else { return "" }
        }
        
        return statisticsTexts.sameAsAverage.replacingOccurrences(of: "[Y]", with: lengthOfRunString ?? "")
    }
    
    private class func format<T>(value: T, appConfiguration: AppConfiguration) -> String? {
        switch value {
        case let meters as Meters:
            return DistanceFormatter.formatWithLongUnitName(distance: meters, outputUnit: appConfiguration.distanceUnit)
        case is Pace:
            guard let pace = value as? Pace else { return nil }
            return PaceFormatter.format(pace: pace.magnitude, outputUnit: appConfiguration.speedUnit)
        case is Seconds:
            guard let time = value as? Seconds else { return nil }
            return TimeFormatter.format(time: time, unitStyle: .positional, zeroFormattingBehavior: .dropAll)
        default:
            return nil
        }
    }
    
    private class func rangeString(range: ClosedRange<Meters>?, distanceUnit: DistanceUnit) -> String? {
        guard let range = range, let formattedLowerBound = DistanceFormatter.format(distance: range.lowerBound),
            let formattedUpperBound = DistanceFormatter.format(distance: range.upperBound) else {
                return nil
        }
        
        return "\(formattedLowerBound) - \(formattedUpperBound) \(distanceUnit.symbol)"
    }
    
    struct StatisticsTexts {
        let lessThanAverage: String
        let moreThanAverage: String
        let sameAsAverage: String
    }
    
    static let averagePaceStatisticsTexts = StatisticsTexts(lessThanAverage: "[X] faster than your average pace!",
                                                     moreThanAverage: "[X] slower than your average pace!",
                                                     sameAsAverage: "As fast as your average pace.")
    static let averageTimeStatisticsTexts = StatisticsTexts(lessThanAverage: "[X] shorter than your average run!",
                                                            moreThanAverage: "[X] longer than your average run!",
                                                            sameAsAverage: "As long as your average run.")
    static let averageDistanceStatisticsTexts = StatisticsTexts(lessThanAverage: "[X] shorter than your average run!",
                                                                moreThanAverage: "[X] longer than your average run!",
                                                                sameAsAverage: "As long as your average run.")
    static let averageTimeForSimilarRunsStatisticsTexts = StatisticsTexts(lessThanAverage: "[X] shorter than your average [Y] run.",
                                                            moreThanAverage: "[X] longer than your average [Y] run.",
                                                            sameAsAverage: "As long as your average [Y] run.")
    static let averagePaceForSimilarRunsStatisticsTexts = StatisticsTexts(lessThanAverage: "[X] faster than your average pace for [Y] runs!",
                                                            moreThanAverage: "[X] slower than your average pace for [Y] runs!",
                                                            sameAsAverage: "As fast as your average paced [Y] run.")
    
    
}


