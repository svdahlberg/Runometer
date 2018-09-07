//
//  LocationSegmentsExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-07.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreLocation

extension Array where Iterator.Element == [CLLocation] {
    
    func coordinateSegments() -> [[CLLocationCoordinate2D]] {
        return map {
            $0.map {
                CLLocationCoordinate2D(latitude: $0.coordinate.latitude,
                                       longitude: $0.coordinate.longitude)
            }
        }
    }
    
    func flattenedCoordinateSegments() -> [CLLocationCoordinate2D] {
        return coordinateSegments().flatMap { $0 }
    }
    
    func reachedCheckpoints(distanceUnit: DistanceUnit = Settings().distanceUnit) -> [Checkpoint]? {
        guard let startTime = first?.first?.timestamp else { return nil }
        
        var checkpoints = [Checkpoint]()
        var distance: Meters = 0
        var nextCheckpoint = distanceUnit.meters
        var timeAtLastCheckpoint = startTime
        
        for locations in self {
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
        guard let firstLocation = first?.first else { return nil }
        return StartAnnotation(coordinate: firstLocation.coordinate)
    }
    
    func endAnnotation() -> EndAnnotation? {
        guard let lastLocation = self.last?.last else { return nil }
        return EndAnnotation(coordinate: lastLocation.coordinate)
    }
    
    func splitTimes(distanceUnit: DistanceUnit = Settings().distanceUnit, speedUnit: SpeedUnit = Settings().speedUnit) -> [String]? {
        return reachedCheckpoints(distanceUnit: distanceUnit)?.compactMap {
            PaceFormatter.pace(fromDistance: $0.distanceBetweenCheckpoints, time: $0.timeSinceLastCheckpoint, outputUnit: speedUnit)
        }
    }
    
}
