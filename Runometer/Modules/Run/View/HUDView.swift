//
//  HUDView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-07.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class HUDView: UIView {
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var paceLabel: UILabel!
    @IBOutlet private weak var distanceUnitLabel: UILabel!
    @IBOutlet private weak var paceUnitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        distanceLabel.text = DistanceFormatter.format(distance: 0)
        timeLabel.text = TimeFormatter.format(time: 0)
        paceLabel.text = PaceFormatter.pace(fromDistance: 0, time: 0)
        distanceUnitLabel.text = Settings().distanceUnit.symbol
        paceUnitLabel.text = Settings().speedUnit.symbol
    }
    
    var distance: Meters? {
        didSet {
            guard let distance = distance, let formattedDistance = DistanceFormatter.format(distance: distance) else {
                distanceLabel.text = DistanceFormatter.format(distance: 0)
                return
            }
            distanceLabel.text = formattedDistance
        }
    }
    
    var time: Seconds? {
        didSet {
            guard let time = time, let formattedTime = TimeFormatter.format(time: time) else {
                timeLabel.text = TimeFormatter.format(time: 0)
                return
            }
            timeLabel.text = formattedTime
            updatePaceLabel()
        }
    }
    
    private func updatePaceLabel() {
        guard let distance = distance, let time = time, let formattedPace = PaceFormatter.pace(fromDistance: distance, time: time) else {
            paceLabel.text = PaceFormatter.pace(fromDistance: 0, time: 0)
            return
        }
        paceLabel.text = formattedPace
    }
}
