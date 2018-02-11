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

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var runDataSummaryView: RunDataSummaryView!
    @IBOutlet private weak var runSummaryMapView: RunSummaryMapView!

    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        runDataSummaryView.run = run
        runSummaryMapView.run = run
        runSummaryMapView.delegate = self
        
        if let navigationController = navigationController, navigationController.viewControllers.count == 1 {
            addCLoseBarButtonItem()
        }
        
        setupDateLabel()
        setupTimeLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let splitTimesViewController = segue.destination as? SplitTimesViewController {
            splitTimesViewController.splitTimes = run?.splitTimes()
        }
        
        if let runRatingPageViewController = segue.destination as? RunRatingPageViewController {
            runRatingPageViewController.run = run
        }
        
        if let mapViewController = segue.destination as? MapViewController {
            mapViewController.run = run
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
    
    private func setupDateLabel() {
        guard let date = run?.timestamp else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateText = dateFormatter.string(from: date)
        dateLabel.text = dateText
    }
    
    private func setupTimeLabel() {
        guard let startDate = run?.startDate, let endDate = run?.endDate else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let timeText = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        timeLabel.text = timeText
    }
    
}

extension RunDetailsViewController: RunSummaryMapViewDelegate {
    func runSummaryMapViewDidGetPressed(_ runSummaryMapView: RunSummaryMapView) {
        performSegue(withIdentifier: "MapViewControllerSegueIdentifier", sender: run)
    }
}
