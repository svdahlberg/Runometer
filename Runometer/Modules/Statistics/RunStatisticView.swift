//
//  RunStatisticView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-10.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

struct RunStatistic {
    
    let value: Double
    let title: String
    let unit: RunUnit?
    
    var formattedValue: String? {
        switch unit {
        case is DistanceUnit:
            return DistanceFormatter.format(distance: value)
        case is SpeedUnit:
            return PaceFormatter.format(pace: Seconds(value))
        case is TimeUnit:
            return "Time"
        default:
            return nil
        }
    }
    
}

@IBDesignable class RunStatisticView: UIView {
    
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var statistic: RunStatistic? {
        didSet {
            guard let statistic = statistic,
                let formattedValue = statistic.formattedValue else { return }
            valueLabel.text = formattedValue
            unitLabel.text = statistic.unit?.symbol
            titleLabel.text = statistic.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
}
