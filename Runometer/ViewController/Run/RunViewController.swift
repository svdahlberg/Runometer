//
//  RunViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-01.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum RunState {
    case notStarted, started, paused, ended
}

class RunViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var resumeButton: UIButton!
    @IBOutlet private weak var hudView: HUDView!
    @IBOutlet private weak var closeButtonVisualEffectsView: UIVisualEffectView!
    private var runTracker: RunTracker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runTracker = RunTracker()
        runTracker.delegate = self
        runTracker.requestAuthorization()
        hudView.alpha = 0
        resumeButton.alpha = 0
        stopButton.alpha = 0
        stopButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        startButton.backgroundColor = Colors.green
        resumeButton.backgroundColor = Colors.green
        stopButton.backgroundColor = Colors.red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.centerOnUser()
    }
    
    private var runState: RunState = .notStarted {
        didSet {
            switch runState {
            case .started: startRun()
            case .paused: pauseRun()
            case .ended: endRun()
            case .notStarted: break
            }
        }
    }
    
    @IBAction private func startButtonPressed(_ sender: Any) {
        runState = .started
        mapView.addAnnotation(StartAnnotation(coordinate: mapView.userLocation.coordinate))
    }
    
    @IBAction private func stopButtonPressed(_ sender: Any) {
        runState = runState == .paused ? .ended : .paused
    }
    
    @IBAction private func resumeButtonPressed(_ sender: Any) {
        runState = .started
    }
    
    private func startRun() {
        runTracker.startTracking()
        toggleRunningUI(true)
        showHUDView()
        toggle(closeButtonVisualEffectsView, hidden: true)
    }
    
    private func pauseRun() {
        runTracker.stopTracking()
        toggleRunningUI(false)
    }
    
    private func endRun() {
        runTracker.stopTracking()
        let run = runTracker.saveRun()
        performSegue(withIdentifier: "RunDetailsSegueIdentifier", sender: run)
    }
    
    private func toggleRunningUI(_ running: Bool) {
        toggle(startButton, hidden: true) {
            self.toggle(self.stopButton, hidden: false)
        }
        
        toggle(resumeButton, hidden: running)
    }
    
    @IBAction private func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let runDetailsViewController = navigationController.viewControllers.first as? RunDetailsViewController {
            runDetailsViewController.run = sender as? Run
        }
    }
}

extension RunViewController: RunTrackerDelegate {
    func runTracker(_ runTracker: RunTracker, willAdd locations: [CLLocation]) {
        guard let lastLocation = runTracker.runSegments.last?.last else { return }
        var coordinates = [lastLocation.coordinate]
        let newCoordinates = locations.map { $0.coordinate }
        coordinates.append(contentsOf: newCoordinates)
        mapView.add(MKPolyline(coordinates: coordinates, count: coordinates.count))
        mapView.centerOnUser()
    }
    
    func runTracker(_ runTracker: RunTracker, didUpdate distance: Meters) {
        hudView.distance = distance
    }
    
    func runTracker(_ runTracker: RunTracker, didUpdate time: Seconds) {
        hudView.time = time
    }
    
    func runTracker(_ runTracker: RunTracker, didReach checkpoint: Checkpoint) {
        let checkPointAnnotation = CheckpointAnnotation(checkpoint: checkpoint)
        mapView.addAnnotation(checkPointAnnotation)
    }
}

extension RunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return self.mapView.overlayRenderer(for: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return self.mapView.annotationView(for: annotation, on: mapView)
    }
}

// MARK: Animations
private extension RunViewController {
    func showHUDView() {
        UIView.animate(withDuration: 0.5) {
            self.hudView.alpha = 1
        }
    }
    
    func toggle(_ view: UIView, hidden: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            view.alpha = hidden ? 0 : 1
            view.transform = hidden ? CGAffineTransform(scaleX: 0.1, y: 0.1) : CGAffineTransform.identity
        }) { _ in
            completion?()
        }
    }
}
