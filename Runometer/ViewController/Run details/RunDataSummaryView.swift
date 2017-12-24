//
//  RunDataSummaryView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunDataSummaryView: UIView {    
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var paceLabel: UILabel!
    @IBOutlet private weak var distanceUnitLabel: UILabel!
    @IBOutlet private weak var timeUnitLabel: UILabel!
    @IBOutlet private weak var paceUnitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        distanceUnitLabel.text = AppConfiguration().distanceUnit.symbol
        timeUnitLabel.text = "Time"
        paceUnitLabel.text = AppConfiguration().speedUnit.symbol
    }
    
    var run: Run? {
        didSet {
            guard let run = run,
                let formattedDistance = DistanceFormatter.format(distance: run.distance),
                let formattedTime = TimeFormatter.format(time: Seconds(run.duration)),
                let formattedPace = PaceFormatter.pace(fromDistance: run.distance, time: Seconds(run.duration)) else {
                    return
            }
            distanceLabel.text = formattedDistance
            timeLabel.text = formattedTime
            paceLabel.text = formattedPace
        }
    }
}

