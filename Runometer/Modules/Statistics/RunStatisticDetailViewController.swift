//
//  RunStatisticDetailViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

enum StatisticsBreakdownFilter {
    case year, month, day
    
    var title: String {
        switch self {
        case .day: return "Day"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
}

struct StatisticsBreakdown {
    
    private let runs: [Run]
    
    init(runs: [Run]) {
        self.runs = runs
    }
    
    func statistics(of type: RunStatisticType, with filter: StatisticsBreakdownFilter) -> [RunStatistic] {
        let runSections = RunSection.runSections(from: runs, filter: filter)

        return runSections.compactMap { (runSection: RunSection) in
            Statistics(runs: runSection.runs).statistic(of: type, with: runSection.title)
        }
    }

    func chartStatistics(of type: RunStatisticType, with filter: StatisticsBreakdownFilter) -> [RunStatistic] {
        let runSections = RunSection.runSections(from: runs, filter: filter, titleDateFormatter: chartTitleDateFormatter(for: filter))

        return runSections.compactMap { (runSection: RunSection) in
            Statistics(runs: runSection.runs).statistic(of: type, with: runSection.title)
        }
    }

    private func chartTitleDateFormatter(for filter: StatisticsBreakdownFilter) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch filter {
        case .year: dateFormatter.dateFormat = "yyyy"
        case .month: dateFormatter.dateFormat = "MMM"
        case .day: dateFormatter.dateFormat = "d"
        }
        return dateFormatter
    }
    
}

class RunStatisticDetailViewController: UIViewController {
    
    @IBOutlet private weak var statisticsBackgroundView: UIView!
    @IBOutlet private weak var statisticView: RunStatisticView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var chartContainerView: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var closeButtonContainerView: UIVisualEffectView!
    @IBOutlet private weak var toggleViewButton: UIButton!
    private var chartViewHostingController: ChartViewHostingController?

    var runStatistic: RunStatistic?
    var runs: [Run] = []

    private var runStatisticsBreakdown: [RunStatistic]? {
        didSet {
            tableView.reloadData()
            chartViewHostingController?.chartData = self.chartData()
        }
    }

    enum PresentationState {
        case list, chart

        mutating func toggle() {
            self = self == .list ? .chart : .list
        }

        var buttonTitle: String {
            switch self {
            case .chart: return "List"
            case .list: return "Chart"
            }
        }
    }

    private var presentationState: PresentationState = .chart {
        didSet {
            updatePresentationState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticView.statistic = runStatistic
        setupSegmentedControl()
        loadStatisticsBreakdown()
        
        segmentedControl.alpha = 0
        closeButtonContainerView.alpha = 0
        toggleViewButton.alpha = 0
        tableView.removeTrailingSeparators()

        updatePresentationState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.15) {
            self.segmentedControl.alpha = 1
            self.closeButtonContainerView.alpha = 1
            self.toggleViewButton.alpha = 1
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.chartViewHostingController = segue.destination as? ChartViewHostingController
    }

    private func loadStatisticsBreakdown() {
        guard let runStatistic = runStatistic else { return }
        runStatisticsBreakdown = StatisticsBreakdown(runs: runs).statistics(of: runStatistic.type, with: selectedFilter)
    }

    private func chartData() -> [ChartData] {
        guard let runStatistic = runStatistic else { return [] }
        let statistics = StatisticsBreakdown(runs: runs).chartStatistics(of: runStatistic.type, with: selectedFilter)
        return statistics.map { ChartData(value: $0.value, title: $0.title) }.reversed()
    }

    @IBAction private func didPressCloseButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    private let filters: [StatisticsBreakdownFilter] = [.day, .month, .year]
    
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

    @IBAction private func didPressToggleViewButton(_ sender: UIButton) {
        presentationState.toggle()
    }

    private func updatePresentationState() {
        toggleViewButton.setTitle(presentationState.buttonTitle, for: .normal)

        switch presentationState {
        case .chart:
            tableView.isHidden = true
            chartContainerView.isHidden = false
        case .list:
            tableView.isHidden = false
            chartContainerView.isHidden = true
        }
    }

}

extension RunStatisticDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runStatisticsBreakdown?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunStatisticTableViewCellReuseIdentifier", for: indexPath)
        if let runStatistic = runStatisticsBreakdown?[indexPath.row], let value = runStatistic.formattedValue {
            cell.textLabel?.text = runStatistic.title
            cell.detailTextLabel?.text = value + " " + runStatistic.unitSymbol
        }
        return cell
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
