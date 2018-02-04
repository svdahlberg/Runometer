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
        distanceUnitSegmentedControl.selectedSegmentIndex = AppConfiguration().distanceUnit == .kilometers ? 0 : 1
        audioDistanceSwitch.isOn = AppConfiguration().shouldGiveDistanceAudioFeedback
        audioTimeSwitch.isOn = AppConfiguration().shouldGiveTimeAudioFeedback
        audioAveragePaceSwitch.isOn = AppConfiguration().shouldGiveAveragePaceAudioFeedback
        audioTriggerSegmentedControl.selectedSegmentIndex = AppConfiguration().audioTrigger == .distance ? 0 : 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAudioTimingLabel()
    }
    
    private func updateAudioTimingLabel() {
        let audioTimingIntervalLabelPostfix = AppConfiguration().audioTrigger == .distance ? AppConfiguration().distanceUnit.symbol : "min"
        audioTimingIntervalLabel.text = "\(AppConfiguration().audioTimingInterval.trailingZeroRemoved()) \(audioTimingIntervalLabelPostfix)"
    }
    
    @IBAction private func didChangeValueOfDistanceSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: Settings.shared.distanceUnit = .kilometers
        case 1: Settings.shared.distanceUnit = .miles
        default: break
        }
        Settings.shared.audioTimingInterval = nil
        updateAudioTimingLabel()
    }
    
    @IBAction private func didToggleAudioDistanceSwitch(_ sender: UISwitch) {
        Settings.shared.audioFeedbackDistance = sender.isOn
    }
    
    @IBAction private func didToggleAudioTimeSwitch(_ sender: UISwitch) {
        Settings.shared.audioFeedbackTime = sender.isOn
    }
    
    @IBAction private func didToggleAudioAveragePaceSwitch(_ sender: UISwitch) {
        Settings.shared.audioFeedbackAveragePace = sender.isOn
    }
    
    @IBAction private func didChangeValueOfAudioTriggerSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: Settings.shared.audioTrigger = .distance
        case 1: Settings.shared.audioTrigger = .time
        default: break
        }
        Settings.shared.audioTimingInterval = nil
        updateAudioTimingLabel()
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



