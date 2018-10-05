//
//  RunStatisticCollectionViewCell.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-12.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunStatisticCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var runStatisticView: RunStatisticView!
    @IBOutlet weak var backgroundColorView: UIView!
    
    var runStatistic: RunStatistic? {
        didSet {
            guard let runStatistic = runStatistic else { return }
            runStatisticView.statistic = runStatistic
        }
    }
    
}
