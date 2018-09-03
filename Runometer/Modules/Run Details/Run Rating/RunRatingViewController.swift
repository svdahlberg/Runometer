//
//  RunRatingViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunRatingViewController: UIViewController {
    @IBOutlet private weak var runometerView: RunometerView!
    @IBOutlet private weak var ratingDescriptionLabel: UILabel!
    
    var runometerViewPercentage: CGFloat?
    var runometerViewValue: String?
    var runometerViewUnitName: String?
    var ratingDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let percentage = runometerViewPercentage,
            let value = runometerViewValue,
            let unitName = runometerViewUnitName,
            let ratingDescription = ratingDescription
        {
            runometerView.percentage = percentage
            runometerView.value = value
            runometerView.unitName = unitName
            ratingDescriptionLabel.text = ratingDescription
        }
    }
}

