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

    var unitType: UnitType {
        switch self {
        case .averageDistance, .totalDistance, .longestDistance:
            return .distance
        case .totalDuration:
            return .time
        case .averagePace, .fastestPace:
            return .speed
        case .numberOfRuns:
            return .count
        }
    }
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
    private lazy var date = runs.first?.endDate ?? Date()
    
    func statistic(of type: RunStatisticType, with title: String? = nil) -> RunStatistic {

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
        return RunStatistic(value: totalDistance, title: title, date: date, unitType: .distance, type: .totalDistance)
    }
    
    func numberOfRuns(with title: String = "Number of Runs") -> RunStatistic {
        return RunStatistic(value: Double(runs.count), title: title, date: date, unitType: .count, type: .numberOfRuns)
    }
    
    func totalDuration(with title: String = "Total Duration") -> RunStatistic {
        let totalDuration = durations.reduce(0, +)
        return RunStatistic(value: Double(totalDuration), title: title, date: date, unitType: .time, type: .totalDuration)
    }
    
    func longestDistance(with title: String = "Longest Run") -> RunStatistic {
        let longestDistance = distances.max() ?? 0
        return RunStatistic(value: longestDistance, title: title, date: date, unitType: .distance, type: .longestDistance)
    }
    
    func fastestPace(with title: String = "Fastest Pace") -> RunStatistic {
        let fastestPace = paces.min() ?? 0
        return RunStatistic(value: Double(fastestPace), title: title, date: date, unitType: .speed, type: .fastestPace)
    }
    
    func averageDistance(with title: String = "Average Distance") -> RunStatistic {
        guard runs.count > 0 else {
            return RunStatistic(value: 0, title: title, date: date, unitType: .distance, type: .averageDistance)
        }

        let averageDistance = totalDistanceValue / Double(runs.count)
        return RunStatistic(value: averageDistance, title: title, date: date, unitType: .distance, type: .averageDistance)
    }
    
    func averagePace(with title: String = "Average Pace") -> RunStatistic {
        guard runs.count > 0 else {
            return RunStatistic(value: 0, title: title, date: date, unitType: .speed, type: .averagePace)
        }

        let averagePace = paces.reduce(0, +) / runs.count
        return RunStatistic(value: Double(averagePace), title: title, date: date, unitType: .speed, type: .averagePace)
    }
    
}


enum StatisticsBreakdownFilter: CaseIterable {

    case week, month, year

    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
}

// This is pretty much identical to `RunSection`. It would be nice to merge these to one generic type `Section<T: Dateable>`, However, T would have to have a date, i.e. conform to a Dateable protocol, and since `Run` itself is a protocol we can not have sections of runs (Section<Run>).
struct RunStatisticSection {

    let title: String?
    let runStatistics: [RunStatistic]

    static func sections(from runStatistics: [RunStatistic], titleDateFormatter: DateFormatter? = nil, headerDateFormatter: DateFormatter?) -> [RunStatisticSection] {
        return Dictionary(grouping: runStatistics) {
            headerDateFormatter?.string(from: $0.date)
        }.map {
            let title: String?
            if let titleDateFormatter = titleDateFormatter {
                title = titleDateFormatter.string(from: $1[0].date)
            } else {
                title = $0
            }
            return RunStatisticSection(title: title, runStatistics: $1)
        }.sorted {
            guard $0.runStatistics.count > 0, $1.runStatistics.count > 0 else { return false }
            return $0.runStatistics[0].date > $1.runStatistics[0].date
        }
    }

}

struct StatisticsBreakdown {

    private let runs: [Run]
    private let type: RunStatisticType
    private let filter: StatisticsBreakdownFilter

    init(runs: [Run], type: RunStatisticType, filter: StatisticsBreakdownFilter) {
        self.runs = runs
        self.type = type
        self.filter = filter
    }

    func listStatistics() -> [RunStatisticSection] {
        let runSections = RunSection.runSections(from: runs, filter: filter, titleDateFormatter: listTitleDateFormatter(for: filter))
        return statistics(from: runSections, headerDateFormatter: listHeaderDateFormatter(for: filter))
    }

    func chartStatistics() -> [RunStatisticSection] {
        let titleDateFormatter = chartTitleDateFormatter(for: filter)
        let runSections = RunSection.runSections(from: runs, filter: filter, titleDateFormatter: titleDateFormatter)
        return statistics(from: runSections, addStatisticsForZeroRuns: true, titleDateFormatter: titleDateFormatter, headerDateFormatter: chartHeaderDateFormatter(for: filter))
    }

