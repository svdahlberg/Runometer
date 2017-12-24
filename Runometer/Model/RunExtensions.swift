//
//  RunExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Run {
    convenience init(context: NSManagedObjectContext, distance: Meters, time: Seconds, locationSegments: [[CLLocation]], date: Date = Date()) {
        self.init(context: context)
        self.distance = distance
        self.duration = Int16(time)
        self.timestamp = date
        
        for locationSegment in locationSegments {
            let runSegmentObject = RunSegment(context: context)
            for location in locationSegment {
                let locationObject = Location(context: context)
                locationObject.timestamp = location.timestamp
                locationObject.latitude = location.coordinate.latitude
                locationObject.longitude = location.coordinate.longitude
                runSegmentObject.addToLocations(locationObject)
            }
            self.addToRunSegments(runSegmentObject)
        }
    }
    
    func locationSegments() -> [[CLLocation]]? {
        guard let runSegments = runSegments else { return nil }
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
    
    func flattenedCoordinateSegments() -> [CLLocationCoordinate2D]? {
        guard let segments = coordinateSegments() else { return nil }
        return segments.flatMap { $0 }
    }
    
    func coordinateSegments() -> [[CLLocationCoordinate2D]]? {
        return locationSegments()?.map {
            $0.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
        }
    }
    
    func reachedCheckpoints(distanceUnit: DistanceUnit = AppConfiguration().distanceUnit) -> [Checkpoint]? {
        guard let locationSegments = locationSegments(),
            let startTime = locationSegments.first?.first?.timestamp
        else { return nil }
        
        var checkpoints = [Checkpoint]()
        var distance: Meters = 0
        var nextCheckpoint = distanceUnit.meters
        var timeAtLastCheckpoint = startTime
        
        for locations in locationSegments {
            for (firstLocation, secondLocation) in zip(locations, locations.dropFirst()) {
                distance += secondLocation.distance(from: firstLocation)
                if distance >= nextCheckpoint {
                    let time = Seconds(secondLocation.timestamp.timeIntervalSince(startTime))
                    let timeSinceLastCheckpoint = Seconds(secondLocation.timestamp.timeIntervalSince(timeAtLastCheckpoint))
                    let checkpoint = Checkpoint(distance: distance, time: time, location: secondLocation, timeSinceLastCheckpoint: timeSinceLastCheckpoint, distanceBetweenCheckpoints: distanceUnit.meters)
                    nextCheckpoint += distanceUnit.meters
                    timeAtLastCheckpoint = secondLocation.timestamp
                    checkpoints.append(checkpoint)
                }
            }
        }
        
        return checkpoints
    }
    
    func startAnnotation() -> StartAnnotation? {
        guard let firstLocation = locationSegments()?.first?.first else { return nil }
        return StartAnnotation(coordinate: firstLocation.coordinate)
    }
    
    func endAnnotation() -> EndAnnotation? {
        guard let lastLocation = locationSegments()?.last?.last else { return nil }
        return EndAnnotation(coordinate: lastLocation.coordinate)
    }
    
    func splitTimes(distanceUnit: DistanceUnit = AppConfiguration().distanceUnit, speedUnit: SpeedUnit = AppConfiguration().speedUnit) -> [String]? {
        return reachedCheckpoints(distanceUnit: distanceUnit)?.flatMap {
            PaceFormatter.pace(fromDistance: $0.distanceBetweenCheckpoints, time: $0.timeSinceLastCheckpoint, outputUnit: speedUnit)
        }
    }
    
    func averagePace(speedUnit: SpeedUnit = AppConfiguration().speedUnit) -> Seconds {
        return PaceCalculator.pace(fromDistance: distance, time: Seconds(duration), outputUnit: speedUnit)
    }
}
