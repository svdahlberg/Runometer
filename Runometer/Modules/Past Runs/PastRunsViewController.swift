//
//  PastRunsViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class PastRunsViewControlller: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var runs: [Run]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var titleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
    private var tableViewSections: [RunSection]? {
        guard let runs = runs else { return nil }
        return RunSection.runSections(from: runs, titleDateFormatter: titleDateFormatter)
    }
    
    private func tableViewSection(for section: Int) -> RunSection? {
        return tableViewSections?[section]
    }
    
    private func run(for indexPath: IndexPath) -> Run? {
        return tableViewSection(for: indexPath.section)?.runs[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Past Runs"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runs = RunProvider().savedRuns()
        
        HealthKitRunProvider().runs()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let runDetailsViewController = segue.destination as? RunDetailsViewController {
            runDetailsViewController.run = sender as? Run
        }
    }
}

extension PastRunsViewControlller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let run = run(for: indexPath) else { return }
            RunProvider.delete(run)
            runs = RunProvider().savedRuns()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let run = run(for: indexPath) else { return }
        performSegue(withIdentifier: "RunDetailsSegueIdentifier", sender: run)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PastRunsViewControlller: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSection(for: section)?.runs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastRunTableViewCellIdentifier", for: indexPath) as! PastRunTableViewCell
        cell.run = run(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = tableViewSection(for: section)?.title else { return nil }
        return PastRunsTableViewSectionHeaderView(title: title)
    }

}
