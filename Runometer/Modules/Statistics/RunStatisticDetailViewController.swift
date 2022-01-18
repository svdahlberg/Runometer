//
//  RunStatisticDetailViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

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

class RunStatisticDetailViewController: UIViewController {

    private enum Section {
        case chart(ChartModel)
        case list(RunStatisticSection)
    }

    private var sections: [Section] {
        let listSections = runStatisticSections?.map { Section.list($0) } ?? []

        return [
            .chart(ChartModel(
                dataSections: chartData(),
                valueFormatter: chartValueFormatter(),
                pagingEnabled: selectedFilter != .year
            ))
        ] + listSections
    }
    
    @IBOutlet private weak var statisticsBackgroundView: UIView!
    @IBOutlet private weak var statisticView: RunStatisticView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var chartContainerView: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var closeButtonContainerView: UIVisualEffectView!

    var runStatistic: RunStatistic?
    var runs: [Run] = []

    private var runStatisticSections: [RunStatisticSection]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticView.statistic = runStatistic
        setupSegmentedControl()
        loadStatisticsBreakdown()
        
        segmentedControl.alpha = 0
        closeButtonContainerView.alpha = 0
        tableView.removeTrailingSeparators()

        if #available(iOS 14.0, *) {
            tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: "ChartTableViewCellReuseIdentifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.15) {
            self.segmentedControl.alpha = 1
            self.closeButtonContainerView.alpha = 1
        }
    }

    private func loadStatisticsBreakdown() {
        guard let runStatistic = runStatistic else { return }
        runStatisticSections = StatisticsBreakdown(runs: runs, type: runStatistic.type, filter: selectedFilter).listStatistics()
    }

    private func chartData() -> [ChartDataSection] {
        guard let runStatistic = runStatistic else { return [] }
        let statistics = StatisticsBreakdown(runs: runs, type: runStatistic.type, filter: selectedFilter).chartStatistics()

        func shortTitle(runStatistic: RunStatistic, filter: StatisticsBreakdownFilter) -> String {
            switch filter {
            case .week:
                return runStatistic.title.filter { $0.isNumber }
            case .month:
                return String(runStatistic.title.first ?? " ")
            case .year:
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
        guard let unitType = runStatistic?.type.unitType else {
            return { _ in "" }
        }

        switch unitType {
        case .distance:
            return { value in
                guard let formattedDistance = DistanceFormatter.format(distance: value),
                      let unit = self.runStatistic?.unitSymbol else {
                    return ""
                }

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

    @IBAction private func didPressCloseButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    private let filters = StatisticsBreakdownFilter.allCases
    
    private var selectedFilter: StatisticsBreakdownFilter {
        return filters[segmentedControl.selectedSegmentIndex]
    }
    
    private func setupSegmentedControl() {
        filters.enumerated().forEach {
            segmentedControl.setTitle($1.title, forSegmentAt: $0)
        }
    }
    
    @IBAction private func didChangeSegmentedControlValue(_ sender: Any) {
        loadStatisticsBreakdown()
    }

}

extension RunStatisticDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .chart(let chartModel):
            return chartModel.dataSections.isEmpty ? 0 : 1
        case .list(let runStatisticSection):
            return runStatisticSection.runStatistics.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .chart(let chartModel):
            if #available(iOS 14.0, *) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCellReuseIdentifier", for: indexPath) as? ChartTableViewCell else {
                    return UITableViewCell()
                }
                cell.chartModel = chartModel
                return cell
            } else {
                return UITableViewCell()
            }
        case .list(let section):
            let cell = tableView.dequeueReusableCell(withIdentifier: "RunStatisticTableViewCellReuseIdentifier", for: indexPath)
            let runStatistic = section.runStatistics[indexPath.row]
            if let value = runStatistic.formattedValue {
                cell.textLabel?.text = runStatistic.title
                cell.detailTextLabel?.text = value + " " + runStatistic.unitSymbol
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .chart:
            return nil
        case .list(let section):
            return section.title
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .chart:
            return nil
        case .list(let section):
            guard let title = section.title else { return nil }
            return PastRunsTableViewSectionHeaderView(title: title)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .chart:
            return 0
        case .list(let section):
            guard section.title != nil else { return 0 }
            return UITableView.automaticDimension
        }
    }

}

extension RunStatisticDetailViewController: UITableViewDelegate {
    
}

extension RunStatisticDetailViewController: RunStatisticsDetailTransitionViewController {
    
    func runStatisticsView() -> RunStatisticView {
        return statisticView
    }
    
    func backgroundView() -> UIView {
        return statisticsBackgroundView
    }
    
}
