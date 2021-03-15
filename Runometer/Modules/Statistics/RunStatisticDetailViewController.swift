//
//  RunStatisticDetailViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunStatisticDetailViewController: UIViewController {

    private enum Section {
        @available(iOS 14.0, *)
        case chart(ChartModel)
        case list(RunStatisticSection)
    }

    private var sections: [Section] {
        let listSections = runStatisticSections?.map { Section.list($0) } ?? []

        if #available(iOS 14.0, *) {
            return [
                .chart(ChartModel(
                    dataSections: chartData(),
                    valueFormatter: chartValueFormatter(),
                    pagingEnabled: selectedFilter != .year
                ))
            ] + listSections
        } else {
            return listSections
        }
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

    @available(iOS 14.0, *)
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
        case .chart:
            return 1
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
