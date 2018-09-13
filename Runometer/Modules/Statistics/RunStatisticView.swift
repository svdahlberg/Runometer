//
//  RunStatisticView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-10.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit


@IBDesignable class RunStatisticView: UIView {
    
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBInspectable var valueFontSize: CGFloat = 55 {
        didSet {
            valueLabel.font = valueLabel.font.withSize(valueFontSize)
        }
    }
    @IBInspectable var titleFontSize: CGFloat = 17
    @IBInspectable var unitFontSize: CGFloat = 17
    
    var statistic: RunStatistic? {
        didSet {
            guard let statistic = statistic,
                let formattedValue = statistic.formattedValue else { return }
            valueLabel.text = formattedValue
            unitLabel.text = statistic.unitSymbol
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
