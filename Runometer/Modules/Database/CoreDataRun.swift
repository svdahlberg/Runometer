//
//  CoreDataRun.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreData
import CoreLocation

struct CoreDataRun: RunProtocol {
    
    var distance: Meters
    var duration: Seconds
    var startDate: Date
    var endDate: Date
    
    let managedRunObject: ManagedRunObject
    
    init(managedRunObject: ManagedRunObject, distance: Meters, duration: Seconds, startDate: Date, endDate: Date) {
        self.managedRunObject = managedRunObject
        self.distance = distance
        self.duration = duration
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(managedRunObject: ManagedRunObject) {
        self.managedRunObject = managedRunObject
        self.distance = managedRunObject.distance
        self.duration = Seconds(managedRunObject.duration)
        self.startDate = managedRunObject.startDate!
        self.endDate = managedRunObject.endDate!
    }
    
    func locationSegments() -> [[CLLocation]]? {
        guard let runSegments = managedRunObject.runSegments else { return nil }
        var segments = [[CLLocation]]()
        for segment in runSegments {
            guard let locations = (segment as? RunSegment)?.locations else { break }
            var clLocations = [CLLocation]()
            for location in locations {
                guard let location = location as? Location, let timestamp = location.timestamp else { break }
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let clLocation = CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: timestamp)
                clLocations.append(clLocation)
            }
            segments.append(clLocations)
        }
        return segments
    }
    
}
