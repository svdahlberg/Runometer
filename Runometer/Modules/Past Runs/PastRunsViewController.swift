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
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var runs: [Run]? {
        didSet {
            refreshControl.endRefreshing()
            tableView.reloadData()
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadRuns), for: .valueChanged)
        return refreshControl
    }()
    
    private var tableViewSections: [RunSection]? {
        guard let runs = runs else { return nil }
        return RunSection.runSections(from: runs, filter: .month)
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
        tableView.refreshControl = refreshControl
        tableView.removeTrailingSeparators()
        loadRuns()
    }
    
    @objc private func loadRuns() {
        RunProvider().runs { [weak self] (runs: [Run]) in
            self?.runs = runs
            self?.activityIndicatorView.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let runDetailsViewController = segue.destination as? RunDetailsViewController {
            if let run = sender as? CoreDataRun {
                runDetailsViewController.run = run
            }
            if let run = sender as? HealthKitRun {
                runDetailsViewController.run = run
            }
        }
    }
}

extension PastRunsViewControlller: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let run = run(for: indexPath), run is CoreDataRun else {
            return .none
        }
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let run = run(for: indexPath) else { return }
            RunPersister().delete(run)
            loadRuns()
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
