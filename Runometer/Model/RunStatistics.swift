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
    
    private let appConfiguration: AppConfiguration
    private let runService: RunService
    
    init(appConfiguration: AppConfiguration = AppConfiguration(), runService: RunService = RunService()) {
        self.appConfiguration = appConfiguration
        self.runService = runService
    }
    
    // MARK: Public methods
    
    func allDistancesStatisticsText(for distance: Meters) -> String? {
        guard let allRuns = runService.savedRuns(), allRuns.count > 1 else { return "Your longest run!" }
        let distances = allRuns.map { $0.distance }
        return statisticsText(for: distance, comparedTo: distances, using: allDistancesStatisticsTexts)
    }
    
    func allTimesStatisticsText(for time: Seconds) -> String? {
        guard let allRuns = runService.savedRuns(), allRuns.count > 1 else { return "Your longest run!" }
        let times = allRuns.map { Seconds($0.duration) }
        return statisticsText(for: time, comparedTo: times, using: allTimesStatisticsTexts)
    }

    func allPacesStatisticsText(for pace: Seconds) -> String? {
        guard let allRuns = runService.savedRuns(), allRuns.count > 1 else { return "Your fastest pace!" }
        let paces = allRuns.map { Pace(integerLiteral: $0.averagePace()) }
        return statisticsText(for: Pace(integerLiteral: pace), comparedTo: paces, using: allPacesStatisticsTexts)
    }
    
    func averagePaceStatisticsText(for pace: Seconds, withinDistanceRange range: ClosedRange<Meters>) -> String? {
        guard let averagePace = runService.averagePaceOfSavedRuns(withinDistanceRange: range) else { return nil }
        return statisticsText(for: Pace(integerLiteral: pace), comparedTo: Pace(integerLiteral: averagePace), withinDistanceRange: range, using: averagePaceForSimilarRunsStatisticsTexts)
    }
    
    func averagePaceStatisticsText(for pace: Seconds) -> String? {
        guard let averagePace = runService.averagePaceOfSavedRuns() else { return nil }
        return statisticsText(for: Pace(integerLiteral: pace), comparedTo: Pace(integerLiteral: averagePace), using: averagePaceStatisticsTexts)
    }
    
    func averageTimeStatisticsText(for time: Seconds, withinDistanceRange range: ClosedRange<Meters>) -> String? {
        guard let averageTime = runService.averageTimeOfSavedRuns(withinDistanceRange: range) else { return nil }
        return statisticsText(for: time, comparedTo: averageTime, withinDistanceRange: range, using: averageTimeForSimilarRunsStatisticsTexts)
    }
    
    func averageTimeStatisticsText(for time: Seconds) -> String? {
        guard let averageTime = runService.averageTimeOfSavedRuns() else { return nil }
        return statisticsText(for: time, comparedTo: averageTime, using: averageTimeStatisticsTexts)
    }
    
    func averageDistanceStatisticsText(for distance: Meters) -> String? {
        guard let averageDistance = runService.averageDistanceOfSavedRuns() else { return nil }
        return statisticsText(for: distance, comparedTo: averageDistance, using: averageDistanceStatisticsTexts)
    }

    
    // MARK: Private methods
    
    private func statisticsText<T: Numeric & Comparable & Equatable>(for value: T, comparedTo values: [T], using statisticsTexts: StatisticsTexts) -> String? {
        let sortedValues = values.sorted()
        if let largestValue = sortedValues.last, value == largestValue {
            let secondLargestIndex = max(sortedValues.index(before: sortedValues.count - 1), 0)
            let secondLargestValue = sortedValues[secondLargestIndex]
            if let formattedDifference = format(value: value - secondLargestValue) {
                return statisticsTexts.largeValueText.replacingOccurrences(of: "[X]", with: formattedDifference)
            } else {
                return nil
            }
        }
        else if let smallestValue = sortedValues.first, value == smallestValue {
            let secondSmallestIndex = sortedValues.index(after: 0)
            let secondSmallestValue = sortedValues[secondSmallestIndex]
            if let formattedDifference = format(value: secondSmallestValue - value) {
                return statisticsTexts.smallValueText.replacingOccurrences(of: "[X]", with: formattedDifference)
            } else {
                return nil
            }
        }
        else if let largestValue = sortedValues.last, let formattedDifference = format(value: largestValue - value) {
            return statisticsTexts.middleValueText.replacingOccurrences(of: "[X]", with: formattedDifference)
        }
        
        return nil
    }
    
    private func statisticsText<T: Numeric & Comparable>(for value: T, comparedTo averageValue: T, withinDistanceRange range: ClosedRange<Meters>? = nil, using statisticsTexts: StatisticsTexts) -> String? {
        let lengthOfRunString = rangeString(range: range)
        let differenceBetweenValueAndAverageValue = value < averageValue ? averageValue - value : value - averageValue
        let substitutes = ["[X]" : format(value: differenceBetweenValueAndAverageValue), "[Y]" : lengthOfRunString]
        guard value != averageValue else {
            return substitute(valuesIn: statisticsTexts.middleValueText, with: substitutes)
        }
        let unsubstitutedText = value < averageValue ? statisticsTexts.smallValueText : statisticsTexts.largeValueText
        return substitute(valuesIn: unsubstitutedText, with: substitutes)
    }
    
    private func substitute(valuesIn text: String, with substitutes: [String : String?]) -> String {
        var newText = text
        for (key, value) in substitutes {
            newText = newText.replacingOccurrences(of: "\(key)", with: value ?? "")
        }
        return newText
    }
    
    private func format<T>(value: T) -> String? {
        switch value {
        case let meters as Meters:
            return DistanceFormatter.formatWithLongUnitName(distance: meters, outputUnit: appConfiguration.distanceUnit)
        case is Pace:
            guard let pace = value as? Pace else { return nil }
            return PaceFormatter.format(pace: pace.magnitude, outputUnit: appConfiguration.speedUnit)
        case is Seconds:
            guard let time = value as? Seconds else { return nil }
            return TimeFormatter.format(time: time, unitStyle: .full, zeroFormattingBehavior: .dropAll)
        default:
            return nil
        }
    }
    
    private func rangeString(range: ClosedRange<Meters>?) -> String? {
        guard let range = range, let formattedLowerBound = DistanceFormatter.format(distance: range.lowerBound),
            let formattedUpperBound = DistanceFormatter.format(distance: range.upperBound) else {
                return nil
        }
        
        return "\(formattedLowerBound) - \(formattedUpperBound) \(appConfiguration.distanceUnit.symbol)"
    }
    
    private struct StatisticsTexts {
        let smallValueText: String
        let largeValueText: String
        let middleValueText: String
    }
    
    private let averagePaceStatisticsTexts = StatisticsTexts(smallValueText: "[X] faster than your average pace!",
                                                     largeValueText: "[X] slower than your average pace!",
                                                     middleValueText: "As fast as your average pace.")
    private let averageTimeStatisticsTexts = StatisticsTexts(smallValueText: "[X] shorter than your average run!",
                                                            largeValueText: "[X] longer than your average run!",
                                                            middleValueText: "As long as your average run.")
    private let averageDistanceStatisticsTexts = StatisticsTexts(smallValueText: "[X] shorter than your average run!",
                                                                largeValueText: "[X] longer than your average run!",
                                                                middleValueText: "As long as your average run.")
    private let averageTimeForSimilarRunsStatisticsTexts = StatisticsTexts(smallValueText: "[X] shorter than your average [Y] run.",
                                                            largeValueText: "[X] longer than your average [Y] run.",
                                                            middleValueText: "As long as your average [Y] run.")
    private let averagePaceForSimilarRunsStatisticsTexts = StatisticsTexts(smallValueText: "[X] faster than your average pace for [Y] runs!",
                                                            largeValueText: "[X] slower than your average pace for [Y] runs!",
                                                            middleValueText: "As fast as your average paced [Y] run.")
    private let allDistancesStatisticsTexts = StatisticsTexts(smallValueText: "Your shortest run by [X]!",
                                                              largeValueText: "Your longest run by [X]!",
                                                              middleValueText: "[X] shorter than your farthest run.")
    private let allTimesStatisticsTexts = StatisticsTexts(smallValueText: "Your shortest run by [X]!",
                                                              largeValueText: "Your longest run by [X]!",
                                                              middleValueText: "[X] shorter than your longest run.")
    private let allPacesStatisticsTexts = StatisticsTexts(smallValueText: "Your fastest pace by [X]!",
                                                              largeValueText: "Your slowest pace by [X]!",
                                                              middleValueText: "[X] slower than your fastest pace.")
    
}
