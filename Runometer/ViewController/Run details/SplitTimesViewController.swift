//
//  SplitTimesViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-18.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class SplitTimesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    var splitTimes: [String]?
}

extension SplitTimesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitTimes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "splitTimeTableViewCellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = "\(AppConfiguration().distanceUnit.name.capitalized) \(indexPath.row + 1)"
        cell.detailTextLabel?.text = splitTimes?[indexPath.row]
        return cell
    }
}
