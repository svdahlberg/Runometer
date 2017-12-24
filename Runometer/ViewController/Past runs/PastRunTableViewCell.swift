//
//  PastRunTableViewCell.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class PastRunTableViewCell: UITableViewCell {
    
    var run: Run? {
        didSet {
            guard let run = run,
                let formattedDistance = DistanceFormatter.format(distance: run.distance) else { return }
            textLabel?.text = formattedDistance
        }
    }
}
