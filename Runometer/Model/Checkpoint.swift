//
//  Checkpoint.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-15.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import MapKit

struct Checkpoint {
    let distance: Meters
    let time: Seconds
    let location: CLLocation
    let timeSinceLastCheckpoint: Seconds
    let distanceBetweenCheckpoints: Meters
    
    init(distance: Meters, time: Seconds, location: CLLocation, timeSinceLastCheckpoint: Seconds, distanceBetweenCheckpoints: Meters = RunTrackerConfiguration.distanceBetweenCheckpoints) {
        self.distance = distance
        self.time = time
        self.location = location
        self.timeSinceLastCheckpoint = timeSinceLastCheckpoint
        self.distanceBetweenCheckpoints = distanceBetweenCheckpoints
    }
}
