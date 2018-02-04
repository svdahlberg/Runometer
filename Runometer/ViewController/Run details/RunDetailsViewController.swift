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

    @IBOutlet private weak var runDataSummaryView: RunDataSummaryView!
    @IBOutlet private weak var runSummaryMapView: RunSummaryMapView!

    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        runDataSummaryView.run = run
        runSummaryMapView.run = run
        
        if let navigationController = navigationController, navigationController.viewControllers.count == 1 {
            addCLoseBarButtonItem()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let splitTimesViewController = segue.destination as? SplitTimesViewController {
            splitTimesViewController.splitTimes = run?.splitTimes()
        }
        
        if let runRatingPageViewController = segue.destination as? RunRatingPageViewController {
            runRatingPageViewController.run = run
        }
    }
    
    private func addCLoseBarButtonItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc private func doneButtonPressed() {
        let presentingViewController = navigationController?.presentingViewController
        dismiss(animated: true) {
            presentingViewController?.dismiss(animated: true)
        }
    }
    
}


