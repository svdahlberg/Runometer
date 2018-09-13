//
//  RunStatisticCollectionViewCell.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-12.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunStatisticCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var runStatisticView: RunStatisticView!
    
    var runStatistic: RunStatistic? {
        didSet {
            guard let runStatistic = runStatistic else { return }
            runStatisticView.statistic = runStatistic
        }
    }
    
}