    /// Returns list of runStatistics for a time period (week, month, year), where each item will be a part of that time period.
    /// For year each item will be a month, for month and week, each item will be a day.
    func statistics() -> [RunStatistic] {
        []



    }

    private func statistics(from runSections: [RunSection], addStatisticsForZeroRuns: Bool = false, titleDateFormatter: DateFormatter? = nil, headerDateFormatter: DateFormatter?) -> [RunStatisticSection] {
        var statistics = runSections.compactMap { (runSection: RunSection) in
            Statistics(runs: runSection.runs).statistic(of: type, with: runSection.title)
        }

        if addStatisticsForZeroRuns {
            switch filter {
            case .year:
                break
            case .month:
                statistics = runStatistics(per: .year, statistics)
                    .flatMap {
                        paddedRunStatistics($0, titleDateFormatter: titleDateFormatter ?? chartTitleDateFormatter(for: filter))
                    }
            case .week:
                statistics = runStatistics(per: .year, statistics)
                    .flatMap {
                        paddedRunStatistics($0, titleDateFormatter: titleDateFormatter ?? chartTitleDateFormatter(for: filter))
                    }
            }
        }

        return RunStatisticSection
            .sections(from: statistics, headerDateFormatter: headerDateFormatter)
            .filter {
                !$0.runStatistics.allSatisfy {
                    $0.value == 0
                }
            }
    }

    private func runStatistics(per calendarComponent: Calendar.Component, _ runStatistics: [RunStatistic]) -> [[RunStatistic]] {
        Dictionary(grouping: runStatistics) {
            Calendar.current.component(calendarComponent, from: $0.date)
        }.map {
            $0.value
        }
    }

    private func paddedRunStatistics(_ runStatistics: [RunStatistic], titleDateFormatter: DateFormatter) -> [RunStatistic] {
        guard let firstRunStatistic = runStatistics.first else {
            return []
        }

        let year = Calendar.current.component(.year, from: firstRunStatistic.date)
        let unitType = firstRunStatistic.unitType
        let type = firstRunStatistic.type

        let all: [Int] = {
            switch filter {
            case .month:
                return Array(1...12)
            case .week:
                return Array(1...53)
            case .year:
                return []
            }
        }()

        func dateComponent() -> Calendar.Component? {
            switch filter {
            case .month:
                return .month
            case .week:
                return .weekOfYear
            case .year:
                return nil
            }
        }

        guard let dateComponent = dateComponent() else { return [] }

        let withRuns = runStatistics.map {
            Calendar.current.component(dateComponent, from: $0.date)
        }
        let withoutRuns = Array(Set(all).subtracting(Set(withRuns)))

        let zeroRunStatistics: [RunStatistic] = withoutRuns.compactMap { dateComponent in
            func date() -> Date? {
                switch filter {
                case .month:
                    return Date.date(year: year, month: dateComponent)
                case .week:
                    return Date.date(year: year, weekOfYear: dateComponent)
                case .year:
                    return nil
                }
            }

            guard let date = date() else { return nil }

            return RunStatistic(
                value: 0,
                title: titleDateFormatter.string(from: date),
                date: date,
                unitType: unitType,
                type: type
            )
        }

        return (runStatistics + zeroRunStatistics).sorted { $0.date > $1.date }
    }

    private func listTitleDateFormatter(for filter: StatisticsBreakdownFilter) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch filter {
        case .year: dateFormatter.dateFormat = "yyyy"
        case .month: dateFormatter.dateFormat = "MMMM"
        case .week: dateFormatter.dateFormat = "'Week' w"
        }
        return dateFormatter
    }

    private func chartTitleDateFormatter(for filter: StatisticsBreakdownFilter) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch filter {
        case .year: dateFormatter.dateFormat = "yyyy"
        case .month: dateFormatter.dateFormat = "MMMM"
        case .week: dateFormatter.dateFormat = "'Week' w"
        }
        return dateFormatter
    }

    private func listHeaderDateFormatter(for filter: StatisticsBreakdownFilter) -> DateFormatter? {
        let dateFormatter = DateFormatter()
        switch filter {
        case .year: return nil
        case .month: dateFormatter.dateFormat = "yyyy"
        case .week: dateFormatter.dateFormat = "yyyy"
        }
        return dateFormatter
    }

    private func chartHeaderDateFormatter(for filter: StatisticsBreakdownFilter) -> DateFormatter? {
        let dateFormatter = DateFormatter()
        switch filter {
        case .year: return nil
        case .month: dateFormatter.dateFormat = "yyyy"
        case .week: dateFormatter.dateFormat = "QQQ yyyy"
        }
        return dateFormatter
    }

}
