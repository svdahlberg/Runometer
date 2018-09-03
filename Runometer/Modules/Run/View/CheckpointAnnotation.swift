//
//  CheckpointAnnotation.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-15.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import MapKit

class CheckpointAnnotation: MKPointAnnotation {
    let checkpoint: Checkpoint
    init(checkpoint: Checkpoint) {
        self.checkpoint = checkpoint
        super.init()
        title = TimeFormatter.format(time: checkpoint.time)
        subtitle = PaceFormatter.pace(fromDistance: checkpoint.distanceBetweenCheckpoints, time: checkpoint.timeSinceLastCheckpoint)
        coordinate = checkpoint.location.coordinate
    }
}


class StartAnnotation: MKPointAnnotation {
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        title = "Start"
        self.coordinate = coordinate
    }
}


class EndAnnotation: MKPointAnnotation {
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        title = "End"
        self.coordinate = coordinate
    }
}

