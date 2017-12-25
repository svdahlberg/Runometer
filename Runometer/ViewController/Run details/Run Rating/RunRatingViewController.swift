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
    
    var runometerViewPercentage: CGFloat?
    var runometerViewValue: String?
    var runometerViewUnitName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let percentage = runometerViewPercentage,
            let value = runometerViewValue,
            let unitName = runometerViewUnitName
        {
            runometerView.percentage = percentage
            runometerView.value = value
            runometerView.unitName = unitName
        }
    }
}

