//
//  StatisticDetailViewModel.swift
//  Runometer
//
//  Created by Svante Dahlberg on 3/6/22.
//  Copyright © 2022 Svante Dahlberg. All rights reserved.
//

import Foundation

class StatisticDetailViewModel: ObservableObject {

    let runStatistic: RunStatistic
    let runs: [Run]

    @Published var selectedFilter: StatisticsBreakdownFilter = .month {
        didSet {
            chartModel = createChartModel()
        }
    }

    @Published var chartModel: ChartModel!

    init(runStatistic: RunStatistic, runs: [Run]) {
        self.runStatistic = runStatistic
        self.runs = runs
        chartModel = createChartModel()
    }

    private func createChartModel() -> ChartModel {
        ChartModel(
            dataSections: chartData(),
            valueFormatter: chartValueFormatter(),
            pagingEnabled: selectedFilter != .allTime
        )
    }

    private lazy var weekData: [RunStatisticSection] = {
        StatisticsBreakdown(runs: runs, type: runStatistic.type, filter: .week).chartStatistics()
    }()

    private func chartData() -> [ChartDataSection] {

        var statistics = StatisticsBreakdown(runs: runs, type: runStatistic.type, filter: selectedFilter).chartStatistics()

        // The TabView in the chart will not select the last page when switching filter with the segmented control if the number of pages in the TabView is less than the previous one. We add empty sections here just to make all charts have the same number of sections.
        if selectedFilter != .allTime {
            let numberOfSections = weekData.count // The week data will have the most number of sections.
            for _ in (0...(numberOfSections - statistics.count)) {
                statistics.append(RunStatisticSection(title: "", runStatistics: []))
            }
        }

        func shortTitle(runStatistic: RunStatistic, filter: StatisticsBreakdownFilter) -> String {
            switch filter {
            case .week:
                return String(runStatistic.title.first ?? " ")
            case .month:
                return runStatistic.title.filter { $0.isNumber }
            case .quarter:
                return runStatistic.title.filter { $0.isNumber }
            case .year:
                return String(runStatistic.title.first ?? " ")
            case .allTime:
                return runStatistic.title
            }
        }

        return statistics.map {
            ChartDataSection(
                title: $0.title,
                data: $0.runStatistics.map {
                    ChartData(
                        value: $0.value,
                        title: $0.title,
                        shortTitle: shortTitle(runStatistic: $0, filter: selectedFilter)
                    )
                }.reversed())
        }.reversed()
    }

    private func chartValueFormatter() -> (Double) -> String {
        let unitType = runStatistic.type.unitType

        switch unitType {
        case .distance:
            return { value in
                guard let formattedDistance = DistanceFormatter.format(distance: value) else {
                    return ""
                }

                let unit = self.runStatistic.unitSymbol
                return "\(formattedDistance) \(unit)"
            }
        case .speed:
            return { value in PaceFormatter.format(pace: Seconds(value)) ?? "" }
        case .time:
            return { value in TimeFormatter.format(time: Seconds(value)) ?? "" }
        case .count:
            return { value in String(Int(value)) }
        }
    }
}
