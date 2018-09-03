//
//  SettingsTableViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-18.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet private weak var distanceUnitSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var audioDistanceSwitch: UISwitch!
    @IBOutlet private weak var audioTimeSwitch: UISwitch!
    @IBOutlet private weak var audioAveragePaceSwitch: UISwitch!
    @IBOutlet private weak var audioTriggerSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var audioTimingIntervalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distanceUnitSegmentedControl.selectedSegmentIndex = Settings().distanceUnit == .kilometers ? 0 : 1
        audioDistanceSwitch.isOn = Settings().shouldGiveDistanceAudioFeedback
        audioTimeSwitch.isOn = Settings().shouldGiveTimeAudioFeedback
        audioAveragePaceSwitch.isOn = Settings().shouldGiveAveragePaceAudioFeedback
        audioTriggerSegmentedControl.selectedSegmentIndex = Settings().audioTrigger == .distance ? 0 : 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAudioTimingLabel()
    }
    
    private func updateAudioTimingLabel() {
        let audioTimingIntervalLabelPostfix = Settings().audioTrigger == .distance ? Settings().distanceUnit.symbol : "min"
        audioTimingIntervalLabel.text = "\(Settings().audioTimingInterval.trailingZeroRemoved()) \(audioTimingIntervalLabelPostfix)"
    }
    
    @IBAction private func didChangeValueOfDistanceSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: Settings().distanceUnit = .kilometers
        case 1: Settings().distanceUnit = .miles
        default: break
        }

        Settings().resetAudioTimingInterval()
        updateAudioTimingLabel()
    }
    
    @IBAction private func didToggleAudioDistanceSwitch(_ sender: UISwitch) {
        Settings().shouldGiveDistanceAudioFeedback = sender.isOn
    }
    
    @IBAction private func didToggleAudioTimeSwitch(_ sender: UISwitch) {
        Settings().shouldGiveTimeAudioFeedback = sender.isOn
    }
    
    @IBAction private func didToggleAudioAveragePaceSwitch(_ sender: UISwitch) {
        Settings().shouldGiveAveragePaceAudioFeedback = sender.isOn
    }
    
    @IBAction private func didChangeValueOfAudioTriggerSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: Settings().audioTrigger = .distance
        case 1: Settings().audioTrigger = .time
        default: break
        }

        Settings().resetAudioTimingInterval()
        updateAudioTimingLabel()
    }
    
    @IBAction private func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension SettingsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 2
        default: return 0
        }
    }
}



