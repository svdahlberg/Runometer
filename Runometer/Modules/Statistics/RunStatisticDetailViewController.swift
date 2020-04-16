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
    
    var titleDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        switch self {
        case .year: dateFormatter.dateFormat = "yyyy"
        case .month: dateFormatter.dateFormat = "MMMM yyyy"
        case .day: dateFormatter.dateFormat = "MMMM d yyyy"
        }
        return dateFormatter
    }
    
    var title: String {
        switch self {
        case .day: return "Day"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
}

struct StatisticsBreakdown {
    
    let runProvider: RunProvider
    
    init(runProvider: RunProvider = RunProvider()) {
        self.runProvider = runProvider
    }
    
    func statistics(of type: RunStatisticType, with filter: StatisticsBreakdownFilter, completion: @escaping ([RunStatistic]) -> Void) {
        runProvider.runs { runs in
            let runSections = RunSection.runSections(from: runs, titleDateFormatter: filter.titleDateFormatter)
            
            let statistics: [RunStatistic] = runSections.compactMap { (runSection: RunSection) in
                Statistics(runs: runSection.runs).statistic(of: type, with: runSection.title)
            }
            
            completion(statistics)
        }
        
    }
    
}

class RunStatisticDetailViewController: UIViewController {
    
    @IBOutlet private weak var statisticsBackgroundView: UIView!
    @IBOutlet private weak var statisticView: RunStatisticView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var closeButton: UIButton!
    
    var runStatistic: RunStatistic?
    
    private var runStatisticsBreakdown: [RunStatistic]? {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticView.statistic = runStatistic
        setupSegmentedControl()
        loadStatisticsBreakdown()
        
        segmentedControl.alpha = 0
        closeButton.alpha = 0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.15) {
            self.segmentedControl.alpha = 1
            self.closeButton.alpha = 1
        }
    }
    
    private func loadStatisticsBreakdown() {
        guard let runStatistic = runStatistic else { return }
        StatisticsBreakdown().statistics(of: runStatistic.type, with: selectedFilter) { [weak self] runStatistics in
            self?.runStatisticsBreakdown = runStatistics
        }
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