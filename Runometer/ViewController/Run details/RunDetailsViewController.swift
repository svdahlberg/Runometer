//
//  RunDetailsViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit
import MapKit

class RunDetailsViewController: UIViewController {
    @IBOutlet private weak var runRatingView: RunRatingView!
    @IBOutlet private weak var runDataSummaryView: RunDataSummaryView!
    @IBOutlet private weak var runSummaryMapView: RunSummaryMapView!

    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runRatingView.run = run
        runDataSummaryView.run = run
        runSummaryMapView.run = run
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let splitTimesViewController = segue.destination as? SplitTimesViewController {
            splitTimesViewController.splitTimes = run?.splitTimes()
        }
    }
    
}


