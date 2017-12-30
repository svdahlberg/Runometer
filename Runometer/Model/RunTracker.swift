//
//  LocationManagerWrapper.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-01.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreLocation

struct RunTrackerConfiguration {
    static let distanceFilter: Double = 10
    static let horizontalAccuracyFilter: Double = 20
    static let timeSinceLastLocationFilter: TimeInterval = 10
    static let timerInterval: TimeInterval = 1
    static let distanceBetweenCheckpoints: Meters = AppConfiguration().distanceUnit.meters
}

protocol RunTrackerDelegate: class {
    func willUpdateLocations(withLocations locations: [CLLocation])
    func didUpdateDistance(_ distance: Meters)
    func didUpdateTime(_ time: Seconds)
    func didReachCheckpoint(_ checkpoint: Checkpoint)
}

class RunTracker: NSObject {
    weak var delegate: RunTrackerDelegate?
    private(set) var runSegments: [[CLLocation]]
    private var currentRunSegmentIndex: Int {
        return runSegments.count >= 0 ? runSegments.count - 1 : 0
    }
    private(set) var distance: Meters {
        didSet {
            delegate?.didUpdateDistance(distance)
            updateCheckpoint()
        }
    }
    private(set) var time: Seconds {
        didSet { delegate?.didUpdateTime(time) }
    }
    private let locationManager: CLLocationManager
    private var timer: Timer?
    private var nextChekpointDistance: Meters
    private var checkpoints: [Checkpoint]
    private var timeSinceLastCheckpoint: Seconds {
        guard let lastCheckpoint = checkpoints.last else { return time }
        return time - lastCheckpoint.time
    }
    
    override init() {
        locationManager = CLLocationManager()
        runSegments = []
        distance = 0
        time = 0
        checkpoints = []
        nextChekpointDistance = RunTrackerConfiguration.distanceBetweenCheckpoints
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = RunTrackerConfiguration.distanceFilter
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        runSegments.append([])
        locationManager.startUpdatingLocation()
        timer = Timer.scheduledTimer(withTimeInterval: RunTrackerConfiguration.timerInterval, repeats: true) { _ in 
            self.fireTimer()
        }
    }
    
    private func fireTimer() {
        time += Int(RunTrackerConfiguration.timerInterval)
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
    }
    
    func reset() {
        distance = 0
        time = 0
        runSegments.removeAll()
        stopTracking()
    }
    
    private func updateCheckpoint() {
        guard distance > nextChekpointDistance, let lastLocation = runSegments.last?.last else { return }
        let checkpoint = Checkpoint(distance: nextChekpointDistance, time: time, location: lastLocation, timeSinceLastCheckpoint: timeSinceLastCheckpoint)
        delegate?.didReachCheckpoint(checkpoint)
        nextChekpointDistance += RunTrackerConfiguration.distanceBetweenCheckpoints
        checkpoints.append(checkpoint)
    }
    
    func saveRun() -> Run {
        return RunService().saveRun(distance: distance, time: time, locationSegments: runSegments)
    }
}

extension RunTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocations = locations.filter { $0.horizontalAccuracy < RunTrackerConfiguration.horizontalAccuracyFilter && abs($0.timestamp.timeIntervalSinceNow) < RunTrackerConfiguration.timeSinceLastLocationFilter }
        updateDistance(fromNewLocations: newLocations)
        delegate?.willUpdateLocations(withLocations: newLocations)
        addLocations(newLocations)
    }
    
    private func addLocations(_ locations: [CLLocation]) {
        guard !runSegments.isEmpty else { return }
        runSegments[currentRunSegmentIndex].append(contentsOf: locations)
    }
    
    private func updateDistance(fromNewLocations locations: [CLLocation]) {
        guard let lastLocation = self.runSegments.last?.last else { return }
        locations.forEach {
            let delta = $0.distance(from: lastLocation)
            distance += delta
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }
}




