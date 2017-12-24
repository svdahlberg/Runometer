//
//  AudioIntervalSelectionTableViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-19.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class AudioIntervalSelectionTableViewController: UITableViewController {
    
    private var intervals: [Double] = AppConfiguration().audioIntervals
    
    private var intervalUnitName: String {
        switch AppConfiguration().audioTrigger {
        case .time: return "minutes"
        case .distance: return AppConfiguration().distanceUnit.name.lowercased()
        }
    }
    
    private var intervalTitles: [String] {
        return intervals.map { "\($0.trailingZeroRemoved()) \(intervalUnitName)" }
    }
    
    private var selectedIntervalIndex: Int? {
        return intervals.index(of: AppConfiguration().audioTimingInterval)
    }
    
}

extension AudioIntervalSelectionTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intervals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioIntervalTableViewCellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = intervalTitles[indexPath.row]
        if let selectedIntervalIndex = selectedIntervalIndex, indexPath.row == selectedIntervalIndex {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        Settings.shared.audioTimingInterval = intervals[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
}
