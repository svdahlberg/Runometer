//
//  PastRunTableViewCell.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class PastRunTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var run: RunProtocol? {
        didSet {
            guard let run = run,
                let formattedDistance = DistanceFormatter.format(distance: run.distance),
                let formattedTime = TimeFormatter.format(time: Seconds(run.duration))
                else { return }
            
            distanceLabel?.text = "\(formattedDistance) \(Settings().distanceUnit.symbol)"
            timeLabel.text = "\(formattedTime)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateLabel.text = dateFormatter.string(from: run.endDate)
        }
    }
}
