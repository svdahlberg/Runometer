//
//  RunStatisticsFilterViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/19/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import UIKit

protocol RunStatisticsFilterViewControllerDelegate: AnyObject {
    func runStatisticsFilterViewController(_ runStatisticsFilterViewController: RunStatisticsFilterViewController, didSelect filter: RunGroup)
}

class RunStatisticsFilterViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    weak var delegate: RunStatisticsFilterViewControllerDelegate?

    var filters: [RunGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Show statistics for..."
        tableView.removeTrailingSeparators()
    }

}

extension RunStatisticsFilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunStatisticFilterTableViewCell", for: indexPath)
        cell.textLabel?.text = filters[indexPath.row].name.firstLetterCapitalized()        
        return cell
    }

}

extension RunStatisticsFilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        delegate?.runStatisticsFilterViewController(self, didSelect: filter)
    }

}
