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
    
    @IBOutlet private weak var statisticView: RunStatisticView!
    @IBOutlet private weak var tableView: UITableView!
    
    var runStatistic: RunStatistic?
    
    private var runStatisticsBreakdown: [RunStatistic]? {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticView.statistic = runStatistic
        
        loadStatisticsBreakdown()
    }
    
    private func loadStatisticsBreakdown() {
        guard let runStatistic = runStatistic else { return }
        StatisticsBreakdown().statistics(of: runStatistic.type, with: .month) { [weak self] runStatistics in
            self?.runStatisticsBreakdown = runStatistics
        }
    }

    @IBAction private func didPressCloseButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
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
